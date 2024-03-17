import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/app_title_widget.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/search_input_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/users_list_item.dart';
import 'package:messaging_core/locator.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final ChatController controller = locator<ChatController>();

  List<CategoryUser> users = [];

  @override
  void initState() {
    users = controller.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitleWidget(title: tr(context).newMessage),
          buildNewRow(tr(context).newGroup, Assets.newGroup),
          const SizedBox(height: 10),
          buildNewRow(tr(context).newCommunity, Assets.newCommunity),
          const SizedBox(height: 16),
          SearchInputWidget(
              onSearch: searchUsers, hintText: tr(context).search),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserListItem(
                    chat: users[index],
                    onTap: () {},
                  );
                }),
          ),
        ],
      ),
    );
  }

  searchUsers(String query) {
    users = controller.getUsers(searchQuery: query);
    setState(() {});
  }

  Row buildNewRow(String title, String icon) {
    return Row(
      children: [
        IconWidget(
          icon: icon,
          size: 20,
        ),
        const SizedBox(width: 5),
        TextWidget(
          title,
          style: AppTextStyles.overline1,
        ),
      ],
    );
  }
}
