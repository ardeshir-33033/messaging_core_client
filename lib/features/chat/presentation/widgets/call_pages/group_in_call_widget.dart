import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/features/chat/domain/entities/group_users_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/single_in_call_widget.dart';
import 'package:messaging_core/locator.dart';

class GroupInCallWidget extends StatelessWidget {
  GroupInCallWidget({super.key});
  final CallController controller = locator<CallController>();
  final ChatController chatController = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TopOpponentCall(
              controller: controller, chatController: chatController),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount:
                  (chatController.currentChat!.groupUsers?.length ?? 1) - 1,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 5);
              },
              itemBuilder: (context, index) {
                if (index ==
                    chatController.currentChat!.groupUsers!.length - 2) {
                  return InCallUsersItem(
                    showVideo: controller.myVideoClosed,
                    image: Assets.myCameraTest,
                    user: GroupUsersModel(
                        id: AppGlobalData.userId, name: AppGlobalData.userName),
                  );
                }
                return InCallUsersItem(
                  showVideo: !controller.opponentVideoClosed,
                  user: chatController.currentChat!.groupUsers![index + 1],
                );
              }),
        ),
        // Row(
        //   children: [
        //     Container(
        //       height: 115,
        //       width: 86,
        //       decoration: BoxDecoration(
        //         color: const Color(0xFF2D2D2D),
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //     ),
        //     const SizedBox(width: 5),
        //     Container(
        //       height: 115,
        //       width: 86,
        //       decoration: BoxDecoration(
        //         color: const Color(0xFF2D2D2D),
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class InCallUsersItem extends StatelessWidget {
  const InCallUsersItem(
      {super.key, required this.showVideo, required this.user, this.image});
  final bool showVideo;
  final GroupUsersModel user;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 86,
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
      ),
      child: Center(
        child: showVideo
            ? ImageWidget(
                imageUrl: image ?? Assets.opponentCameraTest,
              )
            : NoProfileImage(
                id: user.id,
                name: user.name,
              ),
      ),
    );
  }
}
