import 'package:flutter/material.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:messaging_core/locator.dart';

class ChatPageDrawer extends StatelessWidget {
  ChatPageDrawer({
    super.key,
  });
  final ChatController controller = locator<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  return ChatListItem(chat: controller.users[index]);
                })),
      ),
    );
  }
}
