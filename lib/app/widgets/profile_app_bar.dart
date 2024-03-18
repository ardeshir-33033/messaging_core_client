import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';

class ProfileAppBar extends SliverPersistentHeaderDelegate {
  final ChatParentClass channel;
  final Widget Function(double avatarSize, double progress) avatar;
  final double extent;
  final String title;
  final String subtitle;
  final String? bio;
  final bool showSubtitle;

  ProfileAppBar({
    required this.avatar,
    required this.title,
    required this.channel,
    required this.subtitle,
    required this.showSubtitle,
    this.extent = 300,
    this.bio,
  }) : assert(extent >= 200, '');

  final _avatarAlignTween =
      AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.topLeft);
  final _textAlignTween =
      AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.topLeft);
  final _avatarMarginTween = EdgeInsetsTween(
    begin: const EdgeInsets.only(top: 0, bottom: 8),
    end: const EdgeInsets.only(left: 10, top: 10, bottom: 0),
  );

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(ProfileAppBar oldDelegate) {
    return avatar != oldDelegate.avatar || title != oldDelegate.title;
  }

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final titleMarginTween = EdgeInsetsTween(
      begin: EdgeInsets.only(bottom: showSubtitle ? 32 : 18, top: 54),
      end: EdgeInsets.only(left: 60, top: showSubtitle ? 10 : 20, bottom: 0),
    );

    final subtitleMarginTween = EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 10, top: 78),
      end: EdgeInsets.only(left: 96, top: showSubtitle ? 10 : 10, bottom: 0),
    );

    final tempVal = maxExtent * 72 / 100;
    final progress = shrinkOffset > tempVal ? 1.0 : shrinkOffset / tempVal;
    final avatarMargin = _avatarMarginTween.lerp(progress);
    final titleMargin = titleMarginTween.lerp(progress);
    final subtitleMargin = subtitleMarginTween.lerp(progress);

    final avatarAlign = _avatarAlignTween.lerp(progress);
    final textAlign = _textAlignTween.lerp(progress);

    final fontFactor = (1 - progress);

    const int avatarMinimumSize = 40;
    double avatarSizeFactor = (1 - progress) * 150;

    final avatarSize = avatarSizeFactor + avatarMinimumSize;

    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: avatarMargin,
            child: Align(
              alignment: avatarAlign,
              child: SizedBox(
                height: progress < 0.15 ? avatarSize * 2 : avatarSize,
                width: progress < 0.15 ? avatarSize * 2 : avatarSize,
                child: avatar.call(avatarSize, progress),
              ),
            ),
          ),
          if (progress == 1) ...[
            Padding(
              padding: titleMargin,
              child: Align(
                alignment: textAlign,
                child: SizedBox(
                  height: (fontFactor * 8) + 16,
                  child: TextWidget(
                    title,
                    minFontSize: (fontFactor * 16).toInt().toDouble(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: subtitleMargin,
            //   child: Align(
            //     alignment: textAlign,
            //     child: showSubtitle
            //         ? Row(
            //             mainAxisSize: MainAxisSize.min,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SizedBox(
            //                 height: (fontFactor * 6) + 12,
            //                 child: TextWidget(
            //                   subtitle,
            //                   minFontSize:
            //                       ((fontFactor * 2) + 10).toInt().toDouble(),
            //                   style: const TextStyle(
            //                     color: Color(0xff4E5670),
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(
            //                 width: 4,
            //               ),
            //             ],
            //           )
            //         : const SizedBox.shrink(),
            //   ),
            // ),
          ],
          // Padding(
          //   padding: const EdgeInsets.only(left: 16),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 16, top: 10),
          //       child: Row(
          //         children: [
          //           InkWell(
          //             onTap: () {
          //               Navigator.pop(context);
          //             },
          //             child: const Icon(
          //               Icons.arrow_back,
          //               size: 24,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
