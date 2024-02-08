import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_box.dart';
import 'package:messaging_core/features/chat/presentation/widgets/content_date_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversation_appbar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_message_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final ChatParentClass chat;

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
  final TextEditingController _sendTextController = TextEditingController();

  final ChatController controller =
      // Get.put<ChatController>(locator());
      locator<ChatController>();

  @override
  void initState() {
    controller.getMessages(
        widget.chat.getReceiverType(), AppGlobalData.userId, widget.chat.id!);
    scrollNotificationController = StreamController();
    _overlayController = OverlayController();
    _initAnimations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        haveShadow: false,
        leadingWidth: 40,
        color: const Color(0xFF5AC4F6),
        textStyle: AppTextStyles.body4.copyWith(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        leadingWidget: const IconWidget(
          icon: Icons.more_vert,
          iconColor: Colors.white,
          size: 25,
        ),
        actions: const [
          IconWidget(
            padding: 10,
            icon: Icons.keyboard_arrow_down_outlined,
            iconColor: Colors.white,
            size: 25,
          )
        ],
        title: tr(context).chat,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                padding: 8.horizontal,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7E7E7),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ConversationAppBar(
                      chat: widget.chat,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GetBuilder<ChatController>(
                          id: "messages",
                          builder: (_) {
                            if (controller.messagesStatus.status ==
                                Status.success) {
                              return NotificationListener<
                                  UserScrollNotification>(
                                onNotification: (notification) {
                                  scrollNotificationController.sink
                                      .add(notification);
                                  return false;
                                },
                                child: ScrollablePositionedList.builder(
                                    itemCount: controller.messages.length,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    reverse: true,
                                    itemScrollController: _itemScrollController,
                                    itemPositionsListener:
                                        _itemPositionsListener,
                                    itemBuilder: (_, index) {
                                      return Column(
                                        children: [
                                          ContentDateWidget(
                                            timeStamp: controller
                                                .messages[index].updatedAt,
                                            showData: index ==
                                                    controller.messages.length -
                                                        1
                                                ? true
                                                : (controller
                                                    .messages[index].updatedAt
                                                    .isNotSameDateAs(controller
                                                        .messages[index + 1]
                                                        .updatedAt)),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            color: (controller.messages[index]
                                                        .contentId ==
                                                    _repliedItemToAnimate)
                                                ? _replyToColorAnimation.value
                                                : null,
                                            child: ChatBox(
                                              opponentProfile:
                                                  ContactProfile(userId: "1"),
                                              overlayController:
                                                  _overlayController,
                                              content:
                                                  controller.messages[index],
                                              isGroup: widget.chat.isGroup(),
                                              onReplyTap: () => _onReplyTap(
                                                  controller.messages[index]
                                                      .repliedTo),
                                              isFirstSenderContent: index ==
                                                      controller
                                                              .messages.length -
                                                          1
                                                  ? true
                                                  : (controller
                                                              .messages[
                                                                  index + 1]
                                                              .senderId !=
                                                          controller
                                                              .messages[index]
                                                              .senderId ||
                                                      controller
                                                          .messages[index + 1]
                                                          .contentType
                                                          .isGeneralContent),
                                              isLastSenderContent: index == 0
                                                  ? true
                                                  : (controller
                                                              .messages[
                                                                  index - 1]
                                                              .senderId !=
                                                          controller
                                                              .messages[index]
                                                              .senderId ||
                                                      controller
                                                          .messages[index - 1]
                                                          .contentType
                                                          .isGeneralContent),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            } else {
                              return const Center(child: LoadingWidget());
                            }
                          }),
                    ),
                    const Divider(
                      color: Color(0xFFD6D6D6),
                      thickness: 2,
                    ),
                    // const SizedBox(height: 10),
                    SendMessageWidget(
                      textController: _sendTextController,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onReplyTap(ContentModel? replyContent) async {
    if (replyContent == null) return;
    // await _currentChannelContentProvider
    //     .loadPreviousContentsUntil(replyContent.sequenceNumber);
    _repliedItemToAnimate = replyContent.contentId;
    setState(() {});
    _scrollToSeqNo(replyContent.contentId);
    await _replyToAnimationController.forward(from: 0);
  }

  _scrollToSeqNo(int seqNo, {bool ignoreScrollToFirst = false}) async {
    int scrollToIndex = controller
        .messages
        // _currentChannelContentProvider
        //     .getContents()
        .reversed
        .toList()
        .indexWhere((e) => e.contentId == seqNo);

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
