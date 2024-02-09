import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImagePage extends StatefulWidget {
  final String tag;
  final String imageUrl;

  const FullScreenImagePage({
    Key? key,
    required this.tag,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  PhotoViewControllerBase<PhotoViewControllerValue> controller =
      PhotoViewController();
  bool showOptions = true;

  void _changeShowOptionState(bool state) {
    setState(() {
      showOptions = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                // _changeShowOptionState(!showOptions);
              },
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  widget.imageUrl,
                ),
                basePosition: Alignment.center,
                enableRotation: false,
                maxScale: 1.0,
                minScale: PhotoViewComputedScale.contained,
                controller: controller,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.imageUrl,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: showOptions ? 90 : 0,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      size: 16,
                      padding: 16,
                      boxFit: BoxFit.fill,
                      iconColor: Colors.white,
                      icon: Assets.arrowLeftIcon,
                    ),
                    const Spacer(),
                    IconWidget(
                      onPressed: () {
                        saveImageInGallery(
                            widget.imageUrl, widget.tag, context);
                      },
                      size: 20,
                      padding: 16,
                      boxFit: BoxFit.fill,
                      iconColor: Colors.white,
                      icon: Icons.save_alt,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
