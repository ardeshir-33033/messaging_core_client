import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';

import '../../../../../app/widgets/icon_widget.dart';

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({Key? key, required this.asset, required this.title})
      : super(key: key);
  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColors.primary2[100]),
          child: IconWidget(
            icon: asset,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.body2.copyWith(color: AppColors.primary1),
        )
      ],
    );
  }
}
