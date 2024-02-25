import 'package:flutter/material.dart';
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
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/bottom_sheet_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/row_user_profile_widget.dart';
import 'package:messaging_core/locator.dart';

class CreateNewGroupPage extends StatefulWidget {
  const CreateNewGroupPage({super.key});

  @override
  State<CreateNewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends State<CreateNewGroupPage> {
  final TextEditingController textEditingController = TextEditingController();

  FileModel? groupImage;
  bool _showCreateGroupButton = false;
  bool loading = false;
  final ChatController controller = locator<ChatController>();
  late List<SelectableModel<CategoryUser>> users;

  @override
  void initState() {
    users = controller.users.map((e) => SelectableModel(e, false)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr(context).createGroupTitle,
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
              onPressed: () {},
              text: tr(context).create,
              isLoading: loading,
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void selectUser(SelectableModel<CategoryUser> user) {
    user.toggleSelection();
    setState(() {});
  }
}