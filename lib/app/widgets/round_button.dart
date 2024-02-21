import 'package:flutter/material.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.onTap,
      this.color,
      this.size,
      this.iconColor,
      required this.asset,
      this.iconSize});
  final VoidCallback onTap;
  final Color? color;
  final double? size;
  final String asset;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size ?? 80.0,
        height: size ?? 80.0,
        decoration: BoxDecoration(
          color: color ?? Colors.green,
          shape: BoxShape.circle,
        ),
        child: IconWidget(
          icon: asset,
          iconColor: iconColor,
          size: size,
        ),
      ),
    );
  }
}
