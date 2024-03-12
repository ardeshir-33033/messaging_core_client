import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/presentation/pages/group/edit_group_page.dart';

class AnimatedAppBar extends StatefulWidget {
  const AnimatedAppBar(
      {super.key,
      required this.isGroup,
      this.title,
      this.centerVertical = false,
      this.height});

  final bool isGroup;
  final String? title;
  final bool centerVertical;
  final double? height;

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
            height: widget.height ?? (widget.centerVertical == true ? 40 : 55),
            child: Padding(
              padding: 10.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: widget.centerVertical
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  const IconWidget(
                    icon: Icons.more_vert,
                    iconColor: Colors.white,
                    size: 25,
                  ),
                  TextWidget(
                    widget.title ?? tr(context).chat,
                    style: AppTextStyles.body4.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  widget.isGroup
                      ? IconWidget(
                          icon: openedFullMenu
                              ? Icons.keyboard_arrow_up_outlined
                              : Icons.keyboard_arrow_down_outlined,
                          iconColor: Colors.white,
                          size: 25,
                          onPressed: () {
                            tapAnimatedAppBar();
                          },
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
          if (widget.height == null) const SizedBox(height: 7),
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
          if (widget.isGroup)
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
                          onTap: () {},
                        ),
                        AnimatedAppBarItem(
                          icon: Assets.editMenu,
                          title: tr(context).edit,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditGroupPage()));
                          },
                        ),
                        AnimatedAppBarItem(
                          icon: Assets.trashReviewVoice,
                          title: tr(context).delete,
                          onTap: () {},
                        ),
                        AnimatedAppBarItem(
                          icon: Assets.contact,
                          title: tr(context).users,
                          onTap: () {},
                        ),
                        AnimatedAppBarItem(
                          icon: Assets.camera,
                          title: tr(context).camera,
                          onTap: () {},
                        ),
                        AnimatedAppBarItem(
                          icon: Assets.videoMenu,
                          title: tr(context).video,
                          onTap: () {},
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
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final String icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}
