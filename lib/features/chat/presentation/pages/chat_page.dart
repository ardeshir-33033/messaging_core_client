import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_box.dart';
import 'package:messaging_core/features/chat/presentation/widgets/content_date_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late StreamController<UserScrollNotification> scrollNotificationController;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int? _repliedItemToAnimate;
  late Animation<Color?> _replyToColorAnimation;
  late AnimationController _replyToAnimationController;
  late OverlayController _overlayController;

  List<ContentModel> contents = [];

  @override
  void initState() {
    scrollNotificationController = StreamController();
    _initAnimations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        scrollNotificationController.sink.add(notification);
        return false;
      },
      child: ScrollablePositionedList.builder(
          itemCount: contents.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          reverse: true,
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          itemBuilder: (_, index) {
            return Column(
              children: [
                ContentDateWidget(
                  timeStamp: contents[index].timestamp,
                  showData: index == contents.length - 1
                      ? true
                      : (contents[index]
                          .timestamp
                          .isNotSameDateAs(contents[index + 1].timestamp)),
                ),
                Container(
                  width: double.infinity,
                  color:
                      (contents[index].sequenceNumber == _repliedItemToAnimate)
                          ? _replyToColorAnimation.value
                          : null,
                  child: ChatBox(
                    opponentProfile: ContactProfile(userId: "1"),
                    overlayController: _overlayController,
                    content: contents[index],
                    isGroup: false,
                    onReplyTap: () => _onReplyTap(contents[index].repliedTo),
                    isFirstSenderContent: index == contents.length - 1
                        ? true
                        : (contents[index + 1].senderId !=
                                contents[index].senderId ||
                            contents[index + 1].contentType.isGeneralContent),
                  ),
                ),
              ],
            );
          }),
    ));
  }

  _onReplyTap(ContentModel? replyContent) async {
    if (replyContent == null) return;
    // await _currentChannelContentProvider
    //     .loadPreviousContentsUntil(replyContent.sequenceNumber);
    _repliedItemToAnimate = replyContent.sequenceNumber;
    setState(() {});
    _scrollToSeqNo(replyContent.sequenceNumber);
    await _replyToAnimationController.forward(from: 0);
  }

  _scrollToSeqNo(int seqNo, {bool ignoreScrollToFirst = false}) async {
    int scrollToIndex = contents
        // _currentChannelContentProvider
        //     .getContents()
        .reversed
        .toList()
        .indexWhere((e) => e.sequenceNumber == seqNo);

    if (!ignoreScrollToFirst || scrollToIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        _itemScrollController.scrollTo(
            alignment: 0.8,
            index: scrollToIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubicEmphasized);
      });
    }
  }

  void _initAnimations() {
    _replyToAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _replyToColorAnimation = ColorTween(
      begin: AppColors.primary3[300], // Starting color
      end: AppColors.primary3[800], // Ending color
    ).animate(CurvedAnimation(
        parent: _replyToAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut));

    _replyToAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _repliedItemToAnimate = null;
        setState(() {});
      }
    });
  }
}
