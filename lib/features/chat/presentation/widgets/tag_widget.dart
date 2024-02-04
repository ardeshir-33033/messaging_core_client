import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';

class TagWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final dynamic icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final TextStyle? style;
  final double? horizontalPadding;
  final double? verticalPadding;

  const TagWidget({
    Key? key,
    required this.text,
    this.textColor,
    this.icon,
    this.iconColor,
    this.style,
    this.backgroundColor,
    this.verticalPadding,
    this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 8,
        vertical: verticalPadding ?? 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            IconWidget(
              icon: icon,
              iconColor: iconColor,
              size: 12,
              padding: 2,
            ),
          Flexible(
            child: TextWidget(
              text,
              textAlign: TextAlign.center,
              style: style ??
                  AppTextStyles.body5.copyWith(
                      color: textColor ?? Color(0xff272B38), fontSize: 8),
            ),
          )
        ],
      ),
    );
  }
}
