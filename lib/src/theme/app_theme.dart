import "package:flutter/material.dart";
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/light_theme.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'dark_theme.dart';
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
};
