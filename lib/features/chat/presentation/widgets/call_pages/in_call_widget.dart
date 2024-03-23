import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/app/widgets/round_button.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/call_more_overlay.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/group_in_call_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/call_pages/single_in_call_widget.dart';
import 'package:messaging_core/locator.dart';

class InCallWidget extends StatelessWidget {
  InCallWidget({super.key});

  final CallController controller = locator<CallController>();

  final OverlayController overlayController = OverlayController();

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
              child: controller.callType == CallType.group
                  ? GroupInCallWidget()
                  : SingleCallWidget(),
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
                InkWell(
                  onTap: () {
                    controller.toggleCallMode();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: controller.myVideoClosed
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    child: IconWidget(
                      icon: Assets.disableVideo,
                      iconColor: controller.myVideoClosed
                          ? Colors.black
                          : Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OverlayWidget(
                  overlayController: overlayController,
                  overlayAnchor: OverlayAnchor(
                    offset: Offset((context.screenWidth - 100) / 2,
                        -((context.screenHeight / 1.4) / 2)),
                    followerAnchor: Alignment.topCenter,
                    targetAnchor: Alignment.topCenter,
                  ),
                  overlayWidget: CallMoreOverlay(
                    overlayController: overlayController,
                  ),
                  child: InkWell(
                    onTap: () {
                      overlayController.openOverlay();
                    },
                    child: const IconWidget(
                      icon: Icons.more_vert,
                      iconColor: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                const Spacer(),
                const IconWidget(
                  icon: Assets.refresh,
                  size: 25,
                ),
              ],
            )
          ],
        ));
  }
}
