import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';

enum SnackType { failure, success, normal }

class SnackBarWidget {
  const SnackBarWidget._();

  static showSnackBar({
    required SnackType snackType,
    required String title,
    required BuildContext context,
  }) {
    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) => _snackBarWidget(context, snackType, title),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 600),
      useSafeArea: true,
    );
  }

  static Widget _snackBarWidget(
      BuildContext context, SnackType snackType, String title) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        color: _snackTypeColor(context, snackType),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: TextWidget(
          title,
          style: AppTextStyles.overline2.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Color _snackTypeColor(BuildContext context, SnackType snackType) {
    switch (snackType) {
      case SnackType.success:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  static showSuccessSnackBar(BuildContext context, String title) {
    showSnackBar(snackType: SnackType.success, title: title, context: context);
  }

  static showFailedSnackBar(BuildContext context, String? title) {
    showSnackBar(
      snackType: SnackType.failure,
      title: title ?? "",
      context: context,
    );
  }
}
