import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class SingleCallWidget extends StatelessWidget {
  SingleCallWidget({super.key});
  final CallController controller = locator<CallController>();
  final ChatController chatController = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 1.5,
      child: Stack(
        // alignment: Alignment.bottomRight,
        children: [
          SizedBox(
            height: context.screenHeight / 1.7,
            child: Stack(
              children: [
                TopOpponentCall(
                    controller: controller, chatController: chatController),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 1,
            child: Container(
              height: 200,
              width: 160,
              decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)]),
              child: controller.myVideoClosed
                  ? Center(
                      child: NoProfileImage(
                        id: AppGlobalData.userId,
                        name: AppGlobalData.userName,
                      ),
                    )
                  : Image.network(Assets.myCameraTest),
            ),
          ),
        ],
      ),
    );
  }
}

class TopOpponentCall extends StatelessWidget {
  const TopOpponentCall({
    super.key,
    required this.controller,
    required this.chatController,
  });

  final CallController controller;
  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2D2D2D),
          ),
          child: controller.opponentVideoClosed
              ? Center(
                  child: NoProfileImage(
                    id: chatController.currentChat!.isGroup()
                        ? chatController.currentChat!.groupUsers!.last.id
                        : chatController.currentChat!.id,
                    name: chatController.currentChat!.isGroup()
                        ? chatController.currentChat!.groupUsers!.last.name
                        : chatController.currentChat!.username,
                  ),
                )
              : const ImageWidget(
                  imageUrl: Assets.opponentCameraTest,
                ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: const IconWidget(
                    icon: Icons.keyboard_voice,
                    iconColor: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    controller.setOpponentVideo();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                            controller.opponentVideoClosed ? 0.8 : 0.2),
                        shape: BoxShape.circle),
                    child: const IconWidget(
                      icon: Assets.disableVideo,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
