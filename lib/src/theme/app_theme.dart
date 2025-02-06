import "package:flutter/material.dart";
import 'package:hmi_widgets/src/theme/dark_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/dark_theme.dart';
import 'package:hmi_widgets/src/theme/dark_old_theme.dart';
import 'package:hmi_widgets/src/theme/light_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/light_theme.dart';
import 'package:hmi_widgets/src/theme/light_old_theme.dart';
///
enum AppTheme {
  lightOld,
  light,
  lightHighContrast,
  darkOld,
  dark,
  darkHighContrast,
}
///
final Map<AppTheme, ThemeData> appThemes = {
  ///
  /// Light theme of entire application
  AppTheme.lightOld: lightOldTheme,
  ///
  /// Dark theme of entire application
  AppTheme.darkOld: darkOldTheme,
  ///
  AppTheme.dark: darkTheme,
  ///
  AppTheme.darkHighContrast: darkHighContrastTheme,
  ///
  AppTheme.light: lightTheme,
  ///
  AppTheme.lightHighContrast: lightHighContrastTheme,
};
