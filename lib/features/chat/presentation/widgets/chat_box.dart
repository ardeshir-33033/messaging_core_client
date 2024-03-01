import 'dart:io';
import 'package:messaging_core/core/enums/file_type.dart';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/component/base_bottom_sheets.dart';
import 'package:messaging_core/app/component/dialog_box.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/media_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/text_utils.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_profile_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/text_content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/chat_box_content.dart';
import 'package:messaging_core/features/chat/presentation/widgets/content_options_overlay_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/message_status_widget.dart';
import 'package:messaging_core/features/chat/presentation/widgets/sheets/forward_content_sheet.dart';
import 'package:messaging_core/features/chat/presentation/widgets/tag_widget.dart';
import 'package:messaging_core/locator.dart';

class ChatBox extends StatefulWidget {
  final ContentModel content;
  final bool isGroup;
  final bool isFirstSenderContent;
  final bool isLastSenderContent;
  final Function() onReplyTap;
  final OverlayController overlayController;
  final ContactProfile? opponentProfile;
  final int index;
  final Function(Offset globalPosition, Widget? target) onTap;

  const ChatBox({
    Key? key,
    required this.content,
    required this.isGroup,
    required this.onReplyTap,
    required this.isFirstSenderContent,
    required this.isLastSenderContent,
    required this.overlayController,
    required this.onTap,
    required this.index,
    this.opponentProfile,
  }) : super(key: key);

  @override
  State<ChatBox> createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  final ChatController controller = locator<ChatController>();

