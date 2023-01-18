import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/theme/theme_config.dart';
import 'color_utils.dart';

class LightThemeConfig implements ThemeConfig {

  final canvasColor = Color(0xffFFFFFF);

  final primaryColor = Color(0xff7C987F);
  final onPrimary = Colors.black;
  late final primaryColorLight = colorShiftLightness(primaryColor, 1.2);
  late final primaryColorDark = colorShiftLightness(primaryColor, 0.6);

  final secondary = Color(0xff5D7E5F); // colorShiftLightness(canvasColor, 0.8); //Color(0xff269926);// Color(0xff242527);
  final onSecondary = Color(0xff242527);

  final tertiary = Color(0xff98BBFF);
  final onTertiary = Color(0xff3B3B3B);

  final surfaceColor = Color(0xffEEF1EF);  //Colors.amberAccent[400]!;
  final onSurfaceColor = Colors.black;


  final focusColor = Colors.white;
  final hoverColor = Colors.white;

  late final shadowColor = colorShiftLightness(canvasColor, 0.2).withOpacity(0.3);

  late final scaffoldBackgroundColor = canvasColor;
  final bottomAppBarColor = Colors.white;
  late final cardColor = surfaceColor;
  final dividerColor = Colors.white;
  final highlightColor = Colors.white;
  final splashColor = Colors.white;
  final selectedRowColor = Colors.white;
  final unselectedWidgetColor = Colors.white;
  final disabledColor = Colors.white;
  final secondaryHeaderColor = Colors.white;
  late final backgroundColor = canvasColor;
  late final onBackgroundColor = colorInvert(backgroundColor);
  late final dialogBackgroundColor = canvasColor;
  final indicatorColor = Colors.white;
  final hintColor = Colors.white;
  final errorColor = Color(0xffC0686D); //Colors.redAccent[700]!;
  late final onErrorColor = colorInvert(backgroundColor);
  final toggleableActiveColor = Colors.white;

  final activeStateColor = Color(0xff84E4B7);
  late final passiveStateColor = backgroundColor;

  late final lowLevelColor = errorColor;
  late final highLevelColor = errorColor;
  final obsoleteStatusColor = Colors.amber;
  final invalidStatusColor = Colors.purple;
  final timeInvalidStatusColor = Colors.purple;

  final alarmClass1Color = Color(0xffF00505);
  final alarmClass2Color = Color(0xffFF2C05);
  final alarmClass3Color = Color(0xffFD6104);
  final alarmClass4Color = Color(0xffFD9A01);
  final alarmClass5Color = Color(0xffFFCE03);
  final alarmClass6Color = Color(0xffFEF001);
}
