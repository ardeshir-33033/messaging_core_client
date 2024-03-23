import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/online_users_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:messaging_core/main.dart';

class ChatListItem extends StatefulWidget {
  final ChatParentClass chat;
  final Function()? onTap;
  final bool? openDrawer;

  const ChatListItem(
      {super.key, required this.chat, this.onTap, this.openDrawer});

  @override
  ChatListItemState createState() => ChatListItemState();
}

class ChatListItemState extends State<ChatListItem> {
  final OnlineUsersController onlineUsersController =
      Get.find<OnlineUsersController>();

  final Navigation navigation = locator<Navigation>();

  @override
  Widget build(BuildContext context) {
    String? subtitle = _subtitleText(context);
    bool isStarredChat = widget.chat.id! == AppGlobalData.userId;
    return InkWell(
      onTap: widget.onTap ??
          () async {
            if (widget.openDrawer ?? false) {
              Navigator.pop(context);
            }
            // navigation.push(ChatPage(chat: widget.chat));
            navigation.pushAndRemoveUntilFirst(ChatPage(chat: widget.chat));
          },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: UserProfileWidget(
                  chat: widget.chat,
                  size: 50,
                  isGroup: widget.chat.isGroup(),
                  titleStyle: AppTextStyles.subtitle5,
                  isOnline:
                      ((!widget.chat.isGroup()) == true && isUserOnline()),
                  subTitle: isStarredChat
                      ? null
                      : subtitle == ""
                          ? "noMessage"
                          : subtitle,
                  subtitleStyle: AppTextStyles.description2.copyWith(
                    color: AppColors.primaryBlack,
                  )),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isStarredChat)
                  Text(
                    (widget.chat.lastMessage?.updatedAt
                            .getContentDateFromNow()) ??
                        'No last Date',
                    style: AppTextStyles.overline2
                        .copyWith(color: AppColors.primary3),
                  ),
                (widget.chat.unreadCount ?? 0) > 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(2),
                        constraints: const BoxConstraints(minWidth: 16),
                        decoration: BoxDecoration(
                            color: AppColors.primary1.shade200,
                            borderRadius: BorderRadius.circular(12.0)),
                        alignment: Alignment.center,
                        child: Text(
                          widget.chat.unreadCount.toString(),
                          style: AppTextStyles.body4.copyWith(
                            color: AppColors.primary1[450],
                          ),
                        ),
                      )
                    : Container(
                        height: 18,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isUserOnline() {
    bool result = false;
    onlineUsersController.onlineUsers.forEach((element) {
      if (element == widget.chat.id) {
        result = true;
      }
    });
    return result;
  }

  // bool get _isDraftMessage {
  //   return widget.chat.draftMessage != null &&
  //       widget.chat.draftMessage!.isNotEmpty;
  // }

  String _subtitleText(BuildContext context) {
    if (widget.chat.lastMessage?.contentType == ContentTypeEnum.other) {
      return widget.chat.lastMessage!.contentPayload!.shortDisplayName();
    }
    // if (_isDraftMessage) {
    //   return "${context.l.draft}: ${widget.chat.draftMessage}";
    // }
    // if (widget.chat.model.status == ChannelSubscriptionStatus.removed) {
    //   return tr(context).youWereRemoved;
    // }
    return widget.chat.lastMessage?.shortDisplayMessage() ?? '';

    return "";
  }
}
