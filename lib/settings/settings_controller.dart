import 'dart:developer';

import 'package:aladhan/settings/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  // for state of darkMode
  var isDarkMode = false.obs;
  void setDarkMode(bool value) {
    isDarkMode.value = value;

    if (isDarkMode.value) {
      Get.changeTheme(AppTheme.dark);

      final box = Get.find<GetStorage>();
      box.write('themeColor', 'Dark');
    } else {
      Get.changeTheme(AppTheme.light);

      final box = Get.find<GetStorage>();
      box.write('themeColor', 'Light');
    }
  }

  // for state of Drawer
  var isHover = false.obs;
  void setHovering(bool value) {
    isHover.value = value;
  }

  final List<String> listColorName = [
    "Azure",
    "Go Green",
    "Sapphire",
    "Medium Pupple",
    "French Pink"
  ];

  final List<Color> listColor = [
    ColorPalletes.azure,
    ColorPalletes.goGreen,
    ColorPalletes.sapphire,
    ColorPalletes.mediumPurple,
    ColorPalletes.frenchPink
  ];

  var primaryColor = ColorPalletes.goGreen.obs;
  void setPrimaryColor(Color value, String key) {
    primaryColor.value = value;

    final box = Get.find<GetStorage>();
    box.write('primaryColor', key);
    final color = box.read('primaryColor');
    final theme = box.read('themeColor');
    log("Primary Color : $color");
    log("Theme Color : $theme");
  }

  void setThemePrimaryColor(Color value, {String? key}) {
    Get.changeTheme(
      AppTheme.light.copyWith(
        primaryColor: value,
        appBarTheme: AppBarTheme(
          color: value,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: value,
        ),
      ),
    );

    if (isDarkMode.value) {
      setDarkMode(false);
    }

    if (key != null) {
      final box = Get.find<GetStorage>();
      box.write('themeColor', key);
      box.write('primaryColor', key);
    }
  }

  void setTheme(String themeColor) {
    if (themeColor == 'Dark') {
      setDarkMode(true);
    } else {
      setDarkMode(false);

      if (themeColor == 'Azure') {
        setPrimaryColor(ColorPalletes.azure, themeColor);
        setThemePrimaryColor(ColorPalletes.azure, key: themeColor);
      } else if (themeColor == 'French Pink') {
        setPrimaryColor(ColorPalletes.frenchPink, themeColor);
        setThemePrimaryColor(ColorPalletes.frenchPink, key: themeColor);
      } else if (themeColor == 'Go Green') {
        setPrimaryColor(ColorPalletes.goGreen, themeColor);
        setThemePrimaryColor(ColorPalletes.goGreen, key: themeColor);
      } else if (themeColor == 'Medium Pupple') {
        setPrimaryColor(ColorPalletes.mediumPurple, themeColor);
        setThemePrimaryColor(ColorPalletes.mediumPurple, key: themeColor);
      } else if (themeColor == 'Sapphire') {
        setPrimaryColor(ColorPalletes.sapphire, themeColor);
        setThemePrimaryColor(ColorPalletes.sapphire, key: themeColor);
      }
    }
  }
}
