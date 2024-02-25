import 'dart:math';

import 'package:flutter/material.dart';
import 'package:messaging_core/app/component/radio_button_widget.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/widgets/image_widget.dart';
import 'package:messaging_core/app/widgets/no_profile_image.dart';
import 'package:messaging_core/app/widgets/text_widget.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';

class RowUserProfileWidget extends StatefulWidget {
  final CategoryUser user;
  final bool isSelected;
  final bool isMultiSelect;
  final bool hasRadioButton;
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RowUserProfileWidget({
    Key? key,
    required this.user,
    this.onTap,
    this.onLongPress,
    this.isExpanded = false,
    this.isSelected = false,
    this.isMultiSelect = false,
    this.hasRadioButton = false,
  }) : super(key: key);

  @override
  State<RowUserProfileWidget> createState() => _RowUserProfileWidgetState();
}

class _RowUserProfileWidgetState extends State<RowUserProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(curve: Curves.easeInOut, parent: _animationController),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RowUserProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      startAnimation();
    }
  }

  void startAnimation() {
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? const Color(0xffEAF2FD)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                widget.user.avatar == null
                    ? const NoProfileImage()
                    : ImageWidget(
                        imageUrl: widget.user.avatar!,
                        height: 40,
                        width: 40,
                        boxShape: BoxShape.circle,
                      ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: TextWidget(
                                    widget.user.username ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.subtitle5.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Visibility(
                  visible: widget.hasRadioButton,
                  child: widget.isMultiSelect
                      ? Checkbox(
                          value: widget.isSelected,
                          checkColor: Colors.blue,
                          fillColor: MaterialStateProperty.resolveWith(
                            (Set states) {
                              return Colors.white;
                            },
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(color: Colors.grey),
                          ),
                          onChanged: null,
                        )
                      : RadioButtonWidget(isSelected: widget.isSelected),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
