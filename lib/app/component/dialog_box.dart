import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/AppTextButton.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import '../../main.dart';

class DialogBoxes {
  DialogBoxes({
    this.title = '',
    this.des = '',
    this.image,
    this.mainTask,
    this.otherTask,
    this.otherTaskText,
    this.mainTaskText,
    this.threeBtnText,
    this.threeBtnTask,
    this.haveClose = false,
    this.showIcon = true,
    this.customView,
    this.icon,
    this.descriptionWidget,
    this.showMainButton = true,
    this.dismissible = true,
  });

  ///title
  String? title;

  ///des
  String? des;

  ///description widget
  Widget? descriptionWidget;

  ///image
  String? image;

  ///haveClose
  bool haveClose;

  ///mainTask
  VoidCallback? mainTask;

  ///otherTask
  VoidCallback? otherTask;

  ///three Btn Task
  VoidCallback? threeBtnTask;

  ///otherTaskText
  String? otherTaskText;

  ///three Btn Text
  String? threeBtnText;

  ///mainTaskText
  String? mainTaskText;

  ///mainTaskText
  bool? showIcon;

  ///mainTaskText
  Widget? customView;

  /// either to show button or not
  bool? showMainButton;

  /// is the dialuge dismissable or not
  bool dismissible;

  String? icon;

  Color? iconColor;

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: AppGlobalData.navigatorKey?.currentContext! ?? Get.context!,
      barrierDismissible: dismissible, // user must not tap buttons!
      builder: (final BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.r),
            ),
          ),
          // title:  Text(title),
          content: customView ??
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: haveClose,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconWidget(
                          icon: Icons.close,
                          iconColor: AppColors.primaryBlack,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showIcon ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: IconWidget(
                          icon: icon ?? "",
                          iconColor: iconColor,
                          size: 30,
                          padding: 12,
                          boxFit: BoxFit.contain,
                          height: 52,
                          width: 52,
                          boxShape: BoxShape.circle,
                          backgroundColor: const Color(0xffF3F4F8),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: title != null,
                      child: TextWidget(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body3.copyWith(
                          color: const Color(0xff050D18),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: des != null || descriptionWidget != null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: descriptionWidget ??
                            TextWidget(
                              des ?? "",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body3.copyWith(
                                color: const Color(0xff050D18),
                                fontSize: 12,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          actions: <Widget>[
            const Divider(height: 1),
            Visibility(
              visible: showMainButton ?? true,
              child: AppTextButton(
                key: const Key("mainDialogButton"),
                height: 32,
                alignment: Alignment.center,
                label: mainTaskText ?? 'OK',
                onPressed: mainTask,
              ),
            ),
            Visibility(
              visible: otherTask != null,
              child: Column(
                children: [
                  const Divider(height: 1),
                  AppTextButton(
                    key: const Key("secondDialogButton"),
                    height: 32,
                    alignment: Alignment.center,
                    onPressed: otherTask,
                    label: otherTaskText,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: threeBtnTask != null,
              child: Column(
                children: [
                  const Divider(height: 1),
                  AppTextButton(
                    key: const Key("thirdDialogButton"),
                    height: 32,
                    alignment: Alignment.center,
                    onPressed: threeBtnTask,
                    label: threeBtnText,
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
