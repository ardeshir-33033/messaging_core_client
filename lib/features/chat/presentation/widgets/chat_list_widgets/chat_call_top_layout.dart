import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/new_call_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';

class ChatCallTopLayout extends StatelessWidget {
  const ChatCallTopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 1.4,
      child: Column(
        children: [
          const AnimatedAppBar(
            isGroup: false,
            title: "Category Name",
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconWidget(
                icon: Assets.callRemove2,
                size: 100,
              ),
              const SizedBox(height: 10),
              TextWidget(
                tr(context).youHaveNoCall,
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 10),
              TextWidget(
                tr(context).noCallHistoryDesc,
                style: AppTextStyles.body4.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 10),
              NewActionButton(
                icon: Icons.chat,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewCallPage()));
                },
              )
            ],
          ))
        ],
      ),
    );
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
