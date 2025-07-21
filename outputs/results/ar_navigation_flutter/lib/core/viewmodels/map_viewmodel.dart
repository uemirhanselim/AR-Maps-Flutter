import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';
import '../widgets/poi_list.dart';

const String googleMapsApiKey = 'AIzaSyB8RJtVLsgsB8m8KACBso-zq6XtJ5vD-t4'; // <-- Buraya kendi API anahtarınızı girin

class MapViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final NavigationService _navigationService = NavigationService();
  
  LocationData? _currentLocation;
  List<POI> _pois = [];
  bool _isLoading = false;

  LocationData? get currentLocation => _currentLocation;
  List<POI> get pois {
    print('Getting POIs: ${_pois.length} POIs available');
    return _pois;
  }
  bool get isLoading => _isLoading;
  bool get isNavigating => _navigationService.isNavigating;
  POI? get selectedPOI => _navigationService.selectedPOI;
  NavigationService get navigationService => _navigationService;

  MapViewModel() {
    print('MapViewModel initialized');
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    print('Getting current location...');
    _isLoading = true;
    notifyListeners();
    
    _currentLocation = await _locationService.getCurrentLocation();
    
    if (_currentLocation != null) {
      print('Location obtained in ViewModel: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}');
      _loadPOIsAroundUser();
    } else {
      print('Failed to get location in ViewModel, using fallback POIs');
      _loadFallbackPOIs();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _loadPOIsAroundUser() {
    print('Loading POIs around user...');
    if (_currentLocation != null) {
      _pois = generatePOIsAroundLocation(_currentLocation);
      print('Generated ${_pois.length} POIs around user location');
      for (var poi in _pois) {
        print('POI: ${poi.name} at ${poi.latitude}, ${poi.longitude}');
      }
      print('Calling notifyListeners after POI generation');
      notifyListeners();
    } else {
      print('Cannot load POIs: no user location');
      _loadFallbackPOIs();
    }
  }

  void _loadFallbackPOIs() {
    print('Loading fallback POIs...');
    _pois = getMockPOIs();
    print('Loaded ${_pois.length} fallback POIs');
    for (var poi in _pois) {
      print('Fallback POI: ${poi.name} at ${poi.latitude}, ${poi.longitude}');
    }
    print('Calling notifyListeners after fallback POI generation');
    notifyListeners();
  }

  @override
  void notifyListeners() {
    print('MapViewModel notifyListeners called');
    super.notifyListeners();
  }

  Future<void> selectPOI(POI poi) async {
    print('POI selected: ${poi.name}');
    if (_currentLocation != null) {
      _navigationService.startNavigation(poi, _currentLocation!);
      // Google Directions API'den rota çek
      await _navigationService.fetchRouteFromGoogleDirections();
      notifyListeners();
    } else {
      print('Cannot start navigation: no user location');
    }
  }

  void stopNavigation() {
    _navigationService.stopNavigation();
    notifyListeners();
  }
} 