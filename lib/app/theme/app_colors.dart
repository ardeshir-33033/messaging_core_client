import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  ////////////////////
  //// Primary Colors
  ////////////////////

  ///primary1
  static const MaterialColor primary1 = MaterialColor(
    _primary1Value,
    <int, Color>{
      100: Color(0xFFEAF2FD),
      200: Color(0xFFD5E6FB),
      300: Color(0xFFACCCF8),
      400: Color(0xFF82B3F4),
      450: Color(0xFF5999F1),
      500: Color(_primary1Value),
      600: Color(0xFF2A73D5),
      700: Color(0xFF215AA6),
      800: Color(0xFF184077),
      900: Color(0xFF0E2647),
      950: Color(0xFF050D18),
    },
  );
  static const int _primary1Value = 0xFF48A4F9;
  static const Color backGroundWhiteColor = Color(0xFFFFFFFF);
  static Color backGroundSecondaryColor = const Color(0xFFFDFDFD);

  ///primary2
  static const MaterialColor primary2 = MaterialColor(
    _primary2Value,
    <int, Color>{
      100: Color(0xFFEFFBF9),
      200: Color(0xFFCFF4EC),
      300: Color(0xFFA0E9D9),
      400: Color(0xFF80E2CD),
      500: Color(_primary2Value),
      600: Color(0xFF56C5AD),
      700: Color(0xFF306E60),
      800: Color(0xFF132C26),
      900: Color(0xFF0A1613),
    },
  );
  static const int _primary2Value = 0xFF60DBC0;

  ///primary3
  static const MaterialColor primary3 = MaterialColor(
    _primary3Value,
    <int, Color>{
      100: Color(0xFFF3F4F8),
      200: Color(0xFFDADDEB),
      300: Color(0xFFC1C7DD),
      400: Color(0xFFA8B1CF),
      500: Color(_primary3Value),
      600: Color(0xFF687296),
      700: Color(0xFF4E5670),
      800: Color(0xFF272B38),
    },
  );
  static const int _primary3Value = 0xFF828FBB;

  ///neutral
  static const MaterialColor neutral = MaterialColor(
    _neutralValue,
    <int, Color>{
      100: Color(_neutralValue),
      200: Color(0xFF4F4F4F),
      300: Color(0xFF828282),
      400: Color(0xFFBDBDBD),
      500: Color(0xFFE0E0E0),
      600: Color(0xFFF2F2F2),
      700: Color(0xFFFAFAFA),
      800: Color(0xFFFFFFFF),
    },
  );
  static const int _neutralValue = 0xFF333333;
  static const subtitleColor = Color(0xFF8D8CA6);
  static const titleColor = Color(0xFF03034D);
  static const primaryBlack = Color(0xFF000000);
  static const primaryWhite = Color(0xFFFFFFFF);

  static const primaryRed = Color(0xFFEB5757);

  static Color getColorByHash(int hashCode) {
    switch (hashCode % 8) {
      case 0:
        return const Color(0xffE6294D);
      case 1:
        return const Color(0xff00C7BE);
      case 2:
        return const Color(0xff34C759);
      case 3:
        return const Color(0xffe86e1b);
      case 4:
        return const Color(0xff0221ff);
      case 5:
        return const Color(0xffba00ef);
      case 6:
        return const Color(0xfffa0780);
      default:
        return primary2.shade700;
    }
  }
}
