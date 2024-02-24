import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/core/services/media_handler/image_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/widgets/create_group_widgets/bottom_sheet_item.dart';

class CreateNewGroupPage extends StatelessWidget {
  const CreateNewGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(
        haveShadow: false,
        leadingWidth: 40,
        title: tr(context).createGroupTitle,
      ),
      body: Column(
        children: [
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
                              groupImage = await ImageHandler()
                                  .selectImageFile(FilePosition.profile);
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
                  controller: _textController,
                  verticalPadding: 10,
                  textInputType: TextInputType.name,
                  customDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 0),
                    border: InputBorder.none,
                    hintText: tr(context).createATopic,
                    hintStyle: AppTextStyles.overline2.copyWith(
                      color: const Color(0xff4E5670),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isEmpty) {
                      _showAddSubscriberButton = false;
                      setState(() {});
                    } else {
                      _showAddSubscriberButton = true;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
