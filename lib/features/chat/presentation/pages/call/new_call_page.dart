import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/app_title_widget.dart';
import 'package:messaging_core/app/widgets/search_input_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/waiting_call_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/users_list_item.dart';
import 'package:messaging_core/locator.dart';

class NewCallPage extends StatefulWidget {
  const NewCallPage({super.key});

  @override
  State<NewCallPage> createState() => _NewCallPageState();
}

class _NewCallPageState extends State<NewCallPage> {
  final ChatController controller = locator<ChatController>();
  final Navigation navigation = locator<Navigation>();

  List<CategoryUser> usersList = [];
  @override
  void initState() {
    usersList = controller.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.screenHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedAppBar(
                isGroup: false,
                // centerVertical: true,
              ),
              SizedBox(
                height: context.screenHeight - 80,
                child: Padding(
                  padding: 10.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AppTitleWidget(
                        title: tr(context).call,
                      ),
                      const SizedBox(height: 10),
                      SearchInputWidget(
                          onSearch: searchUsers, hintText: tr(context).search),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            itemCount: usersList.length,
                            itemBuilder: (context, index) {
                              return UserListItem(
                                chat: usersList[index],
                                onTap: () {
                                  navigation.push(const WaitingCallPage());
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  searchUsers(String query) {
    usersList = controller.getUsers(searchQuery: query);
    setState(() {});
  }
}
