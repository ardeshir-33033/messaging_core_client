import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    ///onPressed
    this.onPressed,

    ///label
    this.label,

    ///alignment
    this.alignment,

    ///width
    this.width,

    ///height
    this.height,

    ///rightIcon
    this.rightIcon,

    ///leftIcon
    this.leftIcon,

    ///mainAxisAlignment
    this.mainAxisAlignment,

    ///loading
    this.loading = false,

    ///style
    this.style,

    ///key
    final Key? key,
  }) : super(key: key);

  ///onPressed
  final VoidCallback? onPressed;

  ///label
  final String? label;

  ///alignment
  final AlignmentGeometry? alignment;

  ///width
  final double? width;

  ///height
  final double? height;

  ///rightIcon
  final Widget? rightIcon;

  ///leftIcon
  final Widget? leftIcon;

  ///mainAxisAlignment
  final MainAxisAlignment? mainAxisAlignment;

  ///loading
  final bool loading;

  ///loading
  final TextStyle? style;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 36.r,
      child: loading
          ? const CircularProgressIndicator()
          : TextButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: onPressed,
              child: Wrap(
                // mainAxisAlignment:
                //     mainAxisAlignment ?? MainAxisAlignment.center,
                children: [
                  leftIcon ?? const SizedBox(),
                  if (leftIcon != null)
                    SizedBox(
                      width: 13.r,
                    ),
                  Align(
                    alignment: alignment ?? Alignment.centerLeft,
                    child: Text(
                      label ?? '',
                      style: style ??
                          AppTextStyles.body4
                              .copyWith(color: Color(0xff272B38), fontSize: 10),
                    ),
                  ),
                  if (rightIcon != null)
                    SizedBox(
                      width: 13.r,
                    ),
                  rightIcon ?? const SizedBox()
                ],
              ),
            ),
    );
  }
}
