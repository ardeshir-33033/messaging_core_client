import 'package:flutter/material.dart';
import 'package:messaging_core/core/utils/extensions.dart';
import 'package:messaging_core/main.dart';

enum OverlayAlignment {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
  bottomCenter
}

class OverlayWidget extends StatefulWidget {
  final Widget child;
  final Widget overlayWidget;
  final OverlayAnchor overlayAnchor;
  final OverlayController overlayController;
  final String? id;
  final double axisAlignment;
  final BuildContext? context;

  const OverlayWidget({
    Key? key,
    required this.child,
    required this.overlayWidget,
    required this.overlayController,
    required this.overlayAnchor,
    this.context,
    this.axisAlignment = 10,
    this.id,
  }) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with SingleTickerProviderStateMixin, RouteAware {
  late Animation<double> _sizeAnimation;
  late AnimationController _sizeAnimationController;
  late OverlayController _overlayController;
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  final layerLink = LayerLink();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(widget.context ?? context) is PageRoute) {
      routeObserver.subscribe(
          this, ModalRoute.of(widget.context ?? context) as PageRoute);
    }
  }

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
    _overlayController = widget.overlayController;
    _overlayController.addListener(() {
      if (_overlayController.isOverlayOpen &&
          _overlayController.tag == widget.id) {
        _showOverlay(context);
      } else {
        dismissOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: widget.child,
    );
  }

  void _showOverlay(BuildContext context) async {
    if (overlayEntry != null) return;
    overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  _overlayController.dismissOverlay();
                },
                child: SizedBox(
                  width: context.screenWidth,
                  height: context.screenHeight,
                ),
              ),
              CompositedTransformFollower(
                link: layerLink,
                offset: widget.overlayAnchor.offset,
                followerAnchor: widget.overlayAnchor.followerAnchor,
                targetAnchor: widget.overlayAnchor.targetAnchor,
                child: SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axis: Axis.vertical,
                  axisAlignment: widget.axisAlignment,
                  child: widget.overlayWidget,
                ),
              ),
            ],
          ),
        );
      },
    );
    overlayState = Overlay.of(context);
    overlayState!.insert(overlayEntry!);
    _sizeAnimationController.forward();
  }

  Future<void> dismissOverlay() async {
    if (overlayEntry == null) return;
    if (overlayEntry?.mounted == false) return;
    await _sizeAnimationController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() async {
    routeObserver.unsubscribe(this);
    _sizeAnimationController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  @override
  void didPush() {
    dismissOverlay();
  }

  @override
  void didPop() {
    dismissOverlay();
  }
}

class OverlayAnchor {
  final Alignment followerAnchor;
  final Alignment targetAnchor;
  final Offset offset;

  const OverlayAnchor({
    required this.offset,
    required this.followerAnchor,
    required this.targetAnchor,
  });
}

class OverlayController implements Listenable {
  final List<VoidCallback> _listeners = [];
  bool _isOverlayOpen = false;
  String? _overlayTag;

  bool get isOverlayOpen => _isOverlayOpen;

  String? get tag => _overlayTag;

  void openOverlay({
    String? tag,
  }) {
    _overlayTag = tag;
    if (_isOverlayOpen) return;
    _isOverlayOpen = true;
    for (final overlayStateCallback in _listeners) {
      overlayStateCallback.call();
    }
  }

  void dismissOverlay() {
    _overlayTag = null;
    if (_isOverlayOpen == false) return;
    _isOverlayOpen = false;
    for (final overlayStateCallback in _listeners) {
      overlayStateCallback.call();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }
}
