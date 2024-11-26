import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/share_preferences.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeHelper extends GetxController {
  ThemeData _themeData =
      SharePreferencesUtils.getDarkMode() ? mydarkMode : lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == mydarkMode;

  void setThemeData(ThemeData value) {
    _themeData = value;
    SharePreferencesUtils.saveDarkMode(isDarkMode);

    update(); // Update the UI
  }

  void toggleChangeThemeMode() {
    log("Toggling change theme mode");
    setThemeData(isDarkMode ? lightMode : mydarkMode);
  }
}
