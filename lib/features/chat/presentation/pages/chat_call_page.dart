import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_list_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/chat_call_top_layout.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/notifications_tab.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/user_contacts_drawer.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/chat_page_drawer.dart';

class ChatCallPage extends StatefulWidget {
  const ChatCallPage({super.key});

  @override
  State<ChatCallPage> createState() => _ChatCallPageState();
}

class _ChatCallPageState extends State<ChatCallPage>
    with SingleTickerProviderStateMixin {
  final ScrollController pageScrollController = ScrollController();

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChatPageDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: pageScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChatCallTopLayout(),
                const AnimatedAppBar(
                  isGroup: false,
                  centerVertical: true,
                ),
                TabBar(
                  // padding: const EdgeInsets.fromLTRB(0, 0, 100, 8),
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  unselectedLabelStyle: AppTextStyles.body4.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: const Color(0xFFBABABA),
                  ),
                  labelStyle: AppTextStyles.body4.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                  controller: tabController,
                  tabs: [
                    Tab(text: tr(context).notifications),
                    Tab(text: tr(context).chats),
                  ],
                ),
                SizedBox(
                    height: context.screenHeight - 150,
                    child: TabBarView(
                      controller: tabController,
                      children: const [NotificationsTab(), ChatListPage()],
                    )),
              ],
            ),
          ),
          const UserContactsDrawer(),
        ],
      ),
    );
  }
}
