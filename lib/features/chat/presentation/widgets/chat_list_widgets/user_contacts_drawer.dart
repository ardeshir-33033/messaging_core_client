import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/constants.dart';
import 'package:messaging_core/app/widgets/icon_widget.dart';

class UserContactsDrawer extends StatelessWidget {
  const UserContactsDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        top: 150,
        child: Builder(builder: (context) {
          return InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 5)]),
              child: const IconWidget(
                icon: Assets.profileUser,
              ),
            ),
          );
        }));
  }
}
