import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_viewmodel.dart';
import '../viewmodels/ar_viewmodel.dart';
import '../widgets/poi_list.dart';
import 'map_view.dart';
import 'ar_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel()),
        ChangeNotifierProvider(create: (_) => ARViewModel()),
      ],
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatelessWidget {
  const _HomeViewContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<MapViewModel>(
      builder: (context, mapViewModel, child) {
        return Scaffold(
          body: MapView(
            onPOISelected: (POI poi) async {
              print('POI selected in HomeView: ${poi.name}');
              await mapViewModel.selectPOI(poi);
            },
            navigationService: mapViewModel.navigationService,
            onARButtonPressed: mapViewModel.isNavigating ? () {
              print('AR button pressed');
              _navigateToARView(context, mapViewModel);
            } : null,
          ),
          floatingActionButton: mapViewModel.isNavigating
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Route info card
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${mapViewModel.selectedPOI!.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mesafe: ${mapViewModel.navigationService.calculateDistance().toStringAsFixed(1)} km',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Süre: ${mapViewModel.navigationService.getEstimatedTime()}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // AR Navigation button
                    FloatingActionButton.extended(
                      onPressed: () {
                        print('AR button pressed');
                        _navigateToARView(context, mapViewModel);
                      },
                      backgroundColor: Colors.green,
                      icon: const Icon(Icons.view_in_ar, color: Colors.white),
                      label: const Text(
                        'AR Navigasyon',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  void _navigateToARView(BuildContext context, MapViewModel mapViewModel) {
    if (mapViewModel.selectedPOI != null && mapViewModel.currentLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ARView(
            targetPOI: mapViewModel.selectedPOI!,
            currentLocation: mapViewModel.currentLocation!,
            navigationService: mapViewModel.navigationService,
          ),
        ),
      );
    } else {
      print('Cannot navigate to AR view: missing POI or location');
    }
  }
} 