import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/round_button.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';

class ChatPageTopLayout extends StatelessWidget {
  const ChatPageTopLayout({
    super.key,
    required this.pageScrollController,
    required this.chat,
    required this.isGroup,
  });

  final ScrollController pageScrollController;
  final ChatParentClass chat;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AnimatedAppBar(
          isGroup: false,
          title: "Category Name",
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  height: context.screenHeight / 1.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Join Meet",
                        style:
                            AppTextStyles.body1.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: context.screenWidth / 1.5,
                        height: context.screenHeight / 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15.0),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const IconWidget(
                                    icon: Icons.keyboard_voice,
                                    iconColor: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 15,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const IconWidget(
                                  icon: Assets.disableVideo,
                                  size: 25,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: NoProfileImage(
                                    name: AppGlobalData.userName,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppGlobalData.userName,
                                  style: AppTextStyles.body3
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: context.screenWidth / 1.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary1,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                            child: Text(
                          "Create New Meet",
                          style:
                              AppTextStyles.body3.copyWith(color: Colors.white),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: context.screenWidth / 1.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                            child: Text(
                          "Join Meet",
                          style:
                              AppTextStyles.body3.copyWith(color: Colors.white),
                        )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: context.screenWidth / 1.5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                            child: Text(
                          "Cancel",
                          style:
                              AppTextStyles.body3.copyWith(color: Colors.white),
                        )),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        // IconWidget(
        //   icon: isGroup ? Icons.supervised_user_circle : Icons.account_circle,
        //   size: 300,
        //   iconColor: Colors.grey,
        // ),
        InkWell(
          onTap: () {
            pageScrollController.animateTo(
                pageScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
          child: AnimatedAppBar(
            isGroup: chat.isGroup(),
            centerVertical: true,
            height: 40,
          ),
        ),
      ],
    );
  }
}
