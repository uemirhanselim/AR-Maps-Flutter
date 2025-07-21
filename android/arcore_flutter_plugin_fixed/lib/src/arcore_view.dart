import 'dart:async';

import 'arcore_android_view.dart';
import 'arcore_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef void ArCoreViewCreatedCallback(ArCoreController controller);

enum ArCoreViewType { AUGMENTEDFACE, STANDARDVIEW, AUGMENTEDIMAGES }

typedef MoveSphereCallback = void Function();

class ArCoreView extends StatefulWidget {
  final ArCoreViewCreatedCallback onArCoreViewCreated;
  final bool enableTapRecognizer;
  final bool enablePlaneRenderer;
  final bool enableUpdateListener;
  final bool debug;
  final ArCoreViewType type;
  final MoveSphereCallback? onMoveSphere;

  const ArCoreView({
    Key? key,
    required this.onArCoreViewCreated,
    this.enableTapRecognizer = false,
    this.enablePlaneRenderer = true,
    this.enableUpdateListener = false,
    this.type = ArCoreViewType.STANDARDVIEW,
    this.debug = false,
    this.onMoveSphere,
  }) : super(key: key);

  @override
  _ArCoreViewState createState() => _ArCoreViewState();
}

class _ArCoreViewState extends State<ArCoreView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Stack(
        children: [
          ArCoreAndroidView(
            viewType: 'arcore_flutter_plugin',
            onPlatformViewCreated: _onPlatformViewCreated,
            arCoreViewType: widget.type,
            debug: widget.debug,
          ),
          Positioned(
            bottom: 160,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                print('Küreyi 5 metre öne al');
                if (widget.onMoveSphere != null) {
                  widget.onMoveSphere!();
                }
              },
              child: const Text('Küreyi 5 metre öne al'),
            ),
          ),
        ],
      );
    }
    return Center(
      child: Text('$defaultTargetPlatform is not supported by the ar_view plugin'),
    );
  }

  void _onPlatformViewCreated(int id) {
    widget.onArCoreViewCreated(ArCoreController(
      id: id,
      enableTapRecognizer: widget.enableTapRecognizer,
      enableUpdateListener: widget.enableUpdateListener,
      enablePlaneRenderer: widget.enablePlaneRenderer,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
