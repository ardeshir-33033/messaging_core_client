import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messaging_core/app/theme/theme_service.dart';
import 'package:messaging_core/app/widgets/skeleton_widget.dart';

enum ImageType { asset, file, network }

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final ImageType? imageType;
  final BoxShape boxShape;
  final BoxFit? boxFit;
  final double? height;
  final double? width;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool hasTag;
  final Widget? tagWidget;
  final Alignment? tagAlignment;
  final bool hasGradient;
  final Widget? placeHolder;
  final BoxBorder? border;

  const ImageWidget({
    Key? key,
    required this.imageUrl,
    this.imageType,
    this.boxShape = BoxShape.rectangle,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.hasTag = false,
    this.tagWidget,
    this.tagAlignment,
    this.hasGradient = false,
    this.placeHolder,
    this.border,
  }) : super(key: key);

  const ImageWidget.fromAsset({
    Key? key,
    required this.imageUrl,
    this.boxShape = BoxShape.rectangle,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.hasTag = false,
    this.tagWidget,
    this.tagAlignment,
    this.hasGradient = false,
    this.placeHolder,
    this.border,
  })  : imageType = ImageType.asset,
        super(key: key);

  const ImageWidget.fromNetwork({
    Key? key,
    required this.imageUrl,
    this.boxShape = BoxShape.rectangle,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.hasTag = false,
    this.tagWidget,
    this.tagAlignment,
    this.hasGradient = false,
    this.placeHolder,
    this.border,
  })  : imageType = ImageType.network,
        super(key: key);

  const ImageWidget.fromFile({
    Key? key,
    required this.imageUrl,
    this.boxShape = BoxShape.rectangle,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
    this.borderRadius,
    this.onTap,
    this.hasTag = false,
    this.tagWidget,
    this.tagAlignment,
    this.hasGradient = false,
    this.placeHolder,
    this.border,
  })  : imageType = ImageType.file,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: boxShape == BoxShape.circle
                      ? null
                      : BorderRadius.circular(borderRadius ?? 0),
                  shape: boxShape,
                  border: border,
                ),
                child: Builder(
                  builder: (context) {
                    switch (type) {
                      case ImageType.asset:
                        if (imageUrl.isEmpty) {
                          return _errorWidget(context);
                        }
                        if (_isSvg(imageUrl)) {
                          return SvgPicture.asset(
                            imageUrl,
                            fit: boxFit ?? BoxFit.contain,
                            width: width,
                            height: height,
                          );
                        }
                        return Image.asset(
                          imageUrl,
                          fit: boxFit,
                          width: width,
                          height: height,
                          errorBuilder: (context, error, stackTrace) =>
                              _errorWidget(context),
                        );
                      case ImageType.file:
                        if (imageUrl.isEmpty) {
                          return _errorWidget(context);
                        }
                        return Image.file(
                          File(imageUrl),
                          fit: boxFit,
                          width: width,
                          height: height,
                          errorBuilder: (context, error, stackTrace) =>
                              _errorWidget(context),
                        );
                      case ImageType.network:
                        if (imageUrl.isEmpty) {
                          return _errorWidget(context);
                        }
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: boxFit,
                          errorWidget: (context, url, error) =>
                              _errorWidget(context),
                          height: height,
                          width: width,
                          placeholder: (context, url) =>
                              boxShape == BoxShape.circle
                                  ? SkeletonWidget.circular(
                                      width: width ?? 50,
                                      height: height ?? 50,
                                    )
                                  : SkeletonWidget.rectangular(
                                      width: width ?? 50,
                                      height: height ?? 50,
                                    ),
                        );
                    }
                  },
                ),
              ),
            ),
            if (hasTag && tagWidget != null)
              Align(
                alignment: tagAlignment ?? Alignment.bottomRight,
                child: tagWidget!,
              )
          ],
        ),
      ),
    );
  }

  bool _isSvg(String imageUrl) {
    if (imageUrl.contains(".svg")) {
      return true;
    }
    return false;
  }

  ImageType get type {
    if (imageType != null) return imageType!;
    if (imageUrl.startsWith("http") || kIsWeb) {
      return ImageType.network;
    } else if (imageUrl.startsWith("assets")) {
      return ImageType.asset;
    }
    return ImageType.file;
  }

  Widget _errorWidget(BuildContext context) {
    return placeHolder ??
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.error,
            color: Color(0xff2F80ED),
          ),
        );
  }
}
