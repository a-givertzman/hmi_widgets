import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/gradient_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/chart_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'color_utils.dart';
///
final darkOldTheme = ThemeData(
  brightness: Brightness.dark,
  typography: Typography.material2018(),
  scaffoldBackgroundColor: const Color(0xff313131),
  primaryColor: const Color(0xFF91B4F8),
  primaryColorLight: colorShiftLightness(const Color(0xFF91B4F8), 1.2),
  primaryColorDark: colorShiftLightness(const Color(0xFF91B4F8), 0.6),
  canvasColor: const Color(0xFF313131),
  cardColor: const Color(0xFF3B3B3B),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF91B4F8),
    onPrimary: const Color(0xFF242527),
    secondary: const Color(0xFFC3ABF8),
    onSecondary: const Color(0xFF242527),
    tertiary: const Color(0xFFB0B1AC),
    onTertiary: const Color(0xFF2B2B2B),
    surface: const Color(0xFF3B3B3B),
    onSurface: Colors.white,
    error: const Color(0xFFF9A880),
    onError: Colors.white,
  ),
  cardTheme: const CardTheme(
    elevation: 6.0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF3B3B3B),
    foregroundColor: const Color(0xFF91B4F8),
  ),
  tabBarTheme: TabBarTheme(
    indicatorColor: const Color(0xFF84E4B7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF91B4F8),
      foregroundColor: const Color(0xFF2B2B2B),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xFFB0B1AC),
    textStyle: TextStyle(
      fontSize: 18,
      color: const Color(0xFF2B2B2B),
    ),
  ),
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xFF91B4F8)),
    ),
  ),
  extensions: const [
    StateColorsExtension(
      stateColors: StateColors(
        error: Color(0xFFF9A880),
        lowLevel: Color(0xFFF9A880),
        highLevel: Color(0xFFF9A880),
        alarm: Color(0xFFFD6104),
        alarmLowLevel: Color(0xFFFD6104),
        alarmHighLevel: Color(0xFFFD6104),
        obsolete: Colors.amber,
        invalid: Colors.purple,
        timeInvalid: Colors.purple,
        on: Color(0xFF84E4B7),
        off: Color(0xFF313131),
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
            Color(0xFFBDBDBD),
            Color(0xFF64B5F6),
            Color(0xFF81C784),
            Color(0xFFFFA726),
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
