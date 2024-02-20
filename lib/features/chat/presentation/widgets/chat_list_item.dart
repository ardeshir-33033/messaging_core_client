import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';
import 'package:messaging_core/locator.dart';

class ChatListItem extends StatefulWidget {
  final ChatParentClass chat;
  final Function()? onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  ChatListItemState createState() => ChatListItemState();
}

class ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    String? subtitle = _subtitleText(context);
    return InkWell(
      onTap: widget.onTap ??
          () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatPage(chat: widget.chat);
            }));
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
                  titleStyle: AppTextStyles.subtitle5,
                  subTitle: subtitle == "" ? tr(context).noMessage : subtitle,
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
                Text(
                  (widget.chat.lastMessage?.updatedAt.messageFormat()) ??
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

  // String? getStatusString() {
  //   // if (widget.channel.model.type == ChannelType.direct) {
  //   String myUserId = Provider.of<UserCertStorage>(context).userId!;
  //
  //   bool isOnline = Provider.of<CurrentChannelProvider>(context)
  //       .userStatusList
  //       .firstWhere((u) => u.userId != myUserId,
  //           orElse: () => UserStatusModel(userId: 'NA', isOnline: false))
  //       .isOnline;
  //   return isOnline ? "Online" : _subtitleText;
  //   // } else {
  //   //   return _subtitleText;
  //   // }
  // }

  // bool get _isDraftMessage {
  //   return widget.chat.draftMessage != null &&
  //       widget.chat.draftMessage!.isNotEmpty;
  // }

  String _subtitleText(BuildContext context) {
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
