import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_alarm_colors.dart';
import 'package:hmi_core/hmi_core_state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';
import 'color_utils.dart';
///
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  typography: Typography.material2018(),
  primaryColor: const Color(0xff91B4F8),
  primaryColorLight: colorShiftLightness(const Color(0xff91B4F8), 1.2),
  primaryColorDark: colorShiftLightness(const Color(0xff91B4F8), 0.6),
  canvasColor: const Color(0xff313131),
  cardColor: const Color(0xff3b3b3b),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xff91B4F8),
    onPrimary: const Color(0xff242527), 
    secondary: const Color(0xffC3ABF8), 
    onSecondary: const Color(0xff242527),
    tertiary: const Color(0xffB0B1AC),
    onTertiary: const Color(0xff2B2B2B),
    background: const Color(0xff313131), 
    onBackground: Colors.white, 
    surface: const Color(0xff3b3b3b), 
    onSurface: Colors.white, 
    error: const Color(0xffF9A880), 
    onError: Colors.white, 
  ),
  cardTheme: const CardTheme(
    elevation: 6.0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xff3b3b3b),
    foregroundColor: const Color(0xff91B4F8),
  ),
  tabBarTheme: TabBarTheme(
    indicatorColor: const Color(0xff84E4B7),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff91B4F8),
      foregroundColor: const Color(0xff2B2B2B),
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: const Color(0xffB0B1AC),
    textStyle: TextStyle(
      fontSize: 18,
      color: const Color(0xff2B2B2B),
    ),
  ),
  menuTheme: MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xff91B4F8)),
    ),
  ),
  extensions: [
    StateColorsExtension(
      stateColors: StateColors(
        error: const Color(0xffF9A880),
        lowLevel: const Color(0xffF9A880),
        highLevel: const Color(0xffF9A880),
        alarm: const Color(0xffFD6104),
        alarmLowLevel: const Color(0xffFD6104),
        alarmHighLevel: const Color(0xffFD6104),
        obsolete: Colors.amber,
        invalid: Colors.purple,
        timeInvalid: Colors.purple,
        on: const Color(0xff84E4B7),
        off: const Color(0xff313131),
      ),
    ),
    AlarmColorsExtension(
      alarmColors: AlarmColors(
        class1: const Color(0xffF00505),
        class2: const Color(0xffFF2C05),
        class3: const Color(0xffFD6104),
        class4: const Color(0xffFD9A01),
        class5: const Color(0xffFFCE03),
        class6: const Color(0xffFEF001),
      ),
    ),
  ],
);
