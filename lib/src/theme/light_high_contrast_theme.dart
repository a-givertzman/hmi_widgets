import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/gradient_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'package:hmi_widgets/src/theme/chart_colors_extension.dart';

final lightHighContrastTheme = ThemeData(
  typography: Typography.material2021(),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  cardTheme:  CardThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: const BorderSide(
        width: 1,
        color: Color(0xFF000000),
      ),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF000000),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF182332),
    onSecondary: Color(0xFFFFFFFF),
    tertiaryFixedDim: Color(0xFFFFA600),
    error: Color(0xFF4E0002), 
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
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
        off: Color(0xFF001C39),
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
        class7: Colors.black,
        class8: Colors.black,
      ),
    ),
    ChartColorsExtension(
      gradientColors: GradientColors(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD3FFCD),
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