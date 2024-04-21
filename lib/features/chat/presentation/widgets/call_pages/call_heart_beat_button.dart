import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';
import 'package:messaging_core/features/chat/presentation/manager/call_controller.dart';

class CallHeartBeatButton extends StatefulWidget {
  const CallHeartBeatButton({
    super.key,
  });

  @override
  State<CallHeartBeatButton> createState() => _CallHeartBeatButtonState();
}

class _CallHeartBeatButtonState extends State<CallHeartBeatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
        id: "app_bar",
        builder: (logic) {
          if (logic.callStatus == CallStatus.noCall) {
            _controller.reset();
          } else {
            if (!_controller.isAnimating) {
              _controller.repeat();
            }
          }
          return ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.3).animate(_controller),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(48, 33),
                  painter: RPSCustomPainter(),
                ),
                const IconWidget(
                  icon: Assets.callOutlined,
                  iconColor: Colors.white,
                )
              ],
            ),
          );
        });
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(8.67653, 0.4064);
    path_0.cubicTo(6.67653, -0.7483, 4.17653, 0.69507, 4.17653, 3.00447);
    path_0.lineTo(4.17653, 8.36202);
    path_0.cubicTo(1.54131, 10.8021, 0, 13.7535, 0, 16.9329);
    path_0.cubicTo(0, 25.3276, 10.7452, 32.1329, 24, 32.1329);
    path_0.cubicTo(37.2548, 32.1329, 48, 25.3276, 48, 16.9329);
    path_0.cubicTo(48, 8.53816, 37.2548, 1.73288, 24, 1.73288);
    path_0.cubicTo(20.2657, 1.73288, 16.7306, 2.27304, 13.5788, 3.23672);
    path_0.lineTo(8.67653, 0.4064);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff4EB371).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
