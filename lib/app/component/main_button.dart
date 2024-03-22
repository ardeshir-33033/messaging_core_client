import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.isEnable = true,
    this.isLoading = false,
    this.rightIcon,
    this.leftIcon,
    this.iconColor,
    this.iconSize,
    this.borderSide,
  }) : super(key: key);

  final double? height;
  final double? width;
  final VoidCallback? onPressed;
  final String text;
  final BorderSide? borderSide;
  final bool isEnable;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final dynamic rightIcon;
  final dynamic leftIcon;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xffF3F4F8);
            }
            return backgroundColor ?? AppColors.primary1;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith((state) {
          if (state.contains(MaterialState.disabled)) {
            return const Color(0xffA8B1CF);
          }
          return foregroundColor ?? Colors.white;
        }),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            // borderRadius: borderRadius ?? BorderRadius.circular(10),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        elevation: MaterialStateProperty.all<double>(0),
        textStyle: MaterialStateProperty.resolveWith(
          (state) {
            if (state.contains(MaterialState.disabled)) {
              return AppTextStyles.button2
                  .copyWith(color: const Color(0xffA8B1CF));
            }
            return AppTextStyles.button2
                .copyWith(color: foregroundColor ?? Colors.white);
          },
        ),
      ),
      onPressed: isEnable
          ? () {
              if (isLoading == false) {
                onPressed?.call();
              }
            }
          : null,
      child: SizedBox(
        width: width ?? 200,
        height: height ?? 40,
        child: Center(
          child: Visibility(
            visible: isLoading == false,
            replacement: LoadingWidget(
              height: 30,
              width: 30,
              color: foregroundColor ?? Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: leftIcon != null,
                  child: IconWidget(
                    icon: leftIcon ?? "",
                    iconColor: iconColor,
                    size: iconSize ?? 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(text),
                ),
                Visibility(
                  visible: rightIcon != null,
                  child: IconWidget(
                    icon: rightIcon ?? "",
                    iconColor: iconColor,
                    size: iconSize ?? 24,
                    boxFit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
