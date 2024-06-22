import 'package:aladhan/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ColorPalletes {
  static const patricksBlue = Color(0xFF1F2970);
  static const sapphire = Color(0xFF0D50AB);
  static const mediumPurple = Color(0xFF7C83FD);
  static const azure = Color(0xFF1E7AF5);
  static const frenchPink = Color(0xFFFF5D8F);
  static const goGreen = Color(0xFF12AE67);
  static const yellowRed = Color(0xFFFFCA60);
  static const bgColor = Color(0xFFF7F8F9);
  static const bgDarkColor = Color(0xFF232931);
  static const primaryDarkColor = Color(0xFF393E46);
}

final settingController = Get.put(SettingsController());

abstract class AppTheme {
  static final light = ThemeData.light().copyWith(
    backgroundColor: ColorPalletes.bgColor,
    scaffoldBackgroundColor: ColorPalletes.bgColor,
    primaryColor: settingController.primaryColor.value,
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: settingController.primaryColor.value,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: settingController.primaryColor.value,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    backgroundColor: ColorPalletes.bgDarkColor,
    scaffoldBackgroundColor: ColorPalletes.bgDarkColor,
    primaryColor: Colors.white,
    buttonTheme: const ButtonThemeData(buttonColor: ColorPalletes.goGreen),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    cardColor: ColorPalletes.primaryDarkColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalletes.primaryDarkColor,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorPalletes.goGreen,
      foregroundColor: Colors.white,
    ),
  );
}

abstract class AppTextStyle {
  static const bigTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: 0.5,
  );

  static const title = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.5,
  );

  static const normal = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.5,
  );

  static const small = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    letterSpacing: 0.3,
  );
}

abstract class AppShadow {
  static const card = BoxShadow(
    color: Color(0x00000014),
    blurRadius: 20,
    spreadRadius: 3,
    offset: Offset(0, 3),
  );
}