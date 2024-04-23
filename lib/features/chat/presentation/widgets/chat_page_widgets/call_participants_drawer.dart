import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/add_participan_drawer_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:messaging_core/locator.dart';

class CallParticipantsDrawer extends StatefulWidget {
  const CallParticipantsDrawer({
    super.key,
  });

  @override
  State<CallParticipantsDrawer> createState() => _CallParticipantsDrawerState();
}

class _CallParticipantsDrawerState extends State<CallParticipantsDrawer> {
  final CallController controller = locator<CallController>();

  final ChatController chatController = locator<ChatController>();

  List<CategoryUser> selectedUser = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: controller.addParticipant
                ? Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: chatController.users.length,
                              itemBuilder: (context, index) {
                                if (chatController.users[index].id ==
                                    chatController.currentChat!.id) {
                                  return const SizedBox();
                                }
                                return AddParticipantDrawerItem(
                                  chat: chatController.users[index],
                                  isSelected: isUserSelected(
                                      chatController.users[index]),
                                  onSelect: (val) {
                                    toggleUsers(
                                        val, chatController.users[index]);
                                  },
                                );
                              })),
                      InkWell(
                        onTap: () {
                          if (selectedUser.isNotEmpty) {
                            controller.addNewParticipants(selectedUser);
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          color: AppColors.primary1,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              tr(context).addToCall,
                              style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: controller.participants.length,
                    itemBuilder: (context, index) {
                      return ChatListItem(
                        chat: controller.participants[index],
                        openDrawer: true,
                      );
                    })),
      ),
    );
  }

  bool isUserSelected(CategoryUser user) {
    CategoryUser? selected =
        selectedUser.firstWhereOrNull((element) => element.id == user.id);
    if (selected == null) {
      return false;
    } else {
      return true;
    }
  }

  toggleUsers(bool value, CategoryUser user) {
    if (value) {
      selectedUser.add(user);
    } else {
      selectedUser.remove(user);
    }
    setState(() {});
  }
}
