import 'package:flutter/material.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_list_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/chat_call_top_layout.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/user_contacts_drawer.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/chat_page_drawer.dart';

class ChatCallPage extends StatelessWidget {
  ChatCallPage({super.key});

  final ScrollController pageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChatPageDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: pageScrollController,
            child: Column(
              children: [
                const ChatCallTopLayout(),
                SizedBox(
                    height: context.screenHeight - 200, child: const ChatListPage()),
              ],
            ),
          ),
          const UserContactsDrawer(),
        ],
      ),
    );
  }
}
