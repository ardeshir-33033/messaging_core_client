import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/theme_service.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  final double? strokeWidth;
  final Widget? child;

  const LoadingWidget({
    Key? key,
    this.color,
    this.height,
    this.width,
    this.strokeWidth,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? Color(0xff2F80ED),
            strokeWidth: strokeWidth ?? 4,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
