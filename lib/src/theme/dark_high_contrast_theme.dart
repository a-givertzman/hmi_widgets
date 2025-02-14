import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/gradient_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'package:hmi_widgets/src/theme/chart_colors_extension.dart';

final darkHighContrastTheme = ThemeData(
  typography: Typography.material2021(),
  scaffoldBackgroundColor: const Color(0xFF000000),
  cardTheme:  CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: const BorderSide(
        width: 1,
        color: Color(0xFFFFFFFF),
      ),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFFFFFFF),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFFBFAFF),
    onSecondary: Color(0xFF000000),
    tertiaryFixedDim: Color(0xFFFFC14E),
    error: Color(0xFFFFB4AB), 
    onError: Color(0xFF690005),
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFF4DAF48),
    outline: Color(0xFF0095FF),
  ),
  extensions: const [
    StateColorsExtension(
      stateColors: StateColors(
        error: Color(0xFFDDFF00),
        lowLevel: Color(0xFFDDFF00),
        highLevel: Color(0xFFDDFF00),
        alarm: Color(0xFFFF003C),
        alarmLowLevel: Color(0xFFFF003C),
        alarmHighLevel: Color(0xFFFF003C),
        obsolete: Color(0xFFFD9A01),
        invalid: Color(0xFF9D00FF),
        timeInvalid: Color(0xFF9D00FF),
        on: Color(0xFF4DAF48),
        off: Color(0xFFFFFFFF),
      ),
    ),
    AlarmColorsExtension(
      alarmColors: AlarmColors(
        class1: Color(0xFFF00505),
        class2: Color(0xFFFF2C05),
        class3: Color(0xFFFD6104),
        class4: Color(0xFFFD9A01),
        class5: Color(0xFFFFCE03),
        class6: Color(0xFFFEF001),
        class7: Colors.white,
        class8: Colors.white,
      ),
    ),
    ChartColorsExtension(
      gradientColors: GradientColors(
        gradient: LinearGradient(
          colors: [
            Color(0xFF042200),
            Color(0xFF8BFF33),
            Color(0xFFFFA11F),
            Color(0xFFFF5100),
          ],
          stops: [
            0.0,
            0.35,
            0.69,
            1.0,
          ],
        ),
      ),
    ),
  ],
);