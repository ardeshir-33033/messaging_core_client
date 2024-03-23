import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 1.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconWidget(
            icon: Assets.callRemove2,
            size: 100,
          ),
          const SizedBox(height: 10),
          TextWidget(
            "noNotification",
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: 10),
          TextWidget(
            "noChatDesc",
            style: AppTextStyles.body4.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
