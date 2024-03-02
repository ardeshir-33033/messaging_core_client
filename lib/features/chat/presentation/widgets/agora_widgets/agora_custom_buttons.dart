import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';

class AgoraCustomButton extends StatelessWidget {
  const AgoraCustomButton({
    Key? key,
    this.icon,
    this.assetIcon,
    this.onPressed,
    required this.buttonName,
    this.color,
    this.shape,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  final String buttonName;
  final String? assetIcon;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final BoxShape? shape;
  final double? height;
  final double? width;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: height ?? 55,
            width: width ?? 55,
            padding: EdgeInsets.all(padding ?? 10),
            decoration: BoxDecoration(
                shape: shape ?? BoxShape.circle,
                borderRadius: shape == null ? null : BorderRadius.circular(25),
                color: color ?? AppColors.primary1[100]!.withOpacity(0.3)),
            child: icon == null
                ? SvgPicture.asset(assetIcon!)
                : Icon(
                    icon,
                    color: AppColors.primaryWhite,
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            buttonName,
            style: AppTextStyles.body4.copyWith(color: AppColors.primaryWhite),
          ),
        ],
      ),
    );
  }
}
