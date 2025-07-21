import 'package:location/location.dart';

class PermissionsUtil {
  static Future<bool> checkLocationPermission() async {
    final location = Location();
    PermissionStatus status = await location.hasPermission();
    return status == PermissionStatus.granted;
  }
} 