import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';

final darkTheme = ThemeData(
  typography: Typography.material2021(),
  scaffoldBackgroundColor: const Color(0xFF111318),
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
    color: Color(0xFFE1E2E8),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA4C9FE),
    onPrimary: Color(0xFF00315C),
    secondary: Color(0xFFBCC7DB),
    onSecondary: Color(0xFF263141),
    tertiaryFixedDim: Color(0xFFF5BD6F),
    error: Color(0xFFFFB4AB), 
    onError: Color(0xFF690005),
    surface: Color(0xFF0C0E13),
    onSurface: Color(0xFFC3C6CF),
    surfaceContainerHigh: Color(0xFFA4C9FE),
    outline: Color(0xFF8D9199),
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
        obsolete: Color(0xFFFEF001),
        invalid: Color(0xFF574165),
        timeInvalid: Color(0xFF574165),
        on: Color(0xFF009174),
        off: Color(0xFF3C4758),
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
        class7: Colors.white,
        class8: Colors.white,
      ),
    ),
  ],
);