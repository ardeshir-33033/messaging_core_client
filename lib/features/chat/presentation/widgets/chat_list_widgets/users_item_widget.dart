import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';

class UsersItemWidget extends StatelessWidget {
  const UsersItemWidget({super.key, required this.user, this.onPressed});

  final CategoryUser user;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          NoProfileImage(
            id: user.id,
            name: user.username,
            size: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            user.username ?? "",
            style: AppTextStyles.overline1,
          ),
        ],
      ),
    );
  }
}
