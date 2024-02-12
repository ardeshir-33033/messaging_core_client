import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/radio_button_widget.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/user_profile_widget.dart';

class ChannelListItemWidget extends StatelessWidget {
  final ChatParentClass chat;
  final bool isSelected;
  final bool isMultiSelect;
  final bool hasRadioButton;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChannelListItemWidget({
    Key? key,
    required this.chat,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isMultiSelect = false,
    this.hasRadioButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffEAF2FD) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: UserProfileWidget(
                chat: chat,
                size: 40,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Visibility(
              visible: hasRadioButton,
              child: isMultiSelect
                  ? Checkbox(
                      value: isSelected,
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(
                        (Set states) {
                          return AppColors.primary1[450];
                        },
                      ),
                      onChanged: null,
                    )
                  : RadioButtonWidget(isSelected: isSelected),
            )
          ],
        ),
      ),
    );
  }
}
