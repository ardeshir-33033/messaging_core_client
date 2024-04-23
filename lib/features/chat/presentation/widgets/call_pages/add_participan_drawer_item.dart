import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';

class AddParticipantDrawerItem extends StatefulWidget {
  AddParticipantDrawerItem(
      {super.key,
      required this.chat,
      required this.isSelected,
      required this.onSelect});
  final ChatParentClass chat;
  bool isSelected;
  final Function(bool) onSelect;

  @override
  State<AddParticipantDrawerItem> createState() =>
      _AddParticipantDrawerItemState();
}

class _AddParticipantDrawerItemState extends State<AddParticipantDrawerItem> {
  @override
  Widget build(BuildContext context) {
    String? subtitle = _subtitleText(context);

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: UserProfileWidget(
                chat: widget.chat,
                size: 50,
                isGroup: widget.chat.isGroup(),
                titleStyle: AppTextStyles.subtitle5,
                subTitle: subtitle == "" ? tr(context).noMessage : subtitle,
                subtitleStyle: AppTextStyles.description2.copyWith(
                  color: AppColors.primaryBlack,
                )),
          ),
          const SizedBox(
            width: 16,
          ),
          Checkbox(
            value: widget.isSelected,
            onChanged: (val) {
              widget.onSelect(val ?? false);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: const BorderSide(color: Colors.grey),
            ),
            checkColor: Colors.white,
            activeColor: Colors.blue,
          )
        ],
      ),
    );
  }

  String _subtitleText(BuildContext context) {
    if (widget.chat.lastMessage?.contentType == ContentTypeEnum.other) {
      return widget.chat.lastMessage!.contentPayload!.shortDisplayName();
    }

    return widget.chat.lastMessage?.shortDisplayMessage() ?? '';
  }
}
