import 'package:api_handler/feature/api_handler/presentation/presentation_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/core/services/navigation/navigation_utils.dart';
import 'package:messaging_core/main.dart';

class Navigation extends GetxController {
  APIHandler api;

  Navigation(this.api);

  List<Widget> pages = [
    const ChooseUserPage(),
  ];

  void push(Widget page) {
    pages.add(page);
    // if (page is StatefulWidget) {
    //   // ignore: invalid_use_of_protected_member
    //   (page).createState().initState();
    // }
    update();
  }

  Future<bool> pop({bool updateUi = true}) async {
    if (pages.length > 1) {
      final currentPage = pages.last;
      if (currentPage is CanPop) {
        return await (currentPage as CanPop).willPop();
      }
      pages.removeLast();
      if (updateUi) {
        update();
      }
    }
    return false;
  }

  pushAndRemoveUntilFirst(Widget page) {
    Widget firstPage = pages.first;
    pages = [firstPage];
    update();
    Future.delayed(const Duration(milliseconds: 100), () {
      push(page);
    });
  }

  pushReplacement(Widget page) {
    pages.removeLast();
    push(page);
  }

  removePage() {
    pages.removeLast();
    update();
  }

  setToken(String token) {
    api.setToken(token);
  }
}
