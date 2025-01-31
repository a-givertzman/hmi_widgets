import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_alarm_colors.dart';
import 'package:hmi_core/hmi_core_state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';

final lightNewTheme = ThemeData(
  typography: Typography.material2021(),
  scaffoldBackgroundColor: const Color(0xFFDFE2EB),
  cardTheme:  CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF191C20),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3A608F),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFBCC7DB),
    onSecondary: Color(0xFF263141),
    tertiaryFixedDim: Color(0xFFF5BD6F),
    error: Color(0xFFBA1A1A), 
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFC3C6CF),
    onSurface: Color(0xFF43474E),
    surfaceContainerHigh: Color(0xFF3A608F),
    outline: Color(0xFF73777F),
    outlineVariant: Color(0xFF43474E),
  ),
  extensions: const [
    StateColorsExtension(
      stateColors: StateColors(
        error: Color(0xFFFF9900),
        lowLevel: Color(0xFFFF9900),
        highLevel: Color(0xFFFF9900),
        alarm: Color(0xFFFF0011),
        alarmLowLevel: Color(0xFFFF0011),
        alarmHighLevel: Color(0xFFFF0011),
        obsolete: Color(0xFFCFEF001),
        invalid: Color(0xFF574165),
        timeInvalid: Color(0xFF574165),
        on: Color(0xFF009174),
        off: Color(0xFF73777F),
      ),
    ),
    AlarmColorsExtension(
      alarmColors: AlarmColors(
        class1: Color(0xffF00505),
        class2: Color(0xffFF2C05),
        class3: Color(0xffFD6104),
        class4: Color(0xffFD9A01),
        class5: Color(0xffFFCE03),
        class6: Color(0xffFEF001),
      ),
    ),
  ],
);