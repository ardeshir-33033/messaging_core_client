import 'package:flutter/material.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/locator.dart';

class GroupInCallWidget extends StatelessWidget {
  GroupInCallWidget({super.key});
  final CallController controller = locator<CallController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            // flex: 6,
            child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(15),
          ),
        )),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              height: 115,
              width: 86,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              height: 115,
              width: 86,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              height: 115,
              width: 86,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
