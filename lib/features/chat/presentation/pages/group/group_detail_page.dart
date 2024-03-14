import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';

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
          SizedBox(
            height: context.height / 2,
            child: Stack(
              children: [
                const IconWidget(
                  icon: Assets.groupTopicPictureIcon,
                  size: 70,
                ),
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: Column(
                      children: [
                        Text(
                          widget.chat.name!,
                          style: AppTextStyles.body4.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${(widget.chat.groupUsers?.length ?? 0).toString()} Users",
                          style: AppTextStyles.description.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GroupButtons(icon: Assets.leaveGroup, title: "Leave"),
                    GroupButtons(icon: Assets.groupAdd, title: "Add"),
                    GroupButtons(icon: Assets.callGroupIcon, title: "Call"),
                  ],
                )
              ],
            ),
          ),
          Text(
            "Members",
            style: AppTextStyles.headline3,
          )
        ],
      ),
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
      width: 120,
      height: 60,
      child: Row(
        children: [
          IconWidget(
            icon: icon,
          ),
          SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }
}
