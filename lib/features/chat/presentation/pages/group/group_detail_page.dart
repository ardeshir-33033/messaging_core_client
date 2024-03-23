import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/app_title_widget.dart';
import 'package:messaging_core/app/widgets/custom_sliver_persistent_header.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/profile_app_bar.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/users_list_item.dart';

class GroupDetailsPage extends StatefulWidget {
  const GroupDetailsPage({super.key, required this.chat});

  final ChatParentClass chat;

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AnimatedAppBar(
          isGroup: false,
          title: tr(context).chat,
        ),
        Expanded(
          child: ExtendedNestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ProfileAppBar(
                        channel: widget.chat,
                        title: widget.chat.name!,
                        showSubtitle: false,
                        subtitle: "",
                        avatar: (avatarSize, progress) => Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Image.network(Assets.groupBackground,),
                            // ImageWidget(
                            //   imageUrl: Assets.groupBackground,
                            //   boxShape: progress > 0.15
                            //       ? BoxShape.circle
                            //       : BoxShape.rectangle,
                            //   placeHolder: IconWidget(
                            //     icon: widget.chat.isGroup()
                            //         ? Icons.supervised_user_circle
                            //         : Icons.account_circle,
                            //     size: avatarSize,
                            //     iconColor: Colors.grey,
                            //   ),
                            // ),
                            progress < 0.15
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextWidget(
                                          widget.chat.name!,
                                          minFontSize: 18,
                                          style: AppTextStyles.overline
                                              .copyWith(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                        ),
                                        TextWidget(
                                          "${widget.chat.groupUsers!.length.toString()} Online Users",
                                          style: AppTextStyles.overline
                                              .copyWith(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GroupButtons(
                                            icon: Assets.leaveGroup,
                                            title: "Leave"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GroupButtons(
                                            icon: Assets.groupAdd,
                                            title: "Add"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GroupButtons(
                                            icon: Assets.callGroupIcon,
                                            title: "Call"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomSliverPersistentHeader(
                        maxHeight: 47,
                        child: Container(
                            margin: 10.horizontal,
                            color: Colors.white,
                            child: const AppTitleWidget(title: "Members")),
                      ),
                    ),
                  ],
              pinnedHeaderSliverHeightBuilder: () => 100,
              body: ListView.separated(
                  itemCount: widget.chat.groupUsers?.length ?? 0,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemBuilder: (context, index) {
                    return UserListItem(
                        chat: CategoryUser(
                            id: widget.chat.groupUsers![index].id,
                            name: widget.chat.groupUsers![index].name),
                        onTap: () {});
                  })),
        ),
      ],
    )
        // Column(
        //   children: [
        //     SizedBox(
        //       height: context.height / 2,
        //       child: Stack(
        //         children: [
        //           const IconWidget(
        //             icon: Assets.groupTopicPictureIcon,
        //             size: 70,
        //           ),
        //           Positioned(
        //               bottom: 10,
        //               left: 10,
        //               child: Column(
        //                 children: [
        //                   Text(
        //                     widget.chat.name!,
        //                     style: AppTextStyles.body4.copyWith(
        //                       fontSize: 15,
        //                       fontWeight: FontWeight.w400,
        //                     ),
        //                   ),
        //                   Text(
        //                     "${(widget.chat.groupUsers?.length ?? 0).toString()} Users",
        //                     style: AppTextStyles.description.copyWith(
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.w400,
        //                     ),
        //                   )
        //                 ],
        //               ))
        //         ],
        //       ),
        //     ),
        //     const Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 15.0),
        //       child: Column(
        //         children: [
        //           Row(
        //             children: [
        //               GroupButtons(icon: Assets.leaveGroup, title: "Leave"),
        //               GroupButtons(icon: Assets.groupAdd, title: "Add"),
        //               GroupButtons(icon: Assets.callGroupIcon, title: "Call"),
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
        //     Text(
        //       "Members",
        //       style: AppTextStyles.headline3,
        //     )
        //   ],
        // ),
        );
  }
}

class GroupButtons extends StatelessWidget {
  const GroupButtons({super.key, required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          IconWidget(
            icon: icon,
            size: 25,
          ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }
}