  late String userId;
  late bool isMine;
  bool _isDownloadedImage = false;
  Offset? position;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
      position = box.localToGlobal(Offset.zero);
      setState(() {});
    });
    // userId = getIt<UserCertStorage>().userId ?? "";
    isMine = mine(widget.content);
    updateIsDownloadImage();
  }

  final GlobalKey key = GlobalKey();

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
      onEdit: _onEdit,
      onStar: _onStar,

      // onSaveImage: _onSaveImage,
      isMine: isMine,
      offset: position,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onLongPress: () {
          if (widget.content.contentType == ContentTypeEnum.localDeleted) {
            return;
          }
          dismissKeyboard();
          widget.overlayController.openOverlay(
            tag: widget.content.contentId.toString(),
          );
        },
        onTap: () {
          // widget.onTap(position!, widget);
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
                0, widget.isFirstSenderContent ? 12 : 4, 0, 0),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: isMine == false &&
                              widget.isLastSenderContent &&
                              widget.isGroup,
                          replacement: SizedBox(
                            width: (isMine || widget.isGroup == false) ? 0 : 32,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child:
                                // _noProfileImage(
                                //                         context,
                                //                         widget.content.senderId,
                                //                         widget.content.sender?.name ?? '',
                                //                         35)
                                ImageWidget(
                              imageUrl: senderProfile ?? "",
                              height: 35,
                              width: 35,
                              boxShape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isSenderNameNeededOnMessage(widget.content))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  widget.content.sender!.username!,
                                  key: Key(widget.content.senderId.toString()),
                                  style: AppTextStyles.body4.copyWith(
                                      fontSize: 12,
                                      color: widget.content.senderId
                                          .colorFromId()),
                                ),
                              ),
                            Container(
                              key: key,
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
                                borderRadius: widget.isLastSenderContent
                                    ? BorderRadius.only(
                                        topRight: const Radius.circular(16),
                                        bottomLeft: isMine
                                            ? const Radius.circular(16)
                                            : const Radius.circular(4),
                                        bottomRight: isMine
                                            ? const Radius.circular(4)
                                            : const Radius.circular(16),
                                        topLeft: const Radius.circular(16))
                                    : BorderRadius.circular(16),
                                color: isMine
                                    ? AppColors.primary1.withOpacity(0.5)
                                    : const Color(0xFFCECECE),
                              ),
                              child: Column(
                                crossAxisAlignment: isMine
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (widget.content.replied != null)
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
                                                        widget.content.replied!
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
                                                        widget.content.replied!,
                                                      ),
                                                      style: AppTextStyles.body4.copyWith(
                                                          color: widget.isGroup
                                                              ? getSenderColor(
                                                                  widget
                                                                      .content)
                                                              : AppColors
                                                                      .primary3[
                                                                  800]),
                                                    ),
                                                    Text(
                                                      widget.content.replied!
                                                                  .contentPayload !=
                                                              null
                                                          ? widget
                                                              .content
                                                              .replied!
                                                              .contentPayload!
                                                              .shortDisplayName()
                                                          : "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: AppTextStyles
                                                          .overline2
                                                          .copyWith(
                                                              color: AppColors
                                                                      .primary3[
                                                                  600]),
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
                                  ChatBoxContent(
                                    contentModel: widget.content,
                                    keyId: Key(
                                        widget.content.contentId.toString()),
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
                                      isMine &&
                                              widget.content.contentType !=
                                                  ContentTypeEnum.localDeleted
                                          ? MessageStatusWidget(
                                              content: widget.content,
                                              // lastReceived: currentChannelProvider
                                              //     .lastReceived,
                                              // lastSeen:
                                              //     currentChannelProvider.lastSeen,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    return AppGlobalData.userId == content.senderId;
  }

  bool isSenderNameNeededOnMessage(ContentModel content) {
    return widget.isGroup &&
        !isMine &&
        (widget.isFirstSenderContent ||
            content.contentType == ContentTypeEnum.unsupported);
  }

  String getSenderName(ContentModel content) {
    String senderName = "";
    if (isMine) {
      senderName = AppGlobalData.userName;
    } else {
      if (controller.currentChat!.isGroup()) {
        senderName = content.sender?.name ?? "";
      } else {
        senderName = controller.currentChat!.name ?? "";
      }
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

  String get senderProfile {
    return widget.content.sender?.avatar ?? "";
    // return currentChannelProvider.members[widget.content.senderId]?.profile ??
    //     currentChannelProvider.removedMembers[widget.content.senderId]?.profile;
  }

  Future<void> _onCopy() async {
    copyToClipboard(widget.content.messageText);
    _hideBox();
  }

  Future<void> _onReply() async {
    controller.repliedContent = widget.content;
    controller.update(["sendMessage"]);
    _hideBox();
  }

  Future<void> _onReport() async {
    _hideBox();
    DialogBoxes(
        title: tr(context).reportQuestion,
        icon: Assets.report,
        showIcon: true,
        descriptionWidget: TagWidget(
          text: tr(context).reportHint,
          icon: Icons.shield,
          iconColor: const Color(0xffEB5757),
          backgroundColor: const Color(0xEB5757).withOpacity(0.08),
        ),
        mainTaskText: tr(context).yesReport,
        mainTask: () {
          Fluttertoast.showToast(
              msg: 'We review your report as soon as possible');
          Navigator.pop(context);
        },
        otherTaskText: tr(context).noReport,
        otherTask: () {
          Navigator.pop(context);
        }).showMyDialog();
  }

  _onEdit() {
    _hideBox();
    TextEditingController textController = TextEditingController();
    controller.editingContent = widget.content;
    textController.text = widget.content.messageText;
    DialogBoxes(
            dismissible: false,
            customView: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  tr(context).editMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body3.copyWith(
                    color: const Color(0xff050D18),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: TextField(
                      maxLines: 7,
                      minLines: 1,
                      textAlignVertical: TextAlignVertical.top,
                      controller: textController,
                      textDirection: directionOf(textController.text),
                      style: AppTextStyles.body2,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: 10.horizontal,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFFD6D6D6))))),
                ),
              ],
            ),
            mainTaskText: tr(context).edit,
            mainTask: () {
              controller.editTextMessage(
                  textController.text, widget.content.contentId, widget.index);
              Navigator.pop(context);
            },
            otherTask: () {
              controller.editingContent = null;
              Navigator.pop(context);
            },
            otherTaskText: tr(context).close)
        .showMyDialog();
  }

  Future<void> _onDeleteUnsent() async {
    _hideBox();
    // CurrentChannelContentProvider currentChannelContentProvider =
    //     getIt<CurrentChannelContentProvider>();
    // currentChannelContentProvider.deleteUnsentMessage(widget.content);
  }

  Future<void> _onStar() async {
    _hideBox();
    FileModel? fileModel;
    if (widget.content.filePath != null) {
      File file = await MediaHandler().fileFromUrl(widget.content.filePath!);

      fileModel = FileModel(
          formData: await File(file.path).readAsBytes(),
          filePath: file.path,
          fileName: widget.content.messageText);
    }
    bool result = await controller.starMessage(
        widget.content.messageText,
        AppGlobalData.userId,
        widget.content.contentType,
        widget.content.filePath != null ? fileModel : null,
        widget.content.contentPayload);
    if (result) {
      Fluttertoast.showToast(msg: "Successful");
    }
  }

  Future<void> _onDeleteLocal() async {
    _hideBox();
    bool response = await controller.deleteMessage(widget.content.contentId);
    if (response) Fluttertoast.showToast(msg: "Message is deleted");
  }

  Future<void> _onResend() async {
    _hideBox();
    // context.read<CurrentChannelContentProvider>().resendContent(widget.content);
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

  // Future<void> _onSaveImage() async {
  //   _hideBox();
  //   saveImageInGallery(getImageCacheKey(widget.content.contentId), context);
  // }

  void _hideBox() {
    widget.overlayController.dismissOverlay();
  }

  updateIsDownloadImage() async {
    if (_isDownloadedImage) return;
    _isDownloadedImage = widget.content.contentType == ContentTypeEnum.image &&
        await isImageCached(
            getImageCacheKey(widget.content.contentId.toString()));
    if (_isDownloadedImage) {
      if (context.mounted) setState(() {});
    }
  }

  Future<void> _onSaveFile() async {
    _hideBox();
    // FileContentPayloadModel payload =
    //     widget.content.contentPayload as FileContentPayloadModel;
    // final file = await getCachedFile(
    //     "${widget.content.contentId}.${payload.extension}", FileType.file);
    // if (file != null) {
    //   FileHelper.saveFileInDownloads(payload.name, file);
    // } else {
    //   Fluttertoast.showToast(msg: "first Download the file to save it.");
    // }
  }
}
