import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';

///
/// Extends [ThemeData] with [StateColors].
/// 
/// Add [StateColors] to [ThemeData]:
/// ```dart
/// ThemeData(
///   ...,
///   extensions: [
///     StateColorsExtension(
///       stateColors: StateColors(...),
///     ),
///   ],
/// )
/// ```
/// Get [StateColors] from [ThemeData] either by:
/// ```dart
/// final stateColors = Theme.of(context).extension<StateColorsExtension>()?.stateColors;
/// ```
/// or by importing [AppThemeColors] extension:
/// ```dart
/// import 'package:hmi_widgets/hmi_widgets.dart';
/// final stateColors = Theme.of(context).stateColors;
/// ```
class StateColorsExtension extends ThemeExtension<StateColorsExtension> {
  ///
  final StateColors stateColors;
  ///
  const StateColorsExtension({required this.stateColors});
  //
  @override
  ThemeExtension<StateColorsExtension> copyWith({
    StateColors? alarmColors,
  }) => StateColorsExtension(
    stateColors: alarmColors ?? this.stateColors,
  );
  //
  @override
  ThemeExtension<StateColorsExtension> lerp(covariant ThemeExtension<StateColorsExtension>? other, double t) {
    if (other is! StateColorsExtension) {
      return this;
    }
    return StateColorsExtension(
      stateColors: StateColors(
        error: Color.lerp(stateColors.error, other.stateColors.error, t)!,
        alarm: Color.lerp(stateColors.alarm, other.stateColors.alarm, t)!,
        obsolete: Color.lerp(stateColors.obsolete, other.stateColors.obsolete, t)!,
        invalid: Color.lerp(stateColors.invalid, other.stateColors.invalid, t)!,
        timeInvalid: Color.lerp(stateColors.timeInvalid, other.stateColors.timeInvalid, t)!,
        lowLevel: Color.lerp(stateColors.lowLevel, other.stateColors.lowLevel, t)!,
        alarmLowLevel: Color.lerp(stateColors.alarmLowLevel, other.stateColors.alarmLowLevel, t)!,
        highLevel: Color.lerp(stateColors.highLevel, other.stateColors.highLevel, t)!,
        alarmHighLevel: Color.lerp(stateColors.alarmHighLevel, other.stateColors.alarmHighLevel, t)!,
        off: Color.lerp(stateColors.off, other.stateColors.off, t)!,
        on: Color.lerp(stateColors.on, other.stateColors.on, t)!,
      ),
    );
  }
}