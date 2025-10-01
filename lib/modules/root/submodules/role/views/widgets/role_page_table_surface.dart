import 'package:flutter/material.dart';
import 'package:secret_hitler_companion/core/utils/constants/paths/image_paths.dart';

class RolePageTableSurface extends StatelessWidget {
  const RolePageTableSurface({super.key});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: Image.asset(
      ImagePaths.woodTexture,
      height: 300,
      width: 500,
      fit: BoxFit.cover,
    ),
  );
}
