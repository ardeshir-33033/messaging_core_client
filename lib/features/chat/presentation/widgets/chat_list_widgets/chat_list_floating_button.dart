import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/repositories/storage/chat_storage_repository.dart';
import 'package:messaging_core/features/chat/presentation/pages/create_new_group_page.dart';
import 'package:messaging_core/locator.dart';

class ChatListFloatingButton extends StatelessWidget {
  const ChatListFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        List<ContentModel> contents =
            await locator<ChatStorageRepository>().getMessages("177-330-391");
        print(contents);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => CreateNewGroupPage()));
      },
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.red,
      isExtended: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primary1),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                color: AppColors.primary1),
          ),
          const Icon(
            Icons.add,
            size: 15,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
