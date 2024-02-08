import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class CustomBottomSheet {
  CustomBottomSheet._();

  static Future<T?> showSimpleSheet<T>(
    BuildContext context,
    Widget Function(BuildContext context) builder, {
    bool? isScrollControlled,
    bool? isDismissible,
    VoidCallback? onWillPopScope,
  }) async {
    return (await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible ?? true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      constraints: BoxConstraints(maxHeight: context.heightPercentage(94)),
      enableDrag: isDismissible ?? true,
      isScrollControlled: isScrollControlled ?? true,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          onWillPopScope?.call();
          return isDismissible ?? true;
        },
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: AppColors.neutral.shade800,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 25,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xffDADDEB),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: builder.call(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      onWillPopScope?.call();
    }));
  }
}
