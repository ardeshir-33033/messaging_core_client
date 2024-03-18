import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/round_button.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/in_call_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/no_call_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';

class ChatPageTopLayout extends StatefulWidget {
  ChatPageTopLayout({
    super.key,
    required this.pageScrollController,
    required this.chat,
    required this.isGroup,
  });

  final ScrollController pageScrollController;
  final ChatParentClass chat;
  final bool isGroup;

  @override
  State<ChatPageTopLayout> createState() => _ChatPageTopLayoutState();
}

class _ChatPageTopLayoutState extends State<ChatPageTopLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnimatedAppBar(
          isGroup: false,
          title: "Category Name",
        ),
        GetBuilder<CallController>(
            id: "status",
            builder: (controller) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: controller.callStatus == CallStatus.inCall
                    ? InCallWidget()
                    : NoCallWidget()
              );
            }),
        // IconWidget(
        //   icon: isGroup ? Icons.supervised_user_circle : Icons.account_circle,
        //   size: 300,
        //   iconColor: Colors.grey,
        // ),
        InkWell(
          onTap: () {
            widget.pageScrollController.animateTo(
                widget.pageScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          child: AnimatedAppBar(
            isGroup: widget.chat.isGroup(),
            centerVertical: true,
            height: 40,
          ),
        ),
      ],
    );
  }
}
