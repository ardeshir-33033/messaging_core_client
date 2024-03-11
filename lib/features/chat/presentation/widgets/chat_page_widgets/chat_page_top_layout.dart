import 'package:flutter/material.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';

class ChatPageTopLayout extends StatelessWidget {
  const ChatPageTopLayout({
    super.key,
    required this.pageScrollController,
    required this.chat,
  });

  final ScrollController pageScrollController;
  final ChatParentClass chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedAppBar(
          isGroup: false,
          title: AppGlobalData.userName,
        ),
        const SizedBox(
          height: 400,
        ),
        InkWell(
          onTap: () {
            pageScrollController.animateTo(
                pageScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          child: AnimatedAppBar(
            isGroup: chat.isGroup(),
            centerVertical: true,
            height: 40,
          ),
        ),
      ],
    );
  }
}
