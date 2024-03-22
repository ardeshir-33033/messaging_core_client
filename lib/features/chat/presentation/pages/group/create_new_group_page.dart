import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/component/TextFieldWidget.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/component/main_button.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/app_title_widget.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/search_input_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/SelectableModel.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/group_users_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/users_list_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversation_appbar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/bottom_sheet_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/row_user_profile_widget.dart';
import 'package:messaging_core/locator.dart';

class CreateNewGroupPage extends StatefulWidget {
  const CreateNewGroupPage({super.key, required this.groupName});

  final String groupName;

  @override
  State<CreateNewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends State<CreateNewGroupPage> {
  FileModel? groupImage;
  bool loading = false;
  final ChatController controller = locator<ChatController>();
  late List<CategoryUser> users;
  List<CategoryUser> selectedUsers = [];

  @override
  void initState() {
    users = controller.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.screenHeight,
        child: Column(
          children: [
            const AnimatedAppBar(
              isGroup: false,
              title: "Chat",
            ),
            Expanded(
              child: Padding(
                padding: 10.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTitleWidget(title: tr(context).selectedMembers),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 35,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedUsers.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              decoration: const BoxDecoration(
                                  color: Color(0xFFE5E5E5),),
                              child: InkWell(
                                onTap: () {
                                  selectUser(selectedUsers[index]);
                                },
                                child: Row(
                                  children: [
                                    NoProfileImage(
                                      id: selectedUsers[index].id,
                                      name: selectedUsers[index].username,
                                      size: 27,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(selectedUsers[index].username!),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const IconWidget(
                                      icon: Icons.close,
                                      iconColor: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 10),
                    AppTitleWidget(title: tr(context).contacts),
                    const SizedBox(height: 10),
                    SearchInputWidget(
                        onSearch: searchUsers, hintText: tr(context).search),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.separated(
                                itemCount: users.length,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 5,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return UserListItem(
                                    chat: users[index],
                                    onTap: () {
                                      selectUser(users[index]);
                                    },
                                  );
                                }),
                          ),
                          Center(
                              child: MainButton(
                            width: double.infinity,
                            onPressed: () async {
                              loading = true;
                              setState(() {});

                              ResponseModel response =
                                  await controller.createNewGroup(
                                      widget.groupName,
                                      selectedUsers.map((e) => e.id!).toList(),
                                      null);
                              loading = false;
                              setState(() {});

                              if (response.result == ResultEnum.success) {
                                CreateGroupModel group = response.data;
                                navigateToNewPage(group);
                              } else {
                                Fluttertoast.showToast(
                                    msg: response.message ?? '');
                              }
                            },
                            isEnable: selectedUsers.isNotEmpty,
                            text: tr(context).create,
                            isLoading: loading,
                          )),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  searchUsers(String query) {
    users = controller.getUsers(searchQuery: query);
    selectedUsers.forEach((element) {
      users.remove(element);
    });
    setState(() {});
  }

  void selectUser(CategoryUser user) {
    if (!selectedUsers.contains(user)) {
      selectedUsers.add(user);
      users.remove(user);
    } else {
      selectedUsers.remove(user);
      users.add(user);
    }
    setState(() {});
  }

  navigateToNewPage(CreateGroupModel group) {
    final Navigation navigation = locator<Navigation>();
    navigation.pop();
    // final navigator = Navigator.of(context);
    // navigator.pop();
    controller.showNewMessagePage = false;
    controller.update(["newMessage"]);

    ChatParentClass chat = ChatParentClass(
        id: group.group.id,
        name: group.group.name,
        avatar: group.group.avatar,
        creatorUserId: group.group.creatorUserId,
        categoryId: group.group.categoryId,
        createdAt: group.group.createdAt,
        updatedAt: group.group.updatedAt,
        unreadCount: group.group.unreadCount ?? 0,
        lastMessage: group.group.lastMessage,
        lastRead: group.group.lastRead,
        groupUsers: group.groupUsers);

    navigation.pushReplacement(ChatPage(chat: chat));
  }
}
