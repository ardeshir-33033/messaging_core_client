import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/group/group_detail_page.dart';
import 'package:messaging_core/features/chat/presentation/pages/waiting_call_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/call_heart_beat_button.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/added_participants_appbar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:messaging_core/main.dart';

class ConversationAppBar extends StatelessWidget {
  ConversationAppBar({
    Key? key,
    required this.chat,
    this.size,
  }) : super(key: key);

  final ChatParentClass chat;
  final double? size;

  final Navigation navigation = locator<Navigation>();
  final CallController controller = locator<CallController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
        id: "participants",
        builder: (_) {
          return controller.addedParticipants.isNotEmpty
              ? AddedParticipantsAppBar()
              : InkWell(
                  onTap: () {
                    if (chat.isGroup()) {
                      navigation.push(GroupDetailsPage(chat: chat));
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          padding: 10.vertical,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE7E7E7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 70,
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // chat.avatar.isNullOrEmpty()
                                  //     ?
                                  _noProfileImage(context, chat),
                                  // : _profileImage(context),
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
                                      GetBuilder<ChatController>(
                                          id: "isTyping",
                                          builder: (controller) {
                                            return
                                                // if (chat.isGroup())
                                                chat.isGroup()
                                                    ? Text(
                                                        "${(chat.groupUsers?.length ?? 0).toString()} Users",
                                                        style: AppTextStyles
                                                            .description
                                                            .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      )
                                                    : controller.isTyping
                                                        ? Text(
                                                            tr(context)
                                                                .isTyping,
                                                            style: AppTextStyles
                                                                .description
                                                                .copyWith(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        : const SizedBox();
                                          })
                                    ],
                                  ),
                                  const IconWidget(
                                    icon: Icons.keyboard_arrow_down,
                                    iconColor: Colors.black54,
                                    size: 20,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: 5.right,
                                child: InkWell(
                                    onTap: () {
                                      navigation.push(const WaitingCallPage());
                                    },
                                    child: const CallHeartBeatButton()),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }

  Future<Uint8List> loadImage() async {
    ByteData data = await rootBundle.load('assets/image.png');
    return data.buffer.asUint8List();
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
