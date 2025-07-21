import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import '../services/ar_service.dart';
import '../services/navigation_service.dart';
import '../widgets/poi_list.dart';
import 'package:location/location.dart';

class ARView extends StatefulWidget {
  final POI targetPOI;
  final LocationData currentLocation;
  final NavigationService navigationService;

  const ARView({ 
    Key? key,
    required this.targetPOI,
    required this.currentLocation,
    required this.navigationService,
  }) : super(key: key);

  @override
  State<ARView> createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  ArCoreController? _arController;
  final ARService _arService = ARService();
  bool _isARReady = false;
  String _statusMessage = 'AR başlatılıyor...';

  @override
  void dispose() {
    _arController?.dispose();
    _arService.clearAR();
    _arService.stopCompassListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Navigasyon'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAR,
            tooltip: 'AR\'yi Yenile',
          ),
        ],
      ),
      body: Stack(
        children: [
          // AR View
          ArCoreView(
            onArCoreViewCreated: onArCoreViewCreated,
            enableTapRecognizer: true,
            enablePlaneRenderer: true,
            enableUpdateListener: true,
            debug: true,
            onMoveSphere: () {
              _arService.moveSphereToDistance(5.0); // Küreyi 5 metre öne al
            },
          ),
          
          // Overlay UI
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hedef: ${widget.targetPOI.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.targetPOI.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Durum: $_statusMessage',
                    style: TextStyle(
                      color: _isARReady ? Colors.green : Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Instructions
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Navigasyon Talimatları:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Mavi ok hedefinizin yönünü gösterir\n'
                    '• Kırmızı top ok başını temsil eder\n'
                    '• Ok sürekli güncellenir ve hedefe işaret eder\n'
                    '• Telefonu hareket ettirerek yönü takip edin',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onArCoreViewCreated(ArCoreController controller) {
    print('AR Controller created');
    setState(() {
      _arController = controller;
      _statusMessage = 'AR hazırlanıyor...';
    });
    
    _arService.initializeAR(controller);
    // NavigationService'ı ARService'e ilet
    _arService.setNavigationService(widget.navigationService);
    _arService.setTarget(widget.targetPOI, widget.currentLocation);
    
    // Show directional arrow immediately
    setState(() {
      _statusMessage = 'Navigasyon oku gösteriliyor...';
    });
    _arService.showDirectionalArrow();
    _arService.startCompassListener();
    
    setState(() {
      _isARReady = true;
      _statusMessage = 'Navigasyon aktif';
    });
  }

  void _refreshAR() {
    setState(() {
      _isARReady = false;
      _statusMessage = 'AR yenileniyor...';
    });
    
    _arService.clearAR();
    
    if (mounted && _arController != null) {
      _arService.setTarget(widget.targetPOI, widget.currentLocation);
      _arService.showDirectionalArrow();
      _arService.startCompassListener();
      
      setState(() {
        _isARReady = true;
        _statusMessage = 'Navigasyon aktif';
      });
    }
  }
} 