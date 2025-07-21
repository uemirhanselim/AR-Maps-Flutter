import 'package:flutter/material.dart';
import 'package:location/location.dart';

class POI {
  final String name;
  final String description;
  final double distance;
  final double latitude;
  final double longitude;

  POI({
    required this.name,
    required this.description,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });
}

class POIList extends StatelessWidget {
  final List<POI> pois;
  final Function(POI) onPOISelected;

  const POIList({
    super.key,
    required this.pois,
    required this.onPOISelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pois.length,
      itemBuilder: (context, index) {
        final poi = pois[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(poi.name),
            subtitle: Text(poi.description),
            trailing: Text('${poi.distance.toStringAsFixed(1)} km'),
            onTap: () => onPOISelected(poi),
          ),
        );
      },
    );
  }
}

// Generate POIs around user's current location
List<POI> generatePOIsAroundLocation(LocationData? userLocation) {
  print('generatePOIsAroundLocation called with location: $userLocation');
  
  if (userLocation == null) {
    print('User location is null, using fallback POIs');
    // Fallback to Istanbul coordinates if no user location
    return getMockPOIs();
  }

  final userLat = userLocation.latitude!;
  final userLon = userLocation.longitude!;
  
  print('Generating POIs around user location: $userLat, $userLon');

  // Generate POIs within ~500m radius around user (more realistic distances)
  final pois = [
    POI(
      name: 'Yakın Kafe',
      description: 'Yerel kahve dükkanı',
      distance: 0.2,
      latitude: userLat + 0.002, // ~200m north
      longitude: userLon + 0.002, // ~200m east
    ),
    POI(
      name: 'Restoran',
      description: 'İtalyan restoranı',
      distance: 0.3,
      latitude: userLat - 0.003, // ~300m south
      longitude: userLon + 0.003, // ~300m east
    ),
    POI(
      name: 'Benzin İstasyonu',
      description: '24/7 benzin istasyonu',
      distance: 0.4,
      latitude: userLat + 0.004, // ~400m north
      longitude: userLon - 0.001, // ~100m west
    ),
    POI(
      name: 'Alışveriş Merkezi',
      description: 'Modern alışveriş merkezi',
      distance: 0.5,
      latitude: userLat - 0.005, // ~500m south
      longitude: userLon - 0.002, // ~200m west
    ),
    POI(
      name: 'Hastane',
      description: 'Acil tıbbi merkez',
      distance: 0.6,
      latitude: userLat + 0.006, // ~600m north
      longitude: userLon + 0.003, // ~300m east
    ),
    POI(
      name: 'Eczane',
      description: '24 saat eczane',
      distance: 0.15,
      latitude: userLat + 0.0015, // ~150m north
      longitude: userLon - 0.0015, // ~150m west
    ),
    POI(
      name: 'ATM',
      description: 'Banka ATM\'si',
      distance: 0.1,
      latitude: userLat - 0.001, // ~100m south
      longitude: userLon + 0.001, // ~100m east
    ),
    POI(
      name: 'Market',
      description: 'Yerel market',
      distance: 0.25,
      latitude: userLat + 0.0025, // ~250m north
      longitude: userLon - 0.0025, // ~250m west
    ),
  ];
  
  print('Generated ${pois.length} POIs around user location');
  for (var poi in pois) {
    print('Generated POI: ${poi.name} at ${poi.latitude}, ${poi.longitude}');
  }
  
  return pois;
}

// Mock data for testing - Istanbul coordinates (fallback)
List<POI> getMockPOIs() {
  print('Using fallback mock POIs (Istanbul)');
  return [
    POI(
      name: 'Coffee Shop',
      description: 'Local coffee shop',
      distance: 0.2,
      latitude: 41.0082,
      longitude: 28.9784,
    ),
    POI(
      name: 'Restaurant',
      description: 'Italian restaurant',
      distance: 0.5,
      latitude: 41.0085,
      longitude: 28.9787,
    ),
    POI(
      name: 'Gas Station',
      description: '24/7 gas station',
      distance: 0.8,
      latitude: 41.0088,
      longitude: 28.9790,
    ),
    POI(
      name: 'Shopping Mall',
      description: 'Modern shopping center',
      distance: 1.2,
      latitude: 41.0090,
      longitude: 28.9795,
    ),
    POI(
      name: 'Hospital',
      description: 'Emergency medical center',
      distance: 1.5,
      latitude: 41.0095,
      longitude: 28.9800,
    ),
  ];
} 