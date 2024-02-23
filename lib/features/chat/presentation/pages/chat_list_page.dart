import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/widgets/pagination_widget.dart';
import 'package:messaging_core/app/widgets/skeleton_widget.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/env/environment.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/core/services/network/websocket/web_socket_connection.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversation_skeleton_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatController controller = Get.put<ChatController>(locator());
  final EmojiController emojiController = Get.put(EmojiController());


  connect() {
    locator<MessagingClient>().initState();
  }

  @override
  void initState() {
    connect();
    controller.getAllChats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        haveShadow: false,
        leadingWidth: 40,
        title: tr(context).chat,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SafeArea(
            child: GetBuilder<ChatController>(
                id: "allChats",
                builder: (_) {
                  if (controller.chatsStatus.status == Status.loading) {
                    return ListView.separated(
                      itemBuilder: (context, index) =>
                          const ConversationSkeletonWidget(),
                      itemCount: 15,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      separatorBuilder: (context, index) => Divider(
                        height: 15,
                        color: Colors.grey[100],
                      ),
                    );
                  } else {
                    return PaginationWidget<ChatParentClass>(
                      itemBuilder: (index, item) {
                        return ChatListItem(chat: item);
                      },
                      items: controller.chats,
                      separatorBuilder: (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 1,
                          color: Colors.grey[100],
                        ),
                      ),
                      onRefresh: (limit, offset) async {
                        // await controller.getAllChats();
                      },
                      onLoading: (limit, offset) async {
                        // await channelProvider.setChannels(limit, offset);
                      },
                    );
                  }
                })),
      ),
    );
  }
}
