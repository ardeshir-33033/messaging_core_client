import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_box_content.dart';
import 'package:messaging_core/features/chat/presentation/widgets/content_options_overlay_widget.dart';
import 'package:png/core/component/dialog_box.dart';
import 'package:png/core/statics/analytics_statics.dart';
import 'package:png/core/theme/constants.dart';
import 'package:png/main.dart';
import 'package:png/models/contact_profile_model.dart';
import 'package:png/models/content/content_model.dart';
import 'package:png/models/content/file_content_payload_model.dart';
import 'package:png/models/content/text_content_payload_model.dart';
import 'package:png/models/enum/content_type_enum.dart';
import 'package:png/models/enum/file_type.dart';
import 'package:png/models/enum/message_status.dart';
import 'package:png/services/providers/current_channel_content_provider.dart';
import 'package:png/services/providers/current_channel_provider.dart';
import 'package:png/services/storage/user_cert_storage.dart';
import 'package:png/utils/extensions.dart';
import 'package:png/utils/extensions/context_extensions.dart';
import 'package:png/utils/file_helper.dart';
import 'package:png/utils/util.dart';
import 'package:png/views/pages/conversation_page/bottom_sheets/forward_content_sheet.dart';
import 'package:png/views/pages/conversation_page/widgets/content_options_overlay_widget.dart';
import 'package:png/views/theme/app_colors.dart';
import 'package:png/views/theme/app_text_styles.dart';
import 'package:png/views/widgets/bottom_sheets/base_bottom_sheets.dart';
import 'package:png/views/widgets/chat/chat_box_content.dart';
import 'package:png/views/widgets/chat/general_content_widget.dart';
import 'package:png/views/widgets/chat/message_status_widget.dart';
import 'package:png/views/widgets/chat/sms_content_widget.dart';
import 'package:png/views/widgets/icon_widget.dart';
import 'package:png/views/widgets/image_widget.dart';
import 'package:png/views/widgets/overlay_widget.dart';
import 'package:png/views/widgets/tag_widget.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatefulWidget {
  final ContentModel content;
  final bool isGroup;
  final bool isFirstSenderContent;
  final Function() onReplyTap;
  final OverlayController overlayController;
  final ContactProfile? opponentProfile;

  const ChatBox({
    Key? key,
    required this.content,
    required this.isGroup,
    required this.onReplyTap,
    required this.isFirstSenderContent,
    required this.overlayController,
    this.opponentProfile,
  }) : super(key: key);

  @override
  State<ChatBox> createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  late String userId;
  late bool isMine;
  bool _isDownloadedImage = false;

  @override
  void didUpdateWidget(covariant ChatBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content.contentId != widget.content.contentId) {
      setState(() {
        isMine = mine(widget.content);
        updateIsDownloadImage();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // userId = getIt<UserCertStorage>().userId ?? "";
    isMine = mine(widget.content);
    updateIsDownloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return ContentOptionsOverlayWidget(
      overlayController: widget.overlayController,
      contentId: widget.content.contentId.toString(),
      messageStatus: widget.content.status,
      contentType: widget.content.contentType,
      onResend: _onResend,
      onSaveFile: _onSaveFile,
      onCopy: _onCopy,
      onDeleteUnsent: _onDeleteUnsent,
      onDeleteLocal: _onDeleteLocal,
      onForward: _onForward,
      onReply: _onReply,
      onReport: _onReport,
      onSaveImage: _onSaveImage,
      isMine: isMine,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onLongPress: () {
          if (widget.content.contentType == ContentTypeEnum.localDeleted) {
            return;
          }
          dismissKeyboard();
          widget.overlayController
              .openOverlay(tag: widget.content.contentId.toString());
        },
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Builder(builder: (context) {
          if (widget.content.contentType.isGeneralContent) {
            // return GeneralContentWidget(
            //   content: widget.content,
            //   isMine: isMine,
            //   opponentProfileDisplayName:
            //       widget.opponentProfile?.displayName ?? '',
            //   currentProfileDisplayName:
            //       // getIt.call<UserCertStorage>().user?.displayName ??
            //       '',
            // );
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(
                12, widget.isFirstSenderContent ? 12 : 4, 12, 0),
            child: Row(
              textDirection: isMine ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.content.status == MessageStatus.fail) ...[
                  const IconWidget(
                    icon: Icons.error,
                    iconColor: Colors.red,
                    size: 14,
                    boxFit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: context.widthPercentage(70),
                    ),
                    child: Row(
                      textDirection:
                          isMine ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: isMine == false &&
                              widget.isFirstSenderContent &&
                              widget.isGroup,
                          replacement: SizedBox(
                            width: (isMine || widget.isGroup == false) ? 0 : 32,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ImageWidget(
                              imageUrl: senderProfile?.image ?? "",
                              height: 24,
                              width: 24,
                              boxShape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            maxWidth: context.widthPercentage(80),
                          ),
                          decoration: BoxDecoration(
                            border: widget.content.contentType ==
                                    ContentTypeEnum.unsupported
                                ? Border.all(
                                    width: 0.5,
                                    color: const Color(0xff2F80ED),
                                  )
                                : null,
                            borderRadius: widget.isFirstSenderContent
                                ? BorderRadius.only(
                                    topRight: isMine
                                        ? const Radius.circular(4)
                                        : const Radius.circular(16),
                                    bottomLeft: const Radius.circular(16),
                                    bottomRight: const Radius.circular(16),
                                    topLeft: isMine
                                        ? const Radius.circular(16)
                                        : const Radius.circular(4),
                                  )
                                : BorderRadius.circular(16),
                            color: isMine
                                ? AppColors.primary1[300]
                                : AppColors.primary2[100],
                          ),
                          child: Column(
                            crossAxisAlignment: isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (widget.content.repliedTo != null)
                                InkWell(
                                  onTap: widget.onReplyTap,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, bottom: 14),
                                    child: SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // const SizedBox(width: 16),
                                          VerticalDivider(
                                            color: widget.isGroup
                                                ? AppColors.getColorByHash(
                                                    widget.content.repliedTo!
                                                        .senderId.hashCode)
                                                : AppColors.primary1[450],
                                            width: 2,
                                            thickness: 1,
                                          ),
                                          const SizedBox(width: 7),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getSenderName(
                                                    widget.content.repliedTo!,
                                                  ),
                                                  style: AppTextStyles.body4
                                                      .copyWith(
                                                          color: widget.isGroup
                                                              ? getSenderColor(
                                                                  widget
                                                                      .content)
                                                              : AppColors
                                                                      .primary3[
                                                                  800]),
                                                ),
                                                Text(
                                                  widget.content.repliedTo!
                                                      .contentPayload
                                                      .shortDisplayName(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: AppTextStyles.overline2
                                                      .copyWith(
                                                          color: AppColors
                                                              .primary3[600]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.content.isForwarded)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: Text("forwarded",
                                      style: AppTextStyles.body4.copyWith(
                                        color: AppColors.primary1,
                                      )),
                                ),
                              if (isSenderNameNeededOnMessage(widget.content))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    getSenderName(widget.content),
                                    key: Key(widget.content.senderId),
                                    style: AppTextStyles.body4.copyWith(
                                        color: getSenderColor(widget.content)),
                                  ),
                                ),
                              ChatBoxContent(
                                contentModel: widget.content,
                                keyId: Key(widget.content.contentId.toString()),
                                isMine: isMine,
                                senderName: getSenderName(widget.content),
                                opponentProfile: widget.opponentProfile,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.content.createdAt
                                        .toString()
                                        .hourAmFromDate(),
                                    style: const TextStyle(
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF828FBB),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  // isMine &&
                                  //         widget.content.contentType !=
                                  //             ContentTypeEnum.localDeleted
                                  //     ? MessageStatusWidget(
                                  //         content: widget.content,
                                  //         lastReceived: currentChannelProvider
                                  //             .lastReceived,
                                  //         lastSeen:
                                  //             currentChannelProvider.lastSeen,
                                  //       )
                                  //     : Container(),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool mine(ContentModel content) {
    return userId == content.senderId;
  }

  bool isSenderNameNeededOnMessage(ContentModel content) {
    return widget.isGroup &&
        !isMine &&
        (widget.isFirstSenderContent ||
            content.contentType == ContentTypeEnum.unsupported);
  }

  String getSenderName(ContentModel content) {
    String senderName = "";

    if (currentChannelProvider.members.containsKey(content.senderId)) {
      senderName =
          currentChannelProvider.members[content.senderId]!.profile.displayName;
    } else {
      senderName = currentChannelProvider
              .removedMembers[content.senderId]?.profile.displayName ??
          content.senderId.toHex().midEllipsis(head: 4, tail: 4);
    }
    if (content.contentType == ContentTypeEnum.unsupported) {
      return '${tr(context).unsupportedContentFrom} $senderName';
    } else {
      return senderName;
    }
  }

  Color getSenderColor(ContentModel content) {
    if (content.contentType == ContentTypeEnum.unsupported) {
      return const Color(0xff2F80ED);
    } else {
      return AppColors.getColorByHash(content.senderId.hashCode);
    }
  }

  ContactProfile? get senderProfile {
    return currentChannelProvider.members[widget.content.senderId]?.profile ??
        currentChannelProvider.removedMembers[widget.content.senderId]?.profile;
  }

  Future<void> _onCopy() async {
    copyToClipboard(
        (widget.content.contentPayload as TextContentPayloadModel).text);
    _hideBox();
  }

  Future<void> _onReply() async {
    _hideBox();
    currentChannelProvider.repliedContent = widget.content;
    currentChannelProvider.notifyListeners();
  }

  Future<void> _onReport() async {
    _hideBox();
    DialogBoxes(
        title: tr(context).reportQuestion,
        icon: Assets.reportIcon,
        showIcon: true,
        descriptionWidget: TagWidget(
          text: tr(context).reportHint,
          icon: Assets.shieldIcon,
          iconColor: Color(0xffEB5757),
          backgroundColor: Color(0xEB5757).withOpacity(0.08),
        ),
        mainTaskText: tr(context).yesReport,
        mainTask: () {
          AnalyticsStatics().setAnalyticLog(
            "reportMessage",
            {
              "contentId": widget.content.contentId,
              "channelId": widget.content.channelId,
              "sequence": widget.content.sequenceNumber,
              "time": DateTime.now().toString()
            },
          );
          Fluttertoast.showToast(
              msg: 'We review your report as soon as possible');
          Navigator.pop(context);
        },
        otherTaskText: tr(context).noReport,
        otherTask: () {
          Navigator.pop(context);
        }).showMyDialog();
  }

  Future<void> _onDeleteUnsent() async {
    _hideBox();
    CurrentChannelContentProvider currentChannelContentProvider =
        getIt<CurrentChannelContentProvider>();
    currentChannelContentProvider.deleteUnsentMessage(widget.content);
  }

  Future<void> _onDeleteLocal() async {
    _hideBox();
    CurrentChannelContentProvider currentChannelContentProvider =
        getIt<CurrentChannelContentProvider>();
    currentChannelContentProvider.localDeleteSentMessage(widget.content);
  }

  Future<void> _onResend() async {
    _hideBox();
    context.read<CurrentChannelContentProvider>().resendContent(widget.content);
  }

  Future<void> _onForward() async {
    _hideBox();
    CustomBottomSheet.showSimpleSheet(
      context,
      (context) => ForwardContentSheet(
        contentModel: widget.content,
      ),
    );
  }

  Future<void> _onSaveImage() async {
    _hideBox();
    saveImageInGallery(getImageCacheKey(widget.content.contentId), context);
  }

  void _hideBox() {
    widget.overlayController.dismissOverlay();
  }

  updateIsDownloadImage() async {
    if (_isDownloadedImage) return;
    _isDownloadedImage = widget.content.contentType == ContentTypeEnum.image &&
        await isImageCached(getImageCacheKey(widget.content.contentId));
    if (_isDownloadedImage) {
      if (context.mounted) setState(() {});
    }
  }

  Future<void> _onSaveFile() async {
    _hideBox();
    FileContentPayloadModel payload =
        widget.content.contentPayload as FileContentPayloadModel;
    final file = await getCachedFile(
        "${widget.content.contentId}.${payload.extension}", FileType.file);
    if (file != null) {
      FileHelper.saveFileInDownloads(payload.name, file);
    } else {
      Fluttertoast.showToast(msg: "first Download the file to save it.");
    }
  }
}
