import 'package:api_handler/api_handler.dart';
import 'package:api_handler/feature/api_handler/data/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/component/TextFieldWidget.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/component/main_button.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/SelectableModel.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/data/models/create_group_model.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/group_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/bottom_sheet_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/row_user_profile_widget.dart';
import 'package:messaging_core/locator.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({
    super.key,
  });

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final TextEditingController textEditingController = TextEditingController();

  FileModel? groupImage;
  bool loading = false;
  final ChatController chatController = locator<ChatController>();
  final GroupController groupController = locator<GroupController>();
  late List<SelectableModel<CategoryUser>> users = [];
  List<CategoryUser> selectedUsers = [];
  late ChatParentClass chat;

  @override
  void initState() {
    chat = chatController.currentChat!;
    textEditingController.text = chat.name!;
    selectInitialUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr(context).editGroupTitle,
        onPressBack: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: 10.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    CustomBottomSheet.showSimpleSheet(
                        context,
                        (context) => Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    groupImage =
                                        await ImageHandler().takePicture();
                                  },
                                  child: BottomSheetItem(
                                    asset: Assets.groupTopicPictureIcon,
                                    title: tr(context).takePhoto,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    groupImage =
                                        await ImageHandler().selectImageFile();
                                    print(groupImage);
                                  },
                                  child: BottomSheetItem(
                                    asset: Assets.choosePhotoIcon,
                                    title: tr(context).choosePhoto,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary2[100]),
                                        child: const IconWidget(
                                          icon: Icons.close,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        tr(context).cancel,
                                        style: AppTextStyles.body2.copyWith(
                                            color: AppColors.primary1),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.primary3.shade100,
                        shape: BoxShape.circle),
                    child: const IconWidget(icon: Assets.groupTopicPictureIcon),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextFieldWidget(
                    key: const Key("groupNameInput"),
                    controller: textEditingController,
                    verticalPadding: 10,
                    textInputType: TextInputType.name,
                    customDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      border: InputBorder.none,
                      hintText: tr(context).groupName,
                      hintStyle: AppTextStyles.overline2.copyWith(
                        color: const Color(0xff4E5670),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    onChanged: (val) {
                      // if (val.isEmpty) {
                      //   _showAddSubscriberButton = false;
                      //   setState(() {});
                      // } else {
                      //   _showAddSubscriberButton = true;
                      //   setState(() {});
                      // }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 7),
            Padding(
              padding: 10.left,
              child: TextWidget("${tr(context).users}:"),
            ),
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
                    return RowUserProfileWidget(
                      user: users[index].model,
                      isMultiSelect: true,
                      hasRadioButton: true,
                      isSelected: users[index].isSelected,
                      onTap: () {
                        selectUser(users[index]);
                      },
                    );
                  }),
            ),
            Center(
                child: MainButton(
              onPressed: () async {
                if (textEditingController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please fill the group Name");
                  return;
                } else {
                  loading = true;
                  setState(() {});

                  ResponseModel response = await groupController.editGroup(
                      textEditingController.text,
                      selectedUsers.map((e) => e.id!).toList(),
                      chat.id!,
                      file: groupImage);
                  loading = false;
                  setState(() {});

                  if (response.result == ResultEnum.success) {
                    CreateGroupModel group = response.data;
                    navigateToNewPage(group);
                  } else {
                    Fluttertoast.showToast(msg: response.message ?? '');
                  }
                }
              },
              isEnable: selectedUsers.isNotEmpty,
              text: tr(context).edit,
              isLoading: loading,
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  selectInitialUsers() {
    users = chatController.users.map((e) => SelectableModel(e, false)).toList();

    List<SelectableModel<CategoryUser>> matchingCategoryUsers = users
        .where((element) => chat.groupUsers!
            .any((groupUser) => groupUser.id == element.model.id))
        .toList();

    users.forEach((user) {
      if (matchingCategoryUsers
          .any((matchingUser) => matchingUser.model.id == user.model.id)) {
        user.toggleSelection();
        selectedUsers.add(user.model);
      }
    });
  }

  void selectUser(SelectableModel<CategoryUser> user) {
    user.toggleSelection();
    if (user.isSelected) {
      selectedUsers.add(user.model);
    } else {
      selectedUsers.remove(user.model);
    }
    setState(() {});
  }

  navigateToNewPage(CreateGroupModel group) {
    final navigator = Navigator.of(context);

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

    navigator.pop();

    navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => ChatPage(chat: chat)));
  }
}
