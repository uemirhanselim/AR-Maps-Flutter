import '../arcore_material.dart';
import 'arcore_shape.dart';

class ArCoreArrow extends ArCoreShape {
  ArCoreArrow({
    required this.modelPath,
    required List<ArCoreMaterial> materials,
  }) : super(
          materials: materials,
        );

  final String modelPath; // Örn: 'assets/models/arrow.glb'

  @override
  Map<String, dynamic> toMap() => <String, dynamic>{
        'modelPath': modelPath,
      }..addAll(super.toMap());
}
