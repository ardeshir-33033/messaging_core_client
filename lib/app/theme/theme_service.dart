import 'package:flutter/material.dart';
import 'package:messaging_core/app/page_routing/cupertino_page_transition_builder.dart';
import 'package:messaging_core/app/page_routing/custom_transition.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/constants.dart';

class Themes {
  static final light = ThemeData(
    // useMaterial3: false,
      fontFamily: Assets.fontFamily,
      scaffoldBackgroundColor: AppColors.backGroundWhiteColor,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: MainTransitionBuilder(),
          TargetPlatform.iOS:
              const CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        },
      ))
    ..addCustom(ThemeColors());
  static final dark = ThemeData.dark()..addCustom(ThemeColors());
}

extension ThemeDataExtensions on ThemeData {
  static final Map<InputDecorationTheme, ThemeColors> _custom = {};

  void addCustom(ThemeColors custom) {
    _custom[inputDecorationTheme] = custom;
  }

  ThemeColors? custom() {
    return _custom[inputDecorationTheme];
  }
}

class ThemeColors {
  ThemeColorEx buttonPrimary = ThemeColorEx(
      light: const Color(0xff2F80ED), dark: const Color(0xff4362B8));
  ThemeColorEx borderPrimary =
      ThemeColorEx(light: Colors.red, dark: Colors.blue);
  ThemeColorEx disabledColor =
      ThemeColorEx(light: Color(0xff99a0ce), dark: Color(0xffc6d5ff));
  ThemeColorEx whiteBlack =
      ThemeColorEx(light: Colors.white, dark: Colors.black);
  ThemeColorEx backgroundColorPrimary = ThemeColorEx(
      light: const Color(0xfffbfbfb), dark: const Color(0xff303030));
  ThemeColorEx backgroundColorSecondary = ThemeColorEx(
      light: const Color(0xff303030), dark: const Color(0xfffbfbfb));
  ThemeColorEx accentColor = ThemeColorEx(
      light: const Color(0xff3FA0FF), dark: const Color(0xff2F80ED));
  ThemeColorEx primaryColor = ThemeColorEx(
      light: const Color(0xff2F80ED), dark: const Color(0xff4362B8));
  ThemeColorEx yellowColor = ThemeColorEx(
      light: const Color(0xffFFD700), dark: const Color(0xffFFD700));
  ThemeColorEx pinngle = ThemeColorEx(
      light: const Color(0xff40b66e), dark: const Color(0xffb4e4b7));
  ThemeColorEx textPrimary =
      ThemeColorEx(light: Colors.black, dark: Colors.white);
  ThemeColorEx textSecondary =
      ThemeColorEx(light: Colors.white, dark: Colors.black);
  ThemeColorEx iconPrimary =
      ThemeColorEx(light: Colors.black, dark: Colors.white);
  ThemeColorEx iconSecondary =
      ThemeColorEx(light: Colors.white, dark: Colors.black);
  ThemeColorEx shadowPrimary = ThemeColorEx(
      light: const Color(0xffeeeeee), dark: const Color(0xff333333));
  ThemeColorEx chatBackgroundPrimary = ThemeColorEx(
      light: const Color(0xffdcf8c6), dark: const Color(0xff046163));
  ThemeColorEx inActiveGray = ThemeColorEx(
      light: const Color(0xFF999999), dark: const Color(0xFF757575));
  ThemeColorEx shimmerHighlightColor = ThemeColorEx(
      light: const Color(0xffecebeb), dark: const Color(0xff797979));
  ThemeColorEx shimmerBaseColor = ThemeColorEx(
      light: const Color(0xffF5F5F5), dark: const Color(0xff3f3f4a));
}

class ThemeColorEx {
  final Color light;
  final Color dark;

  ThemeColorEx({required this.light, required this.dark});

  Color get th {
    return light;
    // TODO: remove GetX and fix it
    // if (Get.isDarkMode) {
    //   return dark;
    // } else {
    //   return light;
    // }
  }
}

// ThemeColors? ColorsEx(BuildContext context) => Theme.of(context).custom();
