import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';

/// Widget that is displayed when local/remote video is disabled.
class AudioCallWidget extends StatefulWidget {
  const AudioCallWidget({Key? key, required this.controller}) : super(key: key);
  final CallController controller;
  @override
  State<AudioCallWidget> createState() => _AudioCallWidgetState();
}

class _AudioCallWidgetState extends State<AudioCallWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF56C5AD),
                  Color(0xFF4372B4),
                  Color(0xFF21205A)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.15, 0.3, 1]),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.30)),
            ),
          ),
        ),
      ),
    ]);
  }
}
