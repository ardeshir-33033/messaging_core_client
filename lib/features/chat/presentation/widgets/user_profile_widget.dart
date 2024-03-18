import 'dart:math';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/ChannelType.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';

class UserProfileWidget extends StatelessWidget {
  final String? url;
  final String? title;
  final String? subTitle;
  final bool isGroup;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showIcon;
  final ChatParentClass chat;
  final double? size;
  final bool? isOnline;

  const UserProfileWidget(
      {super.key,
      this.url,
      this.title,
      this.subTitle,
      this.isGroup = false,
      this.onTap,
      this.titleStyle,
      this.subtitleStyle,
      this.isOnline,
      this.showIcon = true,
      required this.chat,
      this.size});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ChannelType channelType =
            chat.unreadCount == null ? ChannelType.direct : ChannelType.group;

        return SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              url.isNullOrEmpty()
                  ? _noProfileImage(context, chat)
                  : _profileImage(context),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        if (showIcon)
                          Builder(
                            builder: (context) {
                              return switch (channelType) {
                                ChannelType.direct => const Icon(
                                    Icons.person,
                                    size: 15,
                                  ),
                                ChannelType.group => const Icon(
                                    Icons.people,
                                    size: 15,
                                  ),
                                ChannelType.sms => const Icon(
                                    Icons.phone,
                                    size: 15,
                                  ),
                                ChannelType.bot => const SizedBox(),
                              };
                            },
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: TextWidget.medium(
                            chat.name ?? "",
                            context: context,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 12,
                            additionalStyle: AppTextStyles.body3
                                .copyWith(color: const Color(0xFF272B38)),
                          ),
                        ),
                      ],
                    ),
                    if (subTitle != null)
                      TextWidget.medium(
                        subTitle ?? "",
                        context: context,
                        overflow: TextOverflow.ellipsis,
                        additionalStyle: subtitleStyle,
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _profileImage(BuildContext context) {
    return Stack(
      children: [
        ImageWidget(
          onTap: onTap,
          imageUrl: url!,
          // width: size,
          boxFit: BoxFit.fill,
          // height: size,
          boxShape: BoxShape.circle,
          placeHolder: _profilePlaceHolder(),
          tagAlignment: Alignment.bottomRight,
          tagWidget: IconWidget(
            icon: Icons.edit,
            iconColor: Colors.white,
            onPressed: onTap,
            backgroundColor: Colors.blue,
            borderRadius: 1000,
            padding: 3,
          ),
        ),
        if (isGroup == false && chat.id != AppGlobalData.userId)
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isOnline ?? false) ? Colors.green : Colors.grey),
          )
      ],
    );
  }

  Widget _noProfileImage(context, ChatParentClass chat) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: size ?? 50,
          width: size ?? 50,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle, color: chat.id!.colorFromId()),
          child: Center(
            child: Text(
              (chat.name?.length ?? 0) > 0
                  ? chat.name?.substring(0, 1).toUpperCase() ?? "A"
                  : "A",
              style: AppTextStyles.caption2.copyWith(color: Colors.white),
            ),
          ),
        ),
        if (isGroup == false && chat.id != AppGlobalData.userId)
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isOnline ?? false) ? Colors.green : Colors.grey),
          )
      ],
    );
  }

  Widget _profilePlaceHolder() {
    return IconWidget(
      icon: isGroup ? Icons.supervised_user_circle : Icons.account_circle,
      iconColor: Colors.grey,
    );
  }
}
