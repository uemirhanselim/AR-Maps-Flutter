import 'package:location/location.dart';
import '../widgets/poi_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NavigationService {
  bool _isNavigating = false;
  POI? _selectedPOI;
  LocationData? _currentLocation;
  List<LatLng> _routePoints = [];
  List<String> _navigationInstructions = [];
  int _currentStepIndex = 0;

  bool get isNavigating => _isNavigating;
  POI? get selectedPOI => _selectedPOI;
  LocationData? get currentLocation => _currentLocation;
  List<LatLng> get routePoints => _routePoints;
  List<String> get navigationInstructions => _navigationInstructions;
  int get currentStepIndex => _currentStepIndex;

  void nextStep() {
    if (_currentStepIndex < _navigationInstructions.length - 1) {
      _currentStepIndex++;
    }
  }

  void resetSteps() {
    _currentStepIndex = 0;
  }

  void startNavigation(POI poi, LocationData currentLocation) {
    print('Starting navigation to: ${poi.name}');
    _selectedPOI = poi;
    _currentLocation = currentLocation;
    _isNavigating = true;
    _generateRoute();
    _currentStepIndex = 0;
  }

  void stopNavigation() {
    print('Stopping navigation');
    _isNavigating = false;
    _selectedPOI = null;
    _routePoints.clear();
    _navigationInstructions.clear();
    _currentStepIndex = 0;
  }

  void _generateRoute() {
    if (_currentLocation == null || _selectedPOI == null) return;
    print('Generating route from ${_currentLocation!.latitude}, ${_currentLocation!.longitude} to ${_selectedPOI!.latitude}, ${_selectedPOI!.longitude}');
    // Default: straight line (fallback)
    _routePoints = [
      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      LatLng(_selectedPOI!.latitude, _selectedPOI!.longitude),
    ];
    print('Route generated with ${_routePoints.length} points');
    _navigationInstructions.clear();
    _currentStepIndex = 0;
  }

  // --- GOOGLE DIRECTIONS API ---
  Future<void> fetchRouteFromGoogleDirections() async {
    if (_currentLocation == null || _selectedPOI == null) return;
    final apiKey = "YOUR_GOOGLE_MAPS_API_KEY_HERE";
    if (apiKey == null || apiKey.isEmpty) {
      print('Google Maps API key not found in .env');
      return;
    }
    final origin = '${_currentLocation!.latitude},${_currentLocation!.longitude}';
    final destination = '${_selectedPOI!.latitude},${_selectedPOI!.longitude}';
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=walking&language=tr&key=$apiKey';
    print('Fetching route from Directions API: $url');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final polyline = data['routes'][0]['overview_polyline']['points'];
        _routePoints = decodePolyline(polyline);
        print('Directions API route decoded: ${_routePoints.length} points');
        // --- YENİ: Adımları al ---
        _navigationInstructions.clear();
        final steps = data['routes'][0]['legs'][0]['steps'];
        _lastDirectionsSteps = steps;
        for (var step in steps) {
          final htmlInstruction = step['html_instructions'] as String;
          final distance = step['distance']['text'];
          // HTML tag'lerini temizle
          final instruction = htmlInstruction.replaceAll(RegExp(r'<[^>]*>'), '');
          _navigationInstructions.add('$instruction ($distance)');
        }
        _currentStepIndex = 0;
      } else {
        print('No routes found in Directions API response');
        _generateRoute();
      }
    } else {
      print('Directions API error: ${response.statusCode}');
      _generateRoute();
    }
  }

  // Polyline decoder (Google encoded polyline algorithm)
  List<LatLng> decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  double calculateDistance() {
    if (_currentLocation == null || _selectedPOI == null) return 0.0;
    final latDiff = _selectedPOI!.latitude - _currentLocation!.latitude!;
    final lonDiff = _selectedPOI!.longitude - _currentLocation!.longitude!;
    final distance = (latDiff * latDiff + lonDiff * lonDiff).abs() * 111000;
    return distance / 1000;
  }

  String getEstimatedTime() {
    final distance = calculateDistance();
    final timeInHours = distance / 5;
    final timeInMinutes = (timeInHours * 60).round();
    if (timeInMinutes < 60) {
      return '$timeInMinutes dakika';
    } else {
      final hours = timeInMinutes ~/ 60;
      final minutes = timeInMinutes % 60;
      return '$hours saat $minutes dakika';
    }
  }

  double? getCurrentStepBearing() {
    // Returns the bearing (degrees) for the current step, if available
    if (_navigationInstructions.isEmpty || _currentStepIndex >= _navigationInstructions.length) return null;
    // For simplicity, use the step's end_location if available
    try {
      final step = _lastDirectionsStepData();
      if (step == null) return null;
      final endLoc = step['end_location'];
      if (endLoc == null) return null;
      final lat = endLoc['lat'] as double;
      final lng = endLoc['lng'] as double;
      if (_currentLocation == null) return null;
      return _calculateBearing(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
        lat,
        lng,
      );
    } catch (e) {
      return null;
    }
  }

  // Helper to get the current step's raw data (for bearing)
  Map<String, dynamic>? _lastDirectionsStepData() {
    if (_lastDirectionsSteps == null || _currentStepIndex >= _lastDirectionsSteps!.length) return null;
    return _lastDirectionsSteps![_currentStepIndex];
  }

  List<dynamic>? _lastDirectionsSteps;

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    lat1 = lat1 * math.pi / 180;
    lon1 = lon1 * math.pi / 180;
    lat2 = lat2 * math.pi / 180;
    lon2 = lon2 * math.pi / 180;
    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }
}

class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
} 