import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> requestPermission() async {
    PermissionStatus status = await _location.requestPermission();
    return status == PermissionStatus.granted;
  }

  Future<bool> checkPermission() async {
    PermissionStatus status = await _location.hasPermission();
    return status == PermissionStatus.granted;
  }

  Future<bool> checkServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await checkServiceEnabled();
      if (!serviceEnabled) {
        print('Location service is not enabled');
        return null;
      }

      // Check and request permission
      bool permissionGranted = await checkPermission();
      if (!permissionGranted) {
        permissionGranted = await requestPermission();
        if (!permissionGranted) {
          print('Location permission denied');
          return null;
        }
      }

      // Get current location
      LocationData locationData = await _location.getLocation();
      print('Location obtained: ${locationData.latitude}, ${locationData.longitude}');
      return locationData;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<LocationData?> getLastKnownLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      print('Error getting last known location: $e');
      return null;
    }
  }
} 