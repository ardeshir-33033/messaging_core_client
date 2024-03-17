import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class AppTitleWidget extends StatelessWidget {
  const AppTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.vertical,
      child: TextWidget(
        title,
        style: AppTextStyles.subtitle2.copyWith(
          fontSize: 28,
        ),
      ),
    );
  }
}
