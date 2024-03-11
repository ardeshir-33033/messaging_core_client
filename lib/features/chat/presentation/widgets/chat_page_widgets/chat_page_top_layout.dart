import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
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
        const AnimatedAppBar(
          isGroup: false,
          title: "Category Name",
        ),
        Column(
          children: [
            SizedBox(
              height: 30,
              child: TextWidget(
                chat.username!,
                style: AppTextStyles.overline,
              ),
            ),
            NoProfileImage(
              id: chat.id,
              name: chat.username,
              boxShape: BoxShape.rectangle,
              size: 300,
            ),
          ],
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
