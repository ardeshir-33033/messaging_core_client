import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';

class MessageStatusWidget extends StatelessWidget {
  final ContentModel content;
  // final int lastReceived;
  // final int lastSeen;

  const MessageStatusWidget({
    Key? key,
    required this.content,
    // required this.lastReceived,
    // required this.lastSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contentStatus = content.status;

    IconData icon = Icons.circle;
    Color color = Colors.grey;
    if (contentStatus == MessageStatus.pending) {
      icon = Icons.schedule;
      color = Colors.grey;
    } else if (contentStatus == MessageStatus.sending) {
      icon = Icons.schedule;
      color = Colors.grey;
    } else if (contentStatus == MessageStatus.fail ||
        contentStatus == MessageStatus.pendingFail) {
      icon = Icons.error_outline;
      color = Colors.red;
    } else if (contentStatus == MessageStatus.sent) {
      if (content.readAt != null) {
        icon = Icons.done_all;
        color = Colors.green;
      } else {
        icon = Icons.done;
      }

      // if (content.sequenceNumber <= lastSeen) {
      //   color = AppColors.primary1;
      // } else {
      // color = Colors.grey;
      // }
    }

    return contentStatus == MessageStatus.fail
        ? const SizedBox()
        : Icon(
            icon,
            size: 10,
            color: color,
            key: Key(
              "${content.contentId}-${content.status.name}",
            ),
          );
  }
}
