import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/services/media_handler/file_handler.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/media_progress_widget.dart';
import 'package:open_filex/open_filex.dart';

class FileContentWidget extends StatefulWidget {
  final bool isUploading;
  final ContentModel contentModel;

  const FileContentWidget({
    Key? key,
    required this.isUploading,
    required this.contentModel,
  }) : super(key: key);

  @override
  State<FileContentWidget> createState() => _FileContentWidgetState();
}

class _FileContentWidgetState extends State<FileContentWidget> {
  bool _isDownloading = false;
  File? _cachedFile;

  // String get fileFullPath =>
  //     "${widget.contentModel.contentId}.${widget.payload.extension}";

  Future<void> openFile() async {
    OpenFilex.open(_cachedFile!.path).then((result) {
      if (result.type != ResultType.done) {
        Fluttertoast.showToast(msg: tr(context).cannotOpenFile);
      }
    });
  }

  void changeLoadingState(bool state) {
    setState(() {
      _isDownloading = state;
    });
  }

  Future<void> downloadFile() async {
    changeLoadingState(true);
    await FileHandler().downloadMedia(
      widget.contentModel.filePath!,
      widget.contentModel.contentId.toString(),
      FileType.file,
      getFileExtension(widget.contentModel.filePath!),
    );
    await checkCachingFile();
    changeLoadingState(false);
  }

  Future<void> checkCachingFile() async {
    getCachedFile(
            "${widget.contentModel.contentId}.${getFileExtension(widget.contentModel.filePath!)}",
            FileType.file)
        .then((value) {
      _cachedFile = value;
      if (value != null) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    checkCachingFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            openFile();
          },
          child: Container(
            width: 32,
            height: 32,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff050D18).withOpacity(0.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Builder(
                  builder: (context) {
                    if (_isDownloading || widget.isUploading) {
                      return MediaProgressWidget<FileHandler>(
                        contentId: widget.contentModel.contentId.toString(),
                        handler: FileHandler(),
                        onCancel: () {
                          if (_isDownloading) {
                            // cancelToken?.cancel();
                            changeLoadingState(false);
                          } else {
                            // FileHandler()
                            //     .cancelUploadingContent(widget.contentModel);
                          }
                        },
                      );
                    }

                    if (_cachedFile != null) {
                      return const IconWidget(
                        icon: Icons.file_copy_outlined,
                        width: 32,
                        height: 32,
                        boxShape: BoxShape.circle,
                      );
                    }
                    if (widget.contentModel.status != MessageStatus.sent) {
                      return const CircularProgressIndicator();
                    }
                    return IconWidget(
                      icon: Icons.arrow_downward_rounded,
                      iconColor: AppColors.primary1,
                      onPressed: () {
                        downloadFile();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                widget.contentModel.messageText == ""
                    ? widget.contentModel.filePath!
                        .substring(widget.contentModel.filePath!.length - 7)
                    : widget.contentModel.messageText,
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.overline
                    .copyWith(color: const Color(0xff272B38), fontSize: 12),
              ),
              // TextWidget(
              //   widget.payload.size,
              //   style: AppTextStyles.overline
              //       .copyWith(color: const Color(0xff687296), fontSize: 10),
              // )
            ],
          ),
        )
      ],
    );
  }
}
