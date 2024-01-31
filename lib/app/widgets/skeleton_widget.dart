import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/theme_service.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWidget extends StatelessWidget {
  final double height;
  final double width;
  final BoxShape shape;
  final Color? highLightColor;
  final Color? baseColor;

  const SkeletonWidget.rectangular({
    Key? key,
    required this.width,
    required this.height,
    this.highLightColor,
    this.baseColor,
  })  : shape = BoxShape.rectangle,
        super(key: key);

  const SkeletonWidget.circular({
    Key? key,
    required this.width,
    required this.height,
    this.highLightColor,
    this.baseColor,
  })  : shape = BoxShape.circle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : const BorderRadius.all(Radius.circular(10)),
        color: baseColor ?? ColorsEx(context)!.shimmerBaseColor.th,
      ),
      child: SkeletonAnimation(
        shimmerColor:
            highLightColor ?? ColorsEx(context)!.shimmerHighlightColor.th,
        shimmerDuration: 1500,
        gradientColor: baseColor ?? ColorsEx(context)!.shimmerBaseColor.th,
        borderRadius: shape == BoxShape.circle
            ? const BorderRadius.all(Radius.circular(100))
            : const BorderRadius.all(Radius.circular(10)),
        child: const SizedBox(),
      ),
    );
  }
}
