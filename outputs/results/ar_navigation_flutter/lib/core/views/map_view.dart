import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart';
import '../widgets/poi_list.dart';
import '../services/navigation_service.dart' hide LatLng;

class MapView extends StatefulWidget {
  final Function(POI) onPOISelected;
  final NavigationService navigationService;
  final VoidCallback? onARButtonPressed;

  const MapView({
    Key? key,
    required this.onPOISelected,
    required this.navigationService,
    this.onARButtonPressed,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    print('MapView initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapViewModel>(
      builder: (context, viewModel, child) {
        print('MapView building with ${viewModel.pois.length} POIs');
        _createMarkers(viewModel);
        _createPolylines(viewModel);
        final instructions = widget.navigationService.navigationInstructions;
        final currentStep = widget.navigationService.currentStepIndex;
        return Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                print('Map controller created');
              },
              initialCameraPosition: CameraPosition(
                target: viewModel.currentLocation != null
                    ? LatLng(viewModel.currentLocation!.latitude!, viewModel.currentLocation!.longitude!)
                    : const LatLng(37.73762, 29.1398283),
                zoom: 15.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (_) {
                // Hide any open bottom sheets when tapping on map
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
            if (widget.navigationService.isNavigating && instructions.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                top: 40,
                child: Center(
                  child: IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                        ),
                        child: Text(
                          instructions[currentStep],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.navigationService.isNavigating && instructions.isNotEmpty)
              Positioned(
                right: 20,
                bottom: 120,
                child: FloatingActionButton(
                  onPressed: () {
                    widget.navigationService.nextStep();
                    setState(() {});
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
          ],
        );
      },
    );
  }

  void _createMarkers(MapViewModel viewModel) {
    print('Creating markers for ${viewModel.pois.length} POIs');
    _markers.clear();
    
    if (viewModel.pois.isEmpty) {
      print('No POIs to create markers for');
      return;
    }

    // User location marker
    if (viewModel.currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(viewModel.currentLocation!.latitude!, viewModel.currentLocation!.longitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Konumunuz'),
        ),
      );
    }

    // POI markers
    for (var poi in viewModel.pois) {
      _markers.add(
        Marker(
          markerId: MarkerId(poi.name),
          position: LatLng(poi.latitude, poi.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: poi.name,
            snippet: poi.description,
          ),
          onTap: () {
            print('POI marker tapped: ${poi.name}');
            _showPOIActionSheet(poi);
          },
        ),
      );
    }
    
    print('Created ${_markers.length} markers');
  }

  void _showPOIActionSheet(POI poi) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                poi.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                poi.description,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('Rota oluştur button pressed for: ${poi.name}');
                    widget.onPOISelected(poi);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Rota Oluştur',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('İptal'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createPolylines(MapViewModel viewModel) {
    print('Creating polylines for navigation');
    _polylines.clear();
    
    if (widget.navigationService.isNavigating && widget.navigationService.routePoints.isNotEmpty) {
      print('Creating polyline with ${widget.navigationService.routePoints.length} points');
      
      List<LatLng> polylinePoints = widget.navigationService.routePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('navigation_route'),
          points: polylinePoints,
          color: Colors.blue,
          width: 5,
        ),
      );
      
      // Fit camera to show the entire route
      if (_mapController != null && polylinePoints.length > 1) {
        _fitCameraToRoute(polylinePoints);
      }
      
      print('Polyline created with ${polylinePoints.length} points');
    } else {
      print('No navigation route to display');
    }
  }

  void _fitCameraToRoute(List<LatLng> points) {
    if (points.isEmpty) return;
    
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    
    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50.0, // padding
      ),
    );
  }
} 