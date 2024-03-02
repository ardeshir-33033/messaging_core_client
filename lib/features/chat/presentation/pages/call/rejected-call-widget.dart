import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';

class RejectedCallPage extends StatelessWidget {
  const RejectedCallPage({super.key, required this.controller});

  final CallController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.30)),
                ),
              ),
            ),
          ),

          // Avatar
          Positioned(
              top: MediaQuery.of(context).size.height / 4,
              right: 0,
              left: 0,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image(
                          image:
                              // (controller.profile == null ||
                              //         controller.profile!.avatarUrl == null ||
                              //         controller.profile!.avatarUrl?.isEmpty ==
                              //             true)
                              //     ?
                              Image.asset('assets/images/default.jpg').image,
                          // : NetworkImage(
                          //     controller.profile!.avatarUrl.last),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "",
                        // controller.profile == null
                        //     ? (controller.opponentId == null
                        //         ? ''
                        //         : controller.opponentId!.midEllipsis())
                        //     : controller.profile!.displayName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),

          Positioned(
              bottom: (MediaQuery.of(context).size.height / 2) - 160,
              right: 0,
              left: 0,
              child: Center(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Text(
                      controller.opponentCallRejectionReason ?? '',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ))),
        ],
      ),
    );
  }
}
