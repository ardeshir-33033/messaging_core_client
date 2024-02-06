import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';

class ConversationAppBar extends StatelessWidget {
  const ConversationAppBar({
    Key? key,
    required this.chat,
    this.size,
  }) : super(key: key);

  final ChatParentClass chat;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        chat.avatar.isNullOrEmpty()
            ? _noProfileImage(context, chat)
            : _profileImage(context),
        const SizedBox(width: 7),
        Column(
          children: [
            Text(
              chat.name!,
              style: AppTextStyles.body4.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (chat.isGroup())
              Text(
                "${(chat.groupUsers?.length ?? 0).toString()} Users",
                style: AppTextStyles.description.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        const IconWidget(
          icon: Icons.keyboard_arrow_down,
          iconColor: Colors.black54,
          size: 20,
        )
      ],
    );
  }

  Color get _backgroundColor {
    return Colors.white;
  }

  String? getStatusString() {
    // String myUserId = userId;
    //
    // if (channel.model.type == ChannelType.direct) {
    //   bool isOnline = currentChannelProvider.userStatusList
    //       .firstWhere((u) => u.userId != myUserId,
    //           orElse: () => UserStatusModel(userId: 'NA', isOnline: false))
    //       .isOnline;
    if (chat.isGroup()) {
      return '${chat.groupUsers?.length ?? 0} members';
    }
    return false ? "Online" : "Offline";
  }

  // getIsTyping(SignalsProvider provider) {
  //   if (provider.channels.containsKey(channel.id)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // String getIsTypingText(SignalsProvider provider, context) {
  //   if (channel.isGroup()) {
  //     if ((provider.channels[channel.id]?.length ?? 0) > 2) {
  //       return "${provider.channels[channel.id]![0].profile.displayName} , ${provider.channels[channel.id]![1].profile.displayName} ${"and"} ${provider.channels[channel.id]!.length - 2} more are ${tr(context).isTyping}";
  //     } else if ((provider.channels[channel.id]?.length ?? 0) == 2) {
  //       return "${provider.channels[channel.id]![0].profile.displayName} and ${provider.channels[channel.id]![1].profile.displayName} are ${tr(context).isTyping}";
  //     } else {
  //       return "${provider.channels[channel.id]![0].profile.displayName} ${tr(context).isTyping}";
  //     }
  //   } else {
  //     return tr(context).isTyping;
  //   }
  // }
  Widget _noProfileImage(context, ChatParentClass chat) {
    return Container(
      height: size ?? 50,
      width: size ?? 50,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: chat.id!.colorFromId()),
      child: Center(
        child: Text(
          (chat.name?.length ?? 0) > 0
              ? chat.name?.substring(0, 1).toUpperCase() ?? "A"
              : "A",
          style: AppTextStyles.caption2.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _profileImage(BuildContext context) {
    return ImageWidget(
      imageUrl: chat.avatar!,
      // width: size,
      boxFit: BoxFit.fill,
      // height: size,
      boxShape: BoxShape.circle,
      placeHolder: _profilePlaceHolder(),
      tagAlignment: Alignment.bottomRight,
    );
  }

  Widget _profilePlaceHolder() {
    return IconWidget(
      icon:
          chat.isGroup() ? Icons.supervised_user_circle : Icons.account_circle,
      iconColor: Colors.grey,
    );
  }
}
