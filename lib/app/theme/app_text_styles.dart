import 'package:flutter/material.dart';
import 'package:messaging_core/app/theme/app_colors.dart';
import 'package:messaging_core/app/theme/constants.dart';

class AppTextStyles {
  static const String fontFamily = Assets.fontFamily;
  static const String extraBold = Assets.extraBold;
  static const String bold = Assets.bold;
  static const String semi = Assets.semiBold;
  static const String medium = Assets.medium;
  static const String regular = Assets.regular;
  static const String light = Assets.light;

//headers
  static const headline1 = TextStyle(
    fontSize: 28,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: -1.5,
  );

  static const headline2 = TextStyle(
    fontSize: 28,
    fontFamily: bold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: -1.5,
  );
  static const headline3 = TextStyle(
    fontSize: 28,
    fontFamily: bold,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.5,
  );
  static const headline4 = TextStyle(
    fontSize: 16,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: 0.25,
  );
  static const headline5 = TextStyle(
    fontSize: 14,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: 0.25,
  );
  static const headline6 = TextStyle(
    fontSize: 12,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: 0.25,
  );
  static const subtitle = TextStyle(
    fontSize: 24,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );
  static const subtitle1 = TextStyle(
    fontSize: 24,
    fontFamily: extraBold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );
  static const subtitle2 = TextStyle(
    fontSize: 24,
    fontFamily: bold,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );
  static const subtitle3 = TextStyle(
    fontSize: 16,
    fontFamily: bold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );
  static const subtitle4 = TextStyle(
    fontSize: 14,
    fontFamily: bold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );
  static const subtitle5 = TextStyle(
    fontSize: 12,
    fontFamily: bold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );

  static const caption = TextStyle(
    fontSize: 20,
    fontFamily: extraBold,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );

  static const caption1 = TextStyle(
    fontSize: 20,
    fontFamily: bold,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );

  static const caption2 = TextStyle(
    fontSize: 20,
    fontFamily: bold,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.15,
  );

  static const body1 = TextStyle(
    fontSize: 16,
    fontFamily: semi,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );
  static const body2 = TextStyle(
    fontSize: 14,
    fontFamily: semi,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );
  static const body3 = TextStyle(
    fontSize: 12,
    fontFamily: semi,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const body4 = TextStyle(
    fontSize: 10,
    fontFamily: regular,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );
  static const body5 = TextStyle(
    fontSize: 8,
    fontFamily: regular,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const body6 = TextStyle(
    fontSize: 12,
    fontFamily: medium,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlack,
  );

  static const overline = TextStyle(
    fontSize: 16,
    fontFamily: regular,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const overline1 = TextStyle(
    fontSize: 14,
    fontFamily: regular,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );
  static const overline2 = TextStyle(
    fontSize: 12,
    fontFamily: regular,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const description = TextStyle(
    fontSize: 16,
    fontFamily: light,
    fontWeight: FontWeight.w300,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const description1 = TextStyle(
    fontSize: 14,
    fontFamily: light,
    fontWeight: FontWeight.w300,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const description2 = TextStyle(
    fontSize: 12,
    fontFamily: light,
    fontWeight: FontWeight.w300,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const button1 = TextStyle(
    fontSize: 14,
    fontFamily: semi,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryBlack,
    letterSpacing: 1.35,
  );

  static const button2 = TextStyle(
    fontSize: 12,
    fontFamily: semi,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );

  static const link = TextStyle(
    fontSize: 12,
    fontFamily: semi,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBlack,
    letterSpacing: 0.44,
  );
}
