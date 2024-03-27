import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/pages/full_screen_image_page.dart';
import 'package:messaging_core/features/chat/presentation/widgets/text_content_widget.dart';
import 'package:messaging_core/locator.dart';

import 'chat_page_widgets/time_and_reaction_widget.dart';

class ImageContentWidget extends StatefulWidget {
  final ContentModel contentModel;
  final String originalUrl;
  final double borderRadius;
  final double iconSize;
  final int? imageWidth;
  final int? imageHeight;
  final bool showCaption;

  const ImageContentWidget({
    required this.originalUrl,
    required this.contentModel,
    this.borderRadius = 10,
    this.iconSize = 30,
    this.imageWidth,
    this.imageHeight,
    this.showCaption = true,
    super.key,
  });

  @override
  State<ImageContentWidget> createState() => _ImageContentWidgetState();
}

class _ImageContentWidgetState extends State<ImageContentWidget> {
  double get imageAspectRatio {
    if ((widget.imageWidth ?? 0) == 0 || (widget.imageHeight ?? 0) == 0) {
      return 1.0;
    }
    return widget.imageWidth!.toDouble() / widget.imageHeight!;
  }

  bool get isImageFile {
    if (widget.originalUrl.startsWith("http") ||
        widget.originalUrl.startsWith("assets")) {
      return false;
    }
    return true;
  }

  final Navigation navigation = locator<Navigation>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 400,
              maxWidth: 200,
              minWidth: 100,
              minHeight: 100,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        navigation.push(
                          FullScreenImagePage(
                            tag: widget.contentModel.contentId.toString(),
                            imageUrl: widget.originalUrl,
                          ),
                        );
                      },
                      child: Hero(
                        tag: widget.contentModel.contentId,
                        child: AspectRatio(
                          aspectRatio: imageAspectRatio,
                          child: isImageFile
                              ? Image.file(File(widget.originalUrl))
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: imageWidth,
                                  height: imageHeight,
                                  imageUrl: widget.originalUrl,
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: widget.originalUrl ?? "",
                                          width: imageWidth,
                                          height: imageHeight,
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            size: widget.iconSize,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.grey.withOpacity(0.4)),
                                          child: CircularProgressIndicator(
                                            value: progress.progress,
                                            color: AppColors.primary1,
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        TimeAndReactionWidget(
          content: widget.contentModel,
          isMine: mine(widget.contentModel),
          showShadow: true,
        ),
        // if (widget.showCaption &&
        //     !widget.contentModel.messageText.isNullOrEmpty())
        //   Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const SizedBox(
        //         height: 8,
        //       ),
        //       Container(
        //         width: imageWidth,
        //         constraints: const BoxConstraints(maxWidth: 200, minWidth: 100),
        //         child: TextContentWidget(
        //           content: widget.contentModel.messageText ?? "",
        //           keyId: Key('${widget.contentModel.contentId}-caption'),
        //         ),
        //       ),
        //     ],
        //   )
      ],
    );
  }

  double? get imageWidth {
    return widget.imageWidth != 0 ? widget.imageWidth?.toDouble() : null;
  }

  double? get imageHeight {
    return widget.imageHeight != 0 ? widget.imageHeight?.toDouble() : null;
  }

  bool mine(ContentModel content) {
    return AppGlobalData.userId == content.senderId;
  }
}
