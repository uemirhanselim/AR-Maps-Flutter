import 'package:flutter/foundation.dart';
import '../services/ar_service.dart';
import '../widgets/poi_list.dart';
import 'package:location/location.dart';

class ARViewModel extends ChangeNotifier {
  final ARService _arService = ARService();
  
  bool _isARActive = false;
  POI? _currentTarget;
  LocationData? _currentLocation;

  bool get isARActive => _isARActive;
  POI? get currentTarget => _currentTarget;
  LocationData? get currentLocation => _currentLocation;

  void startAR(POI target, LocationData location) {
    _currentTarget = target;
    _currentLocation = location;
    _isARActive = true;
    notifyListeners();
  }

  void stopAR() {
    _arService.clearAR();
    _isARActive = false;
    _currentTarget = null;
    _currentLocation = null;
    notifyListeners();
  }

  void showDirectionalArrow() {
    if (_currentTarget != null && _currentLocation != null) {
      _arService.setTarget(_currentTarget!, _currentLocation!);
      _arService.showDirectionalArrow();
    }
  }
} 