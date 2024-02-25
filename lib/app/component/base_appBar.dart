import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.onPressBack,
    this.leadingWidget,
    this.leadingWidth,
    this.textStyle,
    this.actions,
    this.iconColor,
    this.color,
    this.padding,
    this.haveShadow = true,
    this.height,
  }) : super(key: key);

  final String? title;
  final double? height;
  final double? padding;
  final TextStyle? textStyle;

  /// on tap for back button
  final VoidCallback? onPressBack;

  /// if null returns back button
  final Widget? leadingWidget;
  final double? leadingWidth;

  /// list of widgets for an acction
  final List<Widget>? actions;

  final Color? color;
  final Color? iconColor;
  final bool haveShadow;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3:  false),
      child: AppBar(
        title: title == null
            ? null
            : Text(
                title ?? "",
              ),
        titleTextStyle: textStyle ?? AppTextStyles.subtitle4,
        toolbarHeight: height ?? 56,
        backgroundColor: color ?? AppColors.neutral[800],
        centerTitle: true,
        actions: actions,
        leadingWidth: leadingWidth,
        leading: onPressBack == null
            ? leadingWidget
            : IconWidget(
                onPressed: onPressBack,
                height: 20,
                width: 20,
                size: 14,
                borderRadius: 100,
                icon: Assets.arrowLeftIcon,
              ),
        elevation: haveShadow ? 1 : 0,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(height ?? AppBar().preferredSize.height);
}
