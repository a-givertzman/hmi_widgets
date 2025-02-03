import "package:flutter/material.dart";
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/dark_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/dark_new_theme.dart';
import 'package:hmi_widgets/src/theme/dark_theme.dart';
import 'package:hmi_widgets/src/theme/light_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/light_new_theme.dart';
import 'package:hmi_widgets/src/theme/light_theme.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
///
enum AppTheme {
  light,
  lightNew,
  lightHighContrast,
  dark,
  darkNew,
  darkHighContrast,
}
///
extension AppThemeData on ThemeData {
  StateColors get stateColors => extension<StateColorsExtension>()!.stateColors;
  AlarmColors get alarmColors => extension<AlarmColorsExtension>()!.alarmColors;
}
///
final Map<AppTheme, ThemeData> appThemes = {
  ///
  /// Light theme of entire application
  AppTheme.light: lightTheme,
  ///
  /// Dark theme of entire application
  AppTheme.dark: darkTheme,
  ///
  AppTheme.darkNew: darkNewTheme,
  ///
  AppTheme.darkHighContrast: darkHighContrastTheme,
  ///
  AppTheme.lightNew: lightNewTheme,
  ///
  AppTheme.lightHighContrast: lightHighContrastTheme,
};
