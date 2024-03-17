import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/group/create_new_group_page.dart';
import 'package:messaging_core/locator.dart';

class ChatListFloatingButton extends StatelessWidget {
  ChatListFloatingButton({super.key});
  final ChatController controller = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 90,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary1),
      child: FloatingActionButton(
        onPressed: () async {
          controller.showNewMessagePage = true;
          controller.update(["newMessage"]);
        },
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
        // isExtended: true,
        child: Padding(
          padding: 8.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconWidget(
                icon: Icons.chat,
                iconColor: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 5),
              TextWidget(
                tr(context).newTitle,
                style: AppTextStyles.body3.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
