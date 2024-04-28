import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/page_routing/custom_transition.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/loading_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/app_states/result_state.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/services/navigation/navigation_utils.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/emoji_controller.dart';
import 'package:messaging_core/features/chat/presentation/manager/record_voice_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/animated_app_bar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_box.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_list_widgets/user_contacts_drawer.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/call_participants_drawer.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/chat_page_top_layout.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_page_widgets/pinned_messages_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/content_date_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/conversation_appbar.dart';
import 'package:messaging_core/features/chat/presentation/widgets/emoji_picker.dart';
import 'package:messaging_core/features/chat/presentation/widgets/send_message_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final GlobalKey<ScaffoldState> chatPageKey = GlobalKey();

class ChatPage extends StatefulWidget implements CanPop {
  ChatPage({super.key, required this.chat, this.isForwarded});

  final ChatParentClass chat;
  bool? isForwarded = false;

  final EmojiController emojiController = Get.find<EmojiController>();

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  Future<bool> willPop() async {
    final ChatController controller = locator<ChatController>();
    final Navigation navigation = locator<Navigation>();

    if (emojiController.emojiShowing) {
      emojiController.stopShowingEmoji();
      return false;
    } else {
      controller.onBackButtonOnChatPage();
      navigation.removePage();

      return false;
    }
  }
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
  final ScrollController _scrollController = ScrollController();
  final ScrollController pageScrollController = ScrollController();

  final ChatController controller = locator<ChatController>();

  final RecordVoiceController voiceController =
      Get.put(RecordVoiceController());

  final CallController callController = locator<CallController>();

  bool showOverlay = false;
  Offset? targetPos;
  Widget? target;
  final double padding = 8;

  _showOverlay(Offset position, Widget? target) {
    setState(() {
      targetPos = position;
      this.target = target;
      showOverlay = true;
    });
  }

  _hideOverlay() {
    setState(() {
      showOverlay = false;
      targetPos = null;
      target = null;
    });
  }

  @override
  void initState() {
    // voiceController.initialRecording();
    controller.setCurrentChat(widget.chat);
    callController.callType =
        widget.chat.isGroup() ? CallType.group : CallType.single;
    controller.joinRoom();

    // if (widget.chat.lastMessage != null) {
    controller.getMessages();
    // }
    scrollNotificationController = StreamController();
    _overlayController = OverlayController();
    _initAnimations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: chatPageKey,
      drawerEnableOpenDragGesture: false,
      drawer: const CallParticipantsDrawer(),
      body: SingleChildScrollView(
        controller: pageScrollController,
        child: Column(
          children: [
            ChatPageTopLayout(
                pageScrollController: pageScrollController,
                isGroup: widget.chat.isGroup(),
                chat: widget.chat),
            GetBuilder<ChatController>(
                id: "chatPage",
                builder: (_) {
                  return SizedBox(
                    height: context.screenHeight - 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFE7E7E7),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      ConversationAppBar(
                                        chat: widget.chat,
                                        size: 40,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: 8.horizontal,
                                          child: Column(
                                            children: [
                                              GetBuilder<ChatController>(
                                                  id: "pin",
                                                  builder: (_) {
                                                    if (controller
                                                            .pinnedMessage !=
                                                        null) {
                                                      return PinnedMessagesWidget(
                                                          isGroup: widget.chat
                                                              .isGroup(),
                                                          onPinTap: () =>
                                                              _onPinTap(controller
                                                                  .pinnedMessage));
                                                    }
                                                    return const SizedBox();
                                                  }),
                                              // const SizedBox(height: 10),
                                              Expanded(
                                                child:
                                                    GetBuilder<ChatController>(
                                                        id: "messages",
                                                        builder: (_) {
                                                          if (controller
                                                                  .messagesStatus
                                                                  .status ==
                                                              Status.success) {
                                                            return NotificationListener<
                                                                UserScrollNotification>(
                                                              onNotification:
                                                                  (notification) {
                                                                scrollNotificationController
                                                                    .sink
                                                                    .add(
                                                                        notification);
                                                                return false;
                                                              },
                                                              child: ScrollablePositionedList
                                                                  .builder(
                                                                      itemCount: controller
                                                                          .messages
                                                                          .length,
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              8),
                                                                      reverse:
                                                                          true,
                                                                      itemScrollController:
                                                                          _itemScrollController,
                                                                      itemPositionsListener:
                                                                          _itemPositionsListener,
                                                                      itemBuilder:
                                                                          (_, index) {
                                                                        return Column(
                                                                          children: [
                                                                            ContentDateWidget(
                                                                              timeStamp: controller.messages[index].createdAt,
                                                                              showData: index == controller.messages.length - 1 ? true : (controller.messages[index].createdAt.isNotSameDateAs(controller.messages[index + 1].createdAt)),
                                                                            ),
                                                                            Container(
                                                                              width: double.infinity,
                                                                              color: (controller.messages[index].contentId == _repliedItemToAnimate) ? _replyToColorAnimation.value : null,
                                                                              child: ChatBox(
                                                                                onTap: _showOverlay,
                                                                                opponentProfile: ContactProfile(userId: "1"),
                                                                                overlayController: _overlayController,
                                                                                content: controller.messages[index],
                                                                                isGroup: widget.chat.isGroup(),
                                                                                onEditTap: (String val) {
                                                                                  _sendTextController.text = val;
                                                                                  // _sendTextController.f
                                                                                },
                                                                                onReplyTap: () => _onReplyTap(controller.messages[index].replied),
                                                                                isFirstSenderContent: index == controller.messages.length - 1 ? true : (controller.messages[index + 1].senderId != controller.messages[index].senderId || controller.messages[index + 1].contentType.isGeneralContent),
                                                                                isLastSenderContent: index == 0 ? true : (controller.messages[index - 1].senderId != controller.messages[index].senderId || controller.messages[index - 1].contentType.isGeneralContent),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }),
                                                            );
                                                          } else {
                                                            return const Center(
                                                                child:
                                                                    LoadingWidget());
                                                          }
                                                        }),
                                              ),
                                              SendMessageWidget(
                                                textController:
                                                    _sendTextController,
                                                chat: widget.chat,
                                                scrollController:
                                                    _scrollController,
                                                onUpdateScroll: () {
                                                  updateScrollToLastMessage();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          EmojiPickerWidget(
                            textController: _sendTextController,
                            scrollController: _scrollController,
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  _onPinTap(ContentModel? pinnedContent) async {
    if (pinnedContent == null) return;
    _repliedItemToAnimate = pinnedContent.contentId;
    setState(() {});
    _scrollToSeqNo(pinnedContent.contentId);
    await _replyToAnimationController.forward(from: 0);
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

  void updateScrollToLastMessage() {
    if (_itemPositionsListener.itemPositions.value.isNotEmpty) {
      _itemScrollController.scrollTo(
          index: 0, duration: kThemeAnimationDuration);
    }
  }

  _scrollToSeqNo(int seqNo, {bool ignoreScrollToFirst = false}) async {
    int scrollToIndex =
        controller.messages.indexWhere((e) => e.contentId == seqNo);

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
