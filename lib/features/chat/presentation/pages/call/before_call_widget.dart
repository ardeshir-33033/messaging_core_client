import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging_core/app/theme/theme_service.dart';

class BeforeCallPage extends StatelessWidget {
  const BeforeCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.call,
            size: 60,
            color: ColorsEx(context)!.primaryColor.th,
          )),
    );
  }
}
