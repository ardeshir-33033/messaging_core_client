import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/component/TextFieldWidget.dart';
import 'package:messaging_core/app/component/main_button.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/pages/group/create_new_group_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';

class AddGroupNamePage extends StatelessWidget {
  AddGroupNamePage({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AnimatedAppBar(
            isGroup: false,
            title: "Chat",
          ),
          Padding(
            padding: 20.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextWidget(
                  tr(context).groupName,
                  style: AppTextStyles.body4,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: textEditingController,
                  borderRadius: 10,
                  verticalPadding: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: MainButton(
                  width: double.infinity,
                  onPressed: () async {
                    if (textEditingController.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please fill the group Name");
                      return;
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateNewGroupPage(
                                    groupName: textEditingController.text,
                                  )));
                    }
                    // else {
                    //   loading = true;
                    //   setState(() {});
                    //
                    //   ResponseModel response =
                    //   await controller.createNewGroup(
                    //       textEditingController.text,
                    //       selectedUsers.map((e) => e.id!).toList(),
                    //       null);
                    //   loading = false;
                    //   setState(() {});
                    //
                    //   if (response.result == ResultEnum.success) {
                    //     CreateGroupModel group = response.data;
                    //     navigateToNewPage(group);
                    //   } else {
                    //     Fluttertoast.showToast(msg: response.message ?? '');
                    //   }
                    // }
                  },
                  isEnable: true,
                  text: tr(context).continueTitle,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
