import 'package:flutter/material.dart';
import 'package:messaging_core/app/widgets/skeleton_widget.dart';

class ConversationSkeletonWidget extends StatelessWidget {
  const ConversationSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          SkeletonWidget.circular(width: 50, height: 50),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                SkeletonWidget.rectangular(
                  width: double.infinity,
                  height: 20,
                ),
                SizedBox(height: 10),
                SkeletonWidget.rectangular(
                  width: double.infinity,
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
