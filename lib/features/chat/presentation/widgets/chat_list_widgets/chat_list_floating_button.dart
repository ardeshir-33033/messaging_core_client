import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/theme_service.dart';

class ChatListFloatingButton extends StatelessWidget {
  const ChatListFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.red,
      isExtended: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primary1),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                color: AppColors.primary1),
          ),
          const Icon(
            Icons.add,
            size: 15,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
