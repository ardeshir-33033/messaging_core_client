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
import 'package:messaging_core/features/chat/data/data_sources/chat_data_source.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/online_users_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/chat_list_floating_button.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversation_skeleton_widget.dart';
import 'package:messaging_core/locator.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatController controller = locator<ChatController>();
  final EmojiController emojiController = locator<EmojiController>();

  connect() {
    locator<MessagingClient>().initState();
  }

  @override
  void initState() {
    connect();
    getSiamakToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ChatListFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SafeArea(
            child: GetBuilder<OnlineUsersController>(
                id: "onlineUsers",
                builder: (_) {
                  return GetBuilder<ChatController>(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Divider(
                                height: 1,
                                color: Colors.grey[100],
                              ),
                            ),
                            onRefresh: (limit, offset) async {
                              await controller.getAllChats();
                            },
                            onLoading: (limit, offset) async {
                              // await channelProvider.setChannels(limit, offset);
                            },
                          );
                        }
                      });
                })),
      ),
    );
  }

  getSiamakToken() {
    ChatDataSourceImpl(locator()).loginSiamak();
  }
}
