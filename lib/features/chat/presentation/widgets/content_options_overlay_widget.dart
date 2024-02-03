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
  final MessageStatus messageStatus;
  final ContentTypeEnum contentType;
  final String contentId;
  final OverlayController overlayController;
  final Widget child;
  final bool? isMine;

  const ContentOptionsOverlayWidget({
    Key? key,
    required this.messageStatus,
    required this.contentType,
    required this.overlayController,
    required this.contentId,
    required this.child,
    this.onCopy,
    this.onSaveFile,
    this.onDeleteUnsent,
    this.onDeleteLocal,
    this.onReply,
    this.onSaveImage,
    this.onForward,
    this.onResend,
    this.isMine,
    this.onReport,
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
        title: tr(context).resend,
        icon: Icons.refresh,
        onTap: widget.onResend,
        visible: widget.onResend != null &&
            (widget.messageStatus == MessageStatus.fail ||
                widget.messageStatus == MessageStatus.pendingFail),
      ),
      OptionModel(
        title: tr(context).reply,
        icon: Assets.reply,
        onTap: widget.onReply,
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
        title: tr(context).forward,
        icon: Assets.forward,
        onTap: widget.onForward,
        visible: true,
      ),
      OptionModel(
        title: tr(context).report,
        icon: Assets.report,
        //textColor: AppColors.primaryRed,
        onTap: widget.onReport,
        visible: !(widget.isMine ?? true),
      ),
      OptionModel(
        title: tr(context).delete,
        icon: Assets.trash,
        textColor: AppColors.primaryRed,
        onTap: widget.onDeleteLocal,
        visible: widget.onDeleteLocal != null &&
            (widget.messageStatus == MessageStatus.sent),
      ),
    ];
    options.removeWhere((element) => element.visible == false);
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
                        child: Column(
                          children: List.generate(
                            options.length,
                            (index) => Expanded(
                              child: InkWell(
                                onTap: options[index].onTap,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              options[index].title,
                                              style: AppTextStyles.overline2
                                                  .copyWith(
                                                      color: options[index]
                                                              .textColor ??
                                                          AppColors
                                                              .primary3[800]),
                                            ),
                                            IconWidget(
                                              icon: options[index].icon,
                                              boxShape: BoxShape.circle,
                                              padding: 1,
                                              height: 18,
                                              width: 18,
                                              backgroundColor:
                                                  const Color(0xffF3F4F8),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: index != options.length - 1,
                                      child: Divider(
                                        height: 0,
                                        color: AppColors.primary3[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
    double dy = (context.screenHeight - _overlayHeight) / 2;
    double dx = (context.screenWidth - _overlayWidth) / 2;
    return Offset(dx, dy);
  }

  double get _overlayHeight => options.length * 50;

  double get _overlayWidth => 180;
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
