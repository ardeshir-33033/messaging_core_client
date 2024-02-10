import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';

class AnimatedAppBar extends StatefulWidget {
  const AnimatedAppBar({super.key});

  @override
  State<AnimatedAppBar> createState() => _AnimatedAppBarState();
}

class _AnimatedAppBarState extends State<AnimatedAppBar> {
  bool openedFullMenu = false;
  bool showMenuItems = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5AC4F6),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: Padding(
              padding: 10.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const IconWidget(
                    icon: Icons.more_vert,
                    iconColor: Colors.white,
                    size: 25,
                  ),
                  TextWidget(
                    tr(context).chat,
                    style: AppTextStyles.body4.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  IconWidget(
                    icon: Icons.keyboard_arrow_down_outlined,
                    iconColor: Colors.white,
                    size: 25,
                    onPressed: () {
                      tapAnimatedAppBar();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          if (openedFullMenu)
            Padding(
              padding: 10.horizontal,
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                height: 5,
                thickness: 0.5,
              ),
            ),
          if (openedFullMenu) const SizedBox(height: 7),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: openedFullMenu ? 50 : 0,
            color: const Color(0xFF5AC4F6),
            child: showMenuItems
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedAppBarItem(
                        icon: Assets.addMenu,
                        title: tr(context).add,
                      ),
                      AnimatedAppBarItem(
                        icon: Assets.editMenu,
                        title: tr(context).edit,
                      ),
                      AnimatedAppBarItem(
                        icon: Assets.trashReviewVoice,
                        title: tr(context).delete,
                      ),
                      AnimatedAppBarItem(
                        icon: Assets.contact,
                        title: tr(context).users,
                      ),
                      AnimatedAppBarItem(
                        icon: Assets.camera,
                        title: tr(context).camera,
                      ),
                      AnimatedAppBarItem(
                        icon: Assets.videoMenu,
                        title: tr(context).video,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  tapAnimatedAppBar() async {
    if (openedFullMenu) {
      showMenuItems = false;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 100), () {
        openedFullMenu = false;
        setState(() {});
      });
    } else {
      openedFullMenu = true;
      setState(() {});

      Future.delayed(const Duration(milliseconds: 450), () {
        showMenuItems = true;
        setState(() {});
      });
    }
  }
}

class AnimatedAppBarItem extends StatelessWidget {
  const AnimatedAppBarItem(
      {super.key, required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconWidget(
          icon: icon,
          iconColor: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 5),
        TextWidget(
          title,
          style: AppTextStyles.overline2.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
