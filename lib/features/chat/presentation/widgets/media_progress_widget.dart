import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/core/services/media_handler/media_handler.dart';
import 'package:messaging_core/core/services/media_handler/media_progress_data.dart';

class MediaProgressWidget<C extends MediaHandler> extends StatelessWidget {
  final String contentId;
  final C handler;
  final VoidCallback onCancel;
  final Color? backgroundColor;

  const MediaProgressWidget({
    Key? key,
    required this.contentId,
    required this.handler,
    required this.onCancel,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = 0;
    return StreamBuilder<MediaProgressData>(
      stream: handler.progressController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.contentId == contentId) {
          progress = snapshot.data!.count / snapshot.data!.total;
        }
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                color: AppColors.primary1,
                strokeWidth: 2,
              ),
              IconWidget(
                icon: Icons.close,
                iconColor: AppColors.primary1,
                onPressed: () {
                  onCancel.call();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
