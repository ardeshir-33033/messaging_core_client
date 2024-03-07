import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/app_text_styles.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/app/widgets/overlay_widget.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/message_status.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/core/utils/utils.dart';

class ContentOptionsOverlayWidget extends StatefulWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onDeleteUnsent;
  final VoidCallback? onDeleteLocal;
  final VoidCallback? onReport;
  final VoidCallback? onReply;
  final VoidCallback? onSaveImage;
  final VoidCallback? onForward;
  final VoidCallback? onResend;
  final VoidCallback? onSaveFile;
  final VoidCallback? onStar;
  final VoidCallback? onShare;
  final VoidCallback? onPin;
  final VoidCallback? onEdit;
  final MessageStatus messageStatus;
  final ContentTypeEnum contentType;
  final String contentId;
  final int? pin;
  final OverlayController overlayController;
  final Widget child;
  final bool isMine;
  final Offset? offset;

  const ContentOptionsOverlayWidget({
    Key? key,
    required this.messageStatus,
    required this.contentType,
    required this.overlayController,
    required this.contentId,
    required this.child,
    this.pin,
    this.onCopy,
    this.onSaveFile,
    this.onDeleteUnsent,
    this.onDeleteLocal,
    this.onReply,
    this.onSaveImage,
    this.onForward,
    this.onResend,
    required this.isMine,
    this.onReport,
    this.onStar,
    this.onPin,
    this.onShare,
    this.onEdit,
    this.offset,
  }) : super(key: key);

  @override
  State<ContentOptionsOverlayWidget> createState() =>
      _ContentOptionsOverlayWidgetState();
}

class _ContentOptionsOverlayWidgetState
    extends State<ContentOptionsOverlayWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _sizeAnimation;
  late AnimationController _sizeAnimationController;
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  List<OptionModel> options = [];
  List<OptionModel> secondOptions = [];

  @override
  void initState() {
    super.initState();
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _sizeAnimationController,
      curve: Curves.ease,
    );
    widget.overlayController.addListener(_overlayListener);
  }

  @override
  void dispose() {
    if (overlayEntry != null && (overlayEntry?.mounted ?? false)) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    widget.overlayController.removeListener(_overlayListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isOverlayOpen
          ? AppColors.primary1.withOpacity(0.2)
          : Colors.transparent,
      child: widget.child,
    );
  }

  void _overlayListener() async {
    if (widget.overlayController.tag == widget.contentId &&
        widget.overlayController.isOverlayOpen) {
      setState(() {
        _showOverlay(context);
      });
    } else {
      if (overlayEntry == null) return;
      if (overlayEntry?.mounted == false) return;
      await _sizeAnimationController.reverse();
      overlayEntry?.remove();
      overlayEntry = null;
      setState(() {});
    }
  }

  void _initialOptionsList() {
    options = [
      OptionModel(
        title: tr(context).reply,
        icon: Assets.reply,
        onTap: widget.onReply,
        visible: true,
      ),
      OptionModel(
        title: tr(context).forward,
        icon: Assets.forward,
        onTap: widget.onForward,
        visible: true,
      ),
      OptionModel(
        title: tr(context).copy,
        icon: Assets.copy,
        onTap: widget.onCopy,
        visible: widget.contentType == ContentTypeEnum.text ||
            widget.contentType == ContentTypeEnum.linkableText,
      ),
      OptionModel(
        title: tr(context).star,
        icon: Assets.star,
        onTap: widget.onStar,
        visible: true,
      ),
      OptionModel(
        title: tr(context).report,
        icon: Assets.report,
        //textColor: AppColors.primaryRed,
        onTap: widget.onReport,
        visible: !(widget.isMine ?? true),
      ),
    ];
    secondOptions = [
      OptionModel(
        title: tr(context).edit,
        icon: Assets.edit,
        onTap: widget.onEdit,
        visible: true,
      ),
      OptionModel(
        title: widget.pin! == 0 ? tr(context).pin : tr(context).unpin,
        icon: Assets.pin,
        onTap: widget.onPin,
        visible: true,
      ),
      OptionModel(
        title: tr(context).share,
        icon: Assets.share,
        onTap: widget.onShare,
        visible: true,
      ),
      OptionModel(
        title: tr(context).delete,
        icon: Assets.trash,
        onTap: widget.onDeleteLocal,
        textColor: AppColors.primaryRed,
        visible: widget.isMine ? true : false,
      ),
    ];
    options.removeWhere((element) => element.visible == false);
    secondOptions.removeWhere((element) => element.visible == false);
    print(secondOptions);
  }

  void _showOverlay(BuildContext context) async {
    _initialOptionsList();
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTapDown: (v) {
                _dismissOverlay();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.primary3.shade100.withOpacity(0.3),
              ),
            ),
            Positioned(
              top: _overlayOffset.dy,
              right: _overlayOffset.dx,
              child: SizeTransition(
                sizeFactor: _sizeAnimation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: SizedBox(
                  width: _overlayWidth,
                  height: _overlayHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Material(
                      elevation: 3,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: options.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: options[index].onTap,
                                    child: SizedBox(
                                      width: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8),
                                        child: Column(
                                          children: [
                                            IconWidget(
                                              icon: options[index].icon,
                                              size: 25,
                                            ),
                                            Text(
                                              options[index].title,
                                              style: AppTextStyles.overline2
                                                  .copyWith(
                                                      fontSize: 11,
                                                      color: options[index]
                                                              .textColor ??
                                                          AppColors
                                                              .primary3[800]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 3),
                            child: Divider(
                              color: Colors.grey[200],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: secondOptions.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index2) {
                                  return InkWell(
                                    onTap: secondOptions[index2].onTap,
                                    child: SizedBox(
                                      width: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8),
                                        child: Column(
                                          children: [
                                            IconWidget(
                                              icon: secondOptions[index2].icon,
                                              size: 25,
                                            ),
                                            Text(
                                              secondOptions[index2].title,
                                              style: AppTextStyles.overline2
                                                  .copyWith(
                                                      color: secondOptions[
                                                                  index2]
                                                              .textColor ??
                                                          AppColors
                                                              .primary3[800]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState?.insert(overlayEntry!);
    _sizeAnimationController.forward();
    dismissKeyboard();
  }

  void _dismissOverlay() {
    widget.overlayController.dismissOverlay();
  }

  bool get _isOverlayOpen {
    return widget.overlayController.isOverlayOpen &&
        widget.overlayController.tag == widget.contentId;
  }

  Offset get _overlayOffset {
    // double dy = widget.offset!.dy;
    // if (context.screenHeight - widget.offset!.dy < 120) {
    //   dy = widget.offset!.dy - 230;
    // }
    double dy = (context.screenHeight - _overlayHeight) / 2;
    double dx = (context.screenWidth - _overlayWidth) / 2;
    return Offset(dx, dy);
  }

  double get _overlayHeight => 150;

  double get _overlayWidth {
    if (secondOptions.length > options.length) {
      return secondOptions.length * 60;
    } else {
      return options.length * 60;
    }
  }
}

class OptionModel {
  final String title;
  final dynamic icon;
  final VoidCallback? onTap;
  final bool visible;
  final Color? textColor;

  OptionModel(
      {required this.title,
      required this.icon,
      required this.onTap,
      this.visible = true,
      this.textColor});
}
