import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/id_to_emojis.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/message_status_widget.dart';

class TimeAndReactionWidget extends StatelessWidget {
  const TimeAndReactionWidget({
    super.key,
    required this.content,
    required this.isMine,
  });

  final ContentModel content;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: Stack(
                children: [
                  Text(
                    IdToEmoji().emojiList[1]!,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      IdToEmoji().emojiList[2]!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        Text(
          content.createdAt.toString().hourAmFromDate(),
          style: const TextStyle(
            fontSize: 6,
            fontWeight: FontWeight.w600,
            color: Color(0xFF828FBB),
          ),
        ),
        const SizedBox(width: 5),
        isMine && content.contentType != ContentTypeEnum.localDeleted
            ? MessageStatusWidget(
                content: content,
              )
            : Container(),
      ],
    );
  }
}
