import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';

class CallMoreOverlay extends StatelessWidget {
  const CallMoreOverlay({super.key, required this.overlayController});

  final OverlayController overlayController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        overlayController.dismissOverlay();
      },
      child: Container(
        width: 150,
        height: 210,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: const Column(
          children: [
            CallOverlayItems(
              icon: Assets.mirroring,
              title: "Screen Share",
            ),
            Divider(),
            CallOverlayItems(
              icon: Assets.monitorRecorder,
              title: "Record",
            ),
            Divider(),
            CallOverlayItems(
              icon: Assets.profileAdd,
              title: "Add To Call",
            ),
            Divider(),
            CallOverlayItems(
              icon: Assets.profileUser,
              title: "Participants",
            ),
          ],
        ),
      ),
    );
  }
}

class CallOverlayItems extends StatelessWidget {
  const CallOverlayItems({
    super.key,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          IconWidget(
            icon: icon,
            iconColor: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(title)
        ],
      ),
    );
  }
}
