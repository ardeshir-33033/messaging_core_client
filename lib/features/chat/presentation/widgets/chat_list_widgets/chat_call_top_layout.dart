import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/app_title_widget.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/search_input_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/new_call_page.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/users_item_widget.dart';
import 'package:messaging_core/locator.dart';

class ChatCallTopLayout extends StatefulWidget {
  const ChatCallTopLayout({super.key});

  @override
  State<ChatCallTopLayout> createState() => _ChatCallTopLayoutState();
}

class _ChatCallTopLayoutState extends State<ChatCallTopLayout> {
  final ChatController controller = locator<ChatController>();

  List<CategoryUser> users = [];

  @override
  void initState() {
    users = controller.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        id: "allChats",
        builder: (_) {
          return SizedBox(
            height: context.screenHeight / 1.4,
            child: Column(
              children: [
                AnimatedAppBar(
                  isGroup: false,
                  title: tr(context).call,
                  categoryTitle: "Sport",
                ),
                Expanded(
                    child: Padding(
                  padding: 10.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTitleWidget(title: tr(context).newCall),
                      SearchInputWidget(
                          onSearch: searchUsers, hintText: tr(context).search),
                      Expanded(
                          child: ListView.separated(
                              itemCount: users.length,
                              separatorBuilder: (context, int index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemBuilder: (context, int index) {
                                return UsersItemWidget(
                                  user: users[index],
                                  onPressed: () {
                                    final Navigation navigation =
                                        locator<Navigation>();

                                    navigation
                                        .push(ChatPage(chat: users[index]));
                                  },
                                );
                              }))
                    ],
                  ),
                ))
              ],
            ),
          );
        });
  }

  searchUsers(String query) {
    users = controller.getUsers(searchQuery: query);
    setState(() {});
  }
}

class NewActionButton extends StatelessWidget {
  const NewActionButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final Function() onTap;
  final dynamic icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primary1),
      child: InkWell(
        onTap: onTap,
        // isExtended: true,
        child: Padding(
          padding: 8.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconWidget(
                icon: icon,
                iconColor: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 5),
              TextWidget(
                tr(context).newTitle,
                style: AppTextStyles.body3.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
