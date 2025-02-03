import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'color_utils.dart';
///
final lightOldTheme = ThemeData(
  brightness: Brightness.light,
  typography: Typography.material2018(),
  scaffoldBackgroundColor: const Color(0xffFFFFFF),
  primaryColor: const Color(0xff7C987F),
  primaryColorLight: colorShiftLightness(const Color(0xff7C987F), 1.2),
  primaryColorDark: colorShiftLightness(const Color(0xff7C987F), 0.6),
  canvasColor: const Color(0xffFFFFFF),
  cardColor: const Color(0xffEEF1EF),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xff7C987F),
    onPrimary: Colors.black,
    secondary: const Color(0xff5D7E5F), 
    onSecondary: const Color(0xff242527),
    tertiary: const Color(0xff98BBFF),
    onTertiary: const Color(0xff3B3B3B),
    surface: const Color(0xffEEF1EF),
    onSurface: Colors.black,
    error: const Color(0xffC0686D),
    onError: colorInvert(const Color(0xffFFFFFF)),
  ),
  cardTheme: const CardTheme(
    elevation: 6.0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xffEEF1EF),
    foregroundColor: const Color(0xff7C987F),
  ),
  tabBarTheme: TabBarTheme(
    indicatorColor: const Color(0xff84E4B7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff7C987F),
      foregroundColor: const Color(0xff3B3B3B),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xff98BBFF),
    textStyle: TextStyle(
      fontSize: 18,
      color: const Color(0xff3B3B3B),
    ),
  ),
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xff7C987F)),
    ),
  ),
  extensions: const [
    StateColorsExtension(
      stateColors: StateColors(
        error: Color(0xffC0686D),
        lowLevel: Color(0xffC0686D),
        highLevel: Color(0xffC0686D),
        alarm: Color(0xffFD6104),
        alarmLowLevel: Color(0xffFD6104),
        alarmHighLevel: Color(0xffFD6104),
        obsolete: Colors.amber,
        invalid: Colors.purple,
        timeInvalid: Colors.purple,
        on: Color(0xff84E4B7),
        off: Color(0xffFFFFFF),
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
