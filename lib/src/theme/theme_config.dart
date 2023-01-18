import 'package:flutter/material.dart';
import 'color_utils.dart';

abstract class ThemeConfig {
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

  Color get shadowColor => colorShiftLightness(canvasColor, 0.2).withOpacity(0.3);

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
}