import "package:flutter/material.dart";
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/dark_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/dark_theme.dart';
import 'package:hmi_widgets/src/theme/dark_old_theme.dart';
import 'package:hmi_widgets/src/theme/light_high_contrast_theme.dart';
import 'package:hmi_widgets/src/theme/light_theme.dart';
import 'package:hmi_widgets/src/theme/light_old_theme.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
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
extension AppThemeData on ThemeData {
  StateColors get stateColors => extension<StateColorsExtension>()!.stateColors;
  AlarmColors get alarmColors => extension<AlarmColorsExtension>()!.alarmColors;
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
