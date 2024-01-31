import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class ContentDateWidget extends StatelessWidget {
  final DateTime timeStamp;
  final bool showData;

  const ContentDateWidget({
    Key? key,
    required this.timeStamp,
    required this.showData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showData == false) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: TextWidget(
        timeStamp.getContentDateFromNow(),
        style: AppTextStyles.overline2
            .copyWith(fontSize: 10, color: Colors.black.withOpacity(0.8)),
      ),
    );
  }
}
