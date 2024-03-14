import 'package:flutter/material.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/id_to_emojis.dart';
import 'package:messaging_core/features/chat/data/models/reaction_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/message_status_widget.dart';

class TimeAndReactionWidget extends StatefulWidget {
  const TimeAndReactionWidget({
    super.key,
    required this.content,
    required this.isMine,
  });

  final ContentModel content;
  final bool isMine;

  @override
  State<TimeAndReactionWidget> createState() => _TimeAndReactionWidgetState();
}

class _TimeAndReactionWidgetState extends State<TimeAndReactionWidget> {
  final TextStyle emojiStyle = const TextStyle(fontSize: 12);

  List<ReactionModel> reactions = [
    //   ReactionModel(user: CategoryUser(id: 1, name: "ardi"), emoji: 1),
  ];

  Map<int, int> showingReactions = {};

  @override
  void initState() {
    super.initState();
  }

  fillReactions() {
    // if ((widget.content.reactionModel?.length ?? 0) > 2) {
    reactions = widget.content.reactionModel ?? [];
    showingReactions = {};
    for (var element in reactions) {
      showingReactions.update(element.emoji, (value) => value + 1,
          ifAbsent: () => 1);
    }
    // }else{
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    fillReactions();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isMine)
          Row(
            children: [
              reactionWidget(),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        Text(
          widget.content.createdAt.toString().hourAmFromDate(),
          style: const TextStyle(
            fontSize: 6,
            fontWeight: FontWeight.w600,
            color: Color(0xFF828FBB),
          ),
        ),
        const SizedBox(width: 5),
        widget.isMine &&
                widget.content.contentType != ContentTypeEnum.localDeleted
            ? MessageStatusWidget(
                content: widget.content,
              )
            : Container(),
        if (!widget.isMine)
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              reactionWidget(),
            ],
          ),
      ],
    );
  }

  Widget reactionWidget() {
    return reactions.isNotEmpty
        ? reactions.length > 2
            ? multipleReactions()
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                child: reactions.length == 1 ? oneReaction() : doubleReaction())
        : const SizedBox();
  }

  oneReaction() {
    return Text(
      IdToEmoji().emojiList[reactions.first.emoji]!,
      style: emojiStyle,
    );
  }

  doubleReaction() {
    return Stack(
      children: [
        Text(
          IdToEmoji().emojiList[reactions.first.emoji]!,
          style: emojiStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            IdToEmoji().emojiList[reactions[1].emoji]!,
            style: emojiStyle,
          ),
        ),
      ],
    );
  }

  multipleReactions() {
    return SizedBox(
      height: 20,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: showingReactions.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 3);
          },
          itemBuilder: (context, index) {
            int emoji = showingReactions.keys.elementAt(index);
            int count = showingReactions.values.elementAt(index);
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.5),
              child: Row(
                children: [
                  Text(
                    IdToEmoji().emojiList[emoji]!,
                    style: emojiStyle,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
