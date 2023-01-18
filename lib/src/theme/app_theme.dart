import "package:flutter/material.dart";

import 'dark_theme_config.dart';
import 'light_theme_config.dart';

final light_theme = LightThemeConfig();
final dark_theme = DarkThemeConfig();

enum AppTheme {
  light,
  dark,
}

const cardThemeElevation = 6.0;

///
class StateColors {
  final Color error;
  final Color obsolete;
  final Color invalid;
  final Color timeInvalid;
  final Color lowLevel;
  final Color alarmLowLevel;
  final Color highLevel;
  final Color alarmHighLevel;
  final Color off;
  final Color on;
  StateColors({
    required this.error,
    required this.obsolete, 
    required this.invalid, 
    required this.timeInvalid, 
    required this.lowLevel,
    required this.alarmLowLevel,
    required this.highLevel,
    required this.alarmHighLevel,
    required this.off, 
    required this.on,
  });
}

///
class AlarmColors {
  final Color class1;
  final Color class2;
  final Color class3;
  final Color class4;
  final Color class5;
  final Color class6;
  AlarmColors({
    required this.class1,
    required this.class2, 
    required this.class3, 
    required this.class4, 
    required this.class5,
    required this.class6,
  });
}

extension AppThemeData on ThemeData {
  StateColors get stateColors => StateColors(
    error: brightness == Brightness.light
      ? light_theme.errorColor
      : dark_theme.errorColor, 
    obsolete: brightness == Brightness.light
      ? light_theme.obsoleteStatusColor
      : dark_theme.obsoleteStatusColor, 
    invalid: brightness == Brightness.light
      ? light_theme.invalidStatusColor
      : dark_theme.invalidStatusColor, 
    timeInvalid: brightness == Brightness.light
      ? light_theme.timeInvalidStatusColor
      : dark_theme.timeInvalidStatusColor, 
    lowLevel: brightness == Brightness.light
      ? light_theme.lowLevelColor
      : dark_theme.lowLevelColor,
    alarmLowLevel: brightness == Brightness.light
      ? light_theme.alarmClass3Color
      : dark_theme.alarmClass3Color,
    highLevel: brightness == Brightness.light
      ? light_theme.highLevelColor
      : dark_theme.highLevelColor,
    alarmHighLevel: brightness == Brightness.light
      ? light_theme.alarmClass3Color
      : dark_theme.alarmClass3Color,
    off: brightness == Brightness.light
      ? light_theme.passiveStateColor
      : dark_theme.passiveStateColor, 
    on: brightness == Brightness.light
      ? light_theme.activeStateColor
      : dark_theme.activeStateColor,
  );
  AlarmColors get alarmColors => AlarmColors(
    class1:  brightness == Brightness.light
      ? light_theme.alarmClass1Color
      : dark_theme.alarmClass1Color, 
    class2: brightness == Brightness.light
      ? light_theme.alarmClass2Color
      : dark_theme.alarmClass2Color, 
    class3: brightness == Brightness.light
      ? light_theme.alarmClass3Color
      : dark_theme.alarmClass3Color, 
    class4: brightness == Brightness.light
      ? light_theme.alarmClass4Color
      : dark_theme.alarmClass4Color, 
    class5: brightness == Brightness.light
      ? light_theme.alarmClass5Color
      : dark_theme.alarmClass5Color, 
    class6: brightness == Brightness.light
      ? light_theme.alarmClass6Color
      : dark_theme.alarmClass6Color, 
  );
}

final Map<AppTheme, ThemeData> appThemes = {
  ///
  /// Light theme of entire application
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
    // scaffoldBackgroundColor: lightTheme.backgroundColor,
    primaryColor: light_theme.primaryColor,
    primaryColorLight: light_theme.primaryColorLight,
    primaryColorDark: light_theme.primaryColorDark,
    canvasColor: light_theme.canvasColor,
    cardColor: light_theme.cardColor,
    backgroundColor: light_theme.backgroundColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: light_theme.primaryColor,
      onPrimary: light_theme.onPrimary, 
      secondary: light_theme.secondary, 
      onSecondary: light_theme.onSecondary,
      background: light_theme.backgroundColor, 
      onBackground: light_theme.onBackgroundColor, 
      surface: light_theme.surfaceColor, 
      onSurface: light_theme.onSurfaceColor, 
      error: light_theme.errorColor, 
      onError: light_theme.onErrorColor, 
    ),
    cardTheme: const CardTheme(
      elevation: cardThemeElevation,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: light_theme.cardColor,
      foregroundColor: light_theme.primaryColor,
    ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     elevation: MaterialStateProperty.all(cardThemeElevation),
    //     // backgroundColor: MaterialStateProperty.all<Color>(dark_theme.cardColor),
    //     backgroundColor: MaterialStateProperty.all<Color>(light_theme.tertiary),
    //     // foregroundColor: MaterialStateProperty.all<Color>(dark_theme.onTertiary),
    //     // surfaceTintColor: MaterialStateProperty.all<Color>(dark_theme.onTertiary),
    //     textStyle: MaterialStateProperty.all(const TextStyle(color: light_theme.onTertiary)),
    //   ),
    // ),
    popupMenuTheme: PopupMenuThemeData(
      color: light_theme.tertiary,
      textStyle: TextStyle(fontSize: 18, color: light_theme.onTertiary),
    ),
  ),
  ///
  /// Dark theme of entire application
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    // scaffoldBackgroundColor: backgroundColor,
    primaryColor: dark_theme.primaryColor,
    primaryColorLight: dark_theme.primaryColorLight,
    primaryColorDark: dark_theme.primaryColorDark,
    canvasColor: dark_theme.canvasColor,
    cardColor: dark_theme.cardColor,
    backgroundColor: dark_theme.backgroundColor,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: dark_theme.primaryColor,
      onPrimary: dark_theme.onPrimary, 
      secondary: dark_theme.secondary, 
      onSecondary: dark_theme.onSecondary,
      tertiary: dark_theme.tertiary,
      onTertiary: dark_theme.onTertiary,
      background: dark_theme.backgroundColor, 
      onBackground: dark_theme.onBackgroundColor, 
      surface: dark_theme.surfaceColor, 
      onSurface: dark_theme.onSurfaceColor, 
      error: dark_theme.errorColor, 
      onError: dark_theme.onErrorColor, 
    ),
    cardTheme: const CardTheme(
      elevation: cardThemeElevation,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: dark_theme.cardColor,
      foregroundColor: dark_theme.primaryColor,
    ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ButtonStyle(
    //     // elevation: MaterialStateProperty.all(cardThemeElevation),
    //     // backgroundColor: MaterialStateProperty.all<Color>(dark_theme.cardColor),
    //     foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
    //       if (states.contains(MaterialState.disabled)) {
    //         return dark_theme.primaryColor;
    //       }
    //       return dark_theme.primaryColor;
    //     }),
    //     // foregroundColor: MaterialStateProperty.all<Color>(dark_theme.onTertiary),
    //     // surfaceTintColor: MaterialStateProperty.all<Color>(dark_theme.onTertiary),
    //     textStyle: MaterialStateProperty.all(const TextStyle(color: dark_theme.onPrimary)),
    //   ),
    // ),
    popupMenuTheme: PopupMenuThemeData(
      color: dark_theme.primaryColor,
      textStyle: TextStyle(fontSize: 18, color: dark_theme.onPrimary),
    ),
  ),
};
