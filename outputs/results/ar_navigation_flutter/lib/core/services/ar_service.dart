import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:location/location.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:flutter/material.dart';
import '../widgets/poi_list.dart';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';
import '../services/navigation_service.dart';

class ARService {
  ArCoreController? _arController;
  POI? _targetPOI;
  LocationData? _currentLocation;
  ArCoreNode? _sphereNode;
  double _sphereDistance = 2.0; // Default distance
  StreamSubscription? _compassSub;
  NavigationService? _navigationService;

  ArCoreController? get arController => _arController;

  void initializeAR(ArCoreController controller) {
    _arController = controller;
    print('AR Service initialized');
  }

  void setTarget(POI poi, LocationData currentLocation) {
    _targetPOI = poi;
    _currentLocation = currentLocation;
    print('Target set: ${poi.name} at ${poi.latitude}, ${poi.longitude}');
    print('Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
  }

  void showDirectionalArrow() {
    if (_arController == null || _targetPOI == null || _currentLocation == null) {
      print('Cannot show arrow: missing controller, target, or location');
      return;
    }
    print('Showing directional arrow...');
    _createSimpleSphere();
  }

  void _createSimpleSphere({double? yawDeg}) {
    try {
      double angle = yawDeg ?? 0.0;
      double radians = angle * math.pi / 180;
      double distance = _sphereDistance;
      double x = distance * math.sin(radians);
      double z = -distance * math.cos(radians);
      print('Creating simple sphere at $distance meters, angle: $angle°, pos: ($x, 0, $z)');
      // Remove old spheres if exist
      _arController?.removeNode(nodeName: 'simple_sphere');
      _arController?.removeNode(nodeName: 'pointer_sphere');
      // Create main (big) sphere
      _sphereNode = ArCoreNode(
        name: 'simple_sphere',
        shape: ArCoreSphere(
          materials: [
            ArCoreMaterial(
              color: Colors.red,
              metallic: 0.0,
            ),
          ],
          radius: 0.3,
        ),
        position: Vector3(x, 0, z),
      );
      _arController!.addArCoreNode(_sphereNode!);
      // --- Pointer sphere ---
      if (_navigationService != null) {
        double? pointerBearing = _navigationService!.getCurrentStepBearing();
        if (pointerBearing != null) {
          double pointerRadians = pointerBearing * math.pi / 180;
          double pointerOffset = 0.5; // 0.5 metre offset
          double px = x + pointerOffset * math.sin(pointerRadians - radians);
          double pz = z - pointerOffset * math.cos(pointerRadians - radians);
          print('Pointer sphere at offset: ($px, 0, $pz), bearing: $pointerBearing°');
          final pointerSphere = ArCoreNode(
            name: 'pointer_sphere',
            shape: ArCoreSphere(
              materials: [
                ArCoreMaterial(
                  color: Colors.green,
                  metallic: 0.0,
                ),
              ],
              radius: 0.12,
            ),
            position: Vector3(px, 0, pz),
          );
          _arController!.addArCoreNode(pointerSphere);
        }
      }
      print('Simple sphere added at $distance meters, angle: $angle°');
    } catch (e) {
      print('Error creating sphere: $e');
    }
  }

  void moveSphereToDistance(double distance) {
    _sphereDistance = distance;
    _createSimpleSphere();
  }

  void startCompassListener() {
    _compassSub?.cancel();
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        double heading = event.heading!;
        _createSimpleSphere(yawDeg: heading);
      }
    });
    print('Compass listener started');
  }

  void stopCompassListener() {
    _compassSub?.cancel();
    print('Compass listener stopped');
  }

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

  void clearAR() {
    if (_arController != null) {
      try {
        _arController!.removeNode(nodeName: 'simple_sphere');
        _arController!.removeNode(nodeName: 'pointer_sphere');
        print('AR objects cleared');
      } catch (e) {
        print('Error clearing AR objects: $e');
      }
    }
    _sphereNode = null;
    _targetPOI = null;
    _currentLocation = null;
    _sphereDistance = 2.0;
    stopCompassListener();
  }

  void setNavigationService(NavigationService navigationService) {
    _navigationService = navigationService;
  }
} 