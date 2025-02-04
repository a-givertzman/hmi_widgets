import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/alarm_colors_extension.dart';
import 'package:hmi_widgets/src/theme/state_colors_extension.dart';

///
/// Shorter way of getting [StateColors] and [AlarmColors] from [ThemeData]
extension AppThemeColors on ThemeData {
  StateColors get stateColors => extension<StateColorsExtension>()!.stateColors;
  AlarmColors get alarmColors => extension<AlarmColorsExtension>()!.alarmColors;
}