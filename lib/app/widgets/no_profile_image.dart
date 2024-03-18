import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class NoProfileImage extends StatelessWidget {
  const NoProfileImage(
      {super.key, this.size, this.id, this.name, this.boxShape});

  final double? size;
  final int? id;
  final String? name;
  final BoxShape? boxShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 50,
      width: size ?? 50,
      decoration: BoxDecoration(
          shape: boxShape ?? BoxShape.rectangle, color: (id ?? 4).colorFromId()),
      child: Center(
        child: Text(
          (name?.length ?? 0) > 0
              ? name?.substring(0, 1).toUpperCase() ?? "A"
              : "A",
          style: AppTextStyles.caption2.copyWith(
              color: Colors.white, fontSize: size != null ? size! / 1.5 : 20),
        ),
      ),
    );
  }
}
