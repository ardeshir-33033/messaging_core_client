import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/round_button.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/locator.dart';

class InCallWidget extends StatelessWidget {
  InCallWidget({super.key});

  final CallController controller = locator<CallController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: context.screenHeight / 1.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
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
          Row(
            children: [
              RoundButton(
                color: Colors.red,
                asset: Assets.callRemove,
                iconColor: Colors.white,
                size: 40,
                onTap: () {
                  controller.setCallStatus(CallStatus.noCall);
                },
              ),
              const SizedBox(width: 10),
              const IconWidget(
                icon: Assets.profileAdd,
                size: 25,
              ),
              const SizedBox(width: 10),
              const IconWidget(
                icon: Icons.keyboard_voice,
                iconColor: Colors.white,
                size: 25,
              ),
              const SizedBox(width: 10),
              const IconWidget(
                icon: Assets.disableVideo,
                size: 25,
              ),
              const SizedBox(width: 10),
              const IconWidget(
                icon: Icons.more_vert,
                iconColor: Colors.white,
                size: 25,
              ),
              const Spacer(),
              const IconWidget(
                icon: Assets.refresh,
                size: 25,
              ),
            ],
          )
        ],
      ),
    );
  }
}
