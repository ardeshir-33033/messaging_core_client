import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class ReplySendMessageWidget extends StatelessWidget {
  ReplySendMessageWidget({super.key});

  final ChatController controller = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 47,
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Row(
                children: [
                  VerticalDivider(
                    color: controller.currentChat!.isGroup()
                        ? AppColors.getColorByHash(
                            controller.repliedContent!.senderId.hashCode)
                        : AppColors.primary1[450],
                    width: 10,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          getSenderName(controller.repliedContent!, context),
                          style: AppTextStyles.overline1.copyWith(
                            color: controller.currentChat!.isGroup()
                                ? AppColors.getColorByHash(controller
                                    .repliedContent!.senderId.hashCode)
                                : AppColors.primary1[450],
                          ),
                        ),
                        TextWidget(
                          controller.repliedContent!.shortDisplayMessage(),
                          style: AppTextStyles.overline2,
                        ),
                      ],
                    ),
                  ),
                  IconWidget(
                    onPressed: () {
                      controller.repliedContent = null;
                      controller.update(["sendMessage"]);
                    },
                    icon: Icons.close,
                    iconColor: Colors.black54,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getSenderName(ContentModel content, context) {
    String senderName = "";
    if (mine(content)) {
      senderName = AppGlobalData.userName;
    } else {
      if (controller.currentChat!.isGroup()) {
        senderName = content.sender?.name ?? "";
      } else {
        senderName = controller.currentChat!.name ?? "";
      }
    }

    if (content.contentType == ContentTypeEnum.unsupported) {
      return '${tr(context).unsupportedContentFrom} $senderName';
    } else {
      return senderName;
    }
  }

  bool mine(ContentModel content) {
    return AppGlobalData.userId == content.senderId;
  }
}
