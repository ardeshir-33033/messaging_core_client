import 'package:flutter/material.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:video_player/video_player.dart';

class VideoContentWidget extends StatefulWidget {
  const VideoContentWidget({super.key, required this.contentModel});

  final ContentModel contentModel;

  @override
  State<VideoContentWidget> createState() => _VideoContentWidgetState();
}

class _VideoContentWidgetState extends State<VideoContentWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.contentModel.filePath!))
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VideoPlayerScreen(
                  filePath: widget.contentModel.filePath!,
                );
              }));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                const IconWidget(
                  icon: Icons.play_arrow,
                  iconColor: Colors.white,
                  size: 50,
                )
              ],
            ),
          )
        : const SizedBox(
            height: 100,
            width: 100,
          );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.filePath});

  final String filePath;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late bool _isPlaying = false;
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
      });

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: controller.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            _isPlaying ? controller.pause() : controller.play();
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          setState(() {
                            controller.pause();
                            controller.seekTo(const Duration(seconds: 0));
                            _isPlaying = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: controller.value.position.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        controller.seekTo(Duration(seconds: value.toInt()));
                      });
                    },
                    min: 0,
                    max: controller.value.duration.inSeconds.toDouble(),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
