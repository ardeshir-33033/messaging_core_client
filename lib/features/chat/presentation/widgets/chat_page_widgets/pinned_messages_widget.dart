import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class PinnedMessagesWidget extends StatefulWidget {
  const PinnedMessagesWidget(
      {super.key, required this.isGroup, required this.onPinTap});
  final bool isGroup;
  final Function() onPinTap;

  @override
  State<PinnedMessagesWidget> createState() => _PinnedMessagesWidgetState();
}

class _PinnedMessagesWidgetState extends State<PinnedMessagesWidget> {
  final ChatController controller = locator<ChatController>();

  late bool isMine;

  @override
  void initState() {
    isMine = mine(controller.pinnedMessage!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPinTap,
      child: Container(
        width: context.screenWidth / 1.1,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        child: Padding(
          padding: 10.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconWidget(
                      icon: Assets.pin,
                      iconColor: Colors.grey[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSenderName(
                              controller.pinnedMessage!,
                            ),
                            style: AppTextStyles.body4.copyWith(
                                color: widget.isGroup
                                    ? getSenderColor(controller.pinnedMessage!)
                                    : AppColors.primary3[800]),
                          ),
                          SizedBox(
                            // width: 100,
                            child: Text(
                              controller.pinnedMessage!.contentPayload != null
                                  ? controller.pinnedMessage!.contentPayload!
                                      .shortDisplayName()
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextStyles.overline2
                                  .copyWith(color: AppColors.primary3[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconWidget(
                onPressed: () {
                  controller.pinnedMessage = null;
                  controller.update(["pin"]);
                },
                icon: Icons.close,
                iconColor: Colors.grey[700],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getSenderName(ContentModel content) {
    String senderName = "";
    if (isMine) {
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

  Color getSenderColor(ContentModel content) {
    if (content.contentType == ContentTypeEnum.unsupported) {
      return const Color(0xff2F80ED);
    } else {
      return AppColors.getColorByHash(content.senderId.hashCode);
    }
  }
}
