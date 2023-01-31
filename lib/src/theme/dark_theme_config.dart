import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/theme/theme_config.dart';
import 'color_utils.dart';

class DarkThemeConfig implements ThemeConfig {
  @override
  final canvasColor = const Color(0xff313131);

  @override
  final primaryColor = const Color(0xff91B4F8);
  @override
  final onPrimary = const Color(0xff242527);
  @override
  late final primaryColorLight = colorShiftLightness(primaryColor, 1.2);
  @override
  late final primaryColorDark = colorShiftLightness(primaryColor, 0.6);

  @override
  final secondary = const Color(0xffC3ABF8);
  @override
  final onSecondary = const Color(0xff242527);

  @override
  final tertiary = const Color(0xffB0B1AC);
  @override
  final onTertiary = const Color(0xff2B2B2B);

  @override
  final surfaceColor = const Color(0xff3b3b3b);
  @override
  final onSurfaceColor = Colors.white;

  @override
  final focusColor = Colors.white;
  @override
  final hoverColor = Colors.white;

  @override
  late final shadowColor = colorShiftLightness(canvasColor, 0.2).withOpacity(0.3);

  @override
  late final scaffoldBackgroundColor = canvasColor;
  @override
  final bottomAppBarColor = Colors.white;
  @override
  late final cardColor = surfaceColor;
  @override
  final dividerColor = Colors.white;
  @override
  final highlightColor = Colors.white;
  @override
  final splashColor = Colors.white;
  @override
  final selectedRowColor = Colors.white;
  @override
  final unselectedWidgetColor = Colors.white;
  @override
  final disabledColor = Colors.white;
  @override
  final secondaryHeaderColor = Colors.white;
  @override
  late final backgroundColor = canvasColor;
  @override
  final onBackgroundColor = Colors.white;
  @override
  late final dialogBackgroundColor = canvasColor;
  @override
  final indicatorColor = Colors.white;
  @override
  final hintColor = Colors.white;
  @override
  final errorColor = const Color(0xffF9A880); //Colors.redAccent[700]!;
  @override
  final onErrorColor = Colors.white;
  @override
  final toggleableActiveColor = Colors.white;

  @override
  final activeStateColor = const Color(0xff84E4B7);
  @override
  late final passiveStateColor = backgroundColor;

  @override
  late final lowLevelColor = errorColor;
  @override
  late final highLevelColor = errorColor;
  @override
  final obsoleteStatusColor = Colors.amber;
  @override
  final invalidStatusColor = Colors.purple;
  @override
  final timeInvalidStatusColor = Colors.purple;

  @override
  final alarmClass1Color = const Color(0xffF00505);
  @override
  final alarmClass2Color = const Color(0xffFF2C05);
  @override
  final alarmClass3Color = const Color(0xffFD6104);
  @override
  final alarmClass4Color = const Color(0xffFD9A01);
  @override
  final alarmClass5Color = const Color(0xffFFCE03);
  @override
  final alarmClass6Color = const Color(0xffFEF001);
}


