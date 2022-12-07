import 'package:flutter/material.dart';

import 'color_sets.dart';
import 'color_utils.dart';

abstract class ThemeConfig {
  Brightness get brightness => Brightness.dark;

  double get cardElevation => 0.6;

  Color get canvasColor => Color(0xff313131);

  Color get primaryColor => Color(0xff91B4F8);
  Color get onPrimary => Color(0xff242527);
  Color get primaryColorLight => colorShiftLightness(primaryColor, 1.2);
  Color get primaryColorDark => colorShiftLightness(primaryColor, 0.6);

  Color get secondary => Color(0xffC3ABF8);
  Color get onSecondary => Color(0xff242527);

  Color get tertiary => Color(0xffB0B1AC);
  Color get onTertiary => Color(0xff2B2B2B);

  Color get surfaceColor => Color(0xff3b3b3b);
  Color get onSurfaceColor => Colors.white;

  Color get focusColor => Colors.white;
  Color get hoverColor => Colors.white;

  Color get shadowColor =>
      colorShiftLightness(canvasColor, 0.2).withOpacity(0.3);

  Color get scaffoldBackgroundColor => canvasColor;
  Color get bottomAppBarColor => Colors.white;
  Color get cardColor => surfaceColor;
  Color get dividerColor => Colors.white;
  Color get highlightColor => Colors.white;
  Color get splashColor => Colors.white;
  Color get selectedRowColor => Colors.white;
  Color get unselectedWidgetColor => Colors.white;
  Color get disabledColor => Colors.white;
  Color get secondaryHeaderColor => Colors.white;
  Color get backgroundColor => canvasColor;
  Color get onBackgroundColor => Colors.white;
  Color get dialogBackgroundColor => canvasColor;
  Color get indicatorColor => Colors.white;
  Color get hintColor => Colors.white;
  Color get errorColor => Color(0xffF9A880); //Colors.redAccent[700]!;
  Color get onErrorColor => Colors.white;
  Color get toggleableActiveColor => Colors.white;

  Color get activeStateColor => Color(0xff84E4B7);
  Color get passiveStateColor => backgroundColor;

  Color get lowLevelColor => errorColor;
  Color get highLevelColor => errorColor;
  Color get obsoleteStatusColor => Colors.amber;
  Color get invalidStatusColor => Colors.purple;
  Color get timeInvalidStatusColor => Colors.purple;

  Color get alarmClass1Color => Color(0xffF00505);
  Color get alarmClass2Color => Color(0xffFF2C05);
  Color get alarmClass3Color => Color(0xffFD6104);
  Color get alarmClass4Color => Color(0xffFD9A01);
  Color get alarmClass5Color => Color(0xffFFCE03);
  Color get alarmClass6Color => Color(0xffFEF001);

  ThemeData asThemeData() => ThemeData(
        brightness: brightness,
        // scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        primaryColorLight: primaryColorLight,
        primaryColorDark: primaryColorDark,
        canvasColor: canvasColor,
        cardColor: cardColor,
        backgroundColor: backgroundColor,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryColor,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
          background: backgroundColor,
          onBackground: onBackgroundColor,
          surface: surfaceColor,
          onSurface: onSurfaceColor,
          error: errorColor,
          onError: onErrorColor,
        ),
        cardTheme: CardTheme(
          elevation: cardElevation,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: cardColor,
          foregroundColor: primaryColor,
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
          color: primaryColor,
          textStyle: TextStyle(fontSize: 18, color: onPrimary),
        ),
      );

  StateColors get stateColors => StateColors(
        error: errorColor,
        obsolete: obsoleteStatusColor,
        invalid: invalidStatusColor,
        timeInvalid: timeInvalidStatusColor,
        lowLevel: lowLevelColor,
        alarmLowLevel: alarmClass3Color,
        highLevel: highLevelColor,
        alarmHighLevel: alarmClass3Color,
        off: passiveStateColor,
        on: activeStateColor,
      );

  AlarmColors get alarmColors => AlarmColors(
        class1: alarmClass1Color,
        class2: alarmClass2Color,
        class3: alarmClass3Color,
        class4: alarmClass4Color,
        class5: alarmClass5Color,
        class6: alarmClass6Color,
      );
}
