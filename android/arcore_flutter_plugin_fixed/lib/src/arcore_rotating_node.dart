import 'arcore_node.dart';
import 'shape/arcore_shape.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class ArCoreRotatingNode extends ArCoreNode {
  ArCoreRotatingNode({
    this.shape,
    double? degreesPerSecond,
    Vector3? position,
    Vector3? scale,
    Vector4? rotation,
    String? name,
  })  : degreesPerSecond = ValueNotifier(degreesPerSecond ?? 90.0),
        super(
          shape: shape,
          name: name,
          position: position,
          scale: scale,
          rotation: rotation,
        );

  final ArCoreShape? shape;

  final ValueNotifier<double> degreesPerSecond;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'degreesPerSecond': this.degreesPerSecond.value,
      }
        ..addAll(super.toMap())
        ..removeWhere((String k, dynamic v) => v == null);
}
