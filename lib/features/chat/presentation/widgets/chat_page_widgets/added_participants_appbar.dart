import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class AddedParticipantsAppBar extends StatelessWidget {
  AddedParticipantsAppBar({super.key});

  final CallController controller = locator<CallController>();
  final ChatController chatController = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth - 50,
      height: 50,
      child: ListView.separated(
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: controller.addedParticipants.length,
        itemBuilder: (context, int index) {
          CategoryUser participant = controller.addedParticipants[index];
          return Row(
            children: [
              InkWell(
                onTap: () {
                  chatController.setCurrentChat(participant);
                  chatController.joinRoom();
                  chatController.getMessages();
                },
                child: Stack(
                  children: [
                    Row(
                      children: [
                        NoProfileImage(
                          size: 40,
                          name: participant.name,
                          id: participant.id,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextWidget(
                          participant.name ?? "",
                          style: AppTextStyles.body1
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconWidget(
                icon: Icons.close,
                onPressed: () {
                  controller.addedParticipants.remove(participant);
                  controller.update(["participants"]);
                },
                size: 15,
                iconColor: Colors.black87,
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }
}
