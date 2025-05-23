import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
/// 
/// Extends [ThemeData] with [AlarmColors].
/// 
/// Add [AlarmColors] to [ThemeData]:
/// ```dart
/// ThemeData(
///   ...,
///   extensions: [
///     AlarmColorsExtension(
///       alarmColors: AlarmColors(...),
///     ),
///   ],
/// )
/// ```
/// Get [AlarmColors] from [ThemeData] either by:
/// ```dart
/// final alarmColors = Theme.of(context).extension<AlarmColorsExtension>()?.alarmColors;
/// ```
/// or by importing [AppThemeColors] extension:
/// ```dart
/// import 'package:hmi_widgets/hmi_widgets.dart';
/// final alarmColors = Theme.of(context).alarmColors;
/// ```
class AlarmColorsExtension extends ThemeExtension<AlarmColorsExtension> {
  ///
  final AlarmColors alarmColors;
  ///
  const AlarmColorsExtension({required this.alarmColors});
  //
  @override
  ThemeExtension<AlarmColorsExtension> copyWith({
    AlarmColors? alarmColors,
  }) => AlarmColorsExtension(
    alarmColors: alarmColors ?? this.alarmColors,
  );
  //
  @override
  ThemeExtension<AlarmColorsExtension> lerp(covariant ThemeExtension<AlarmColorsExtension>? other, double t) {
    if (other is! AlarmColorsExtension) {
      return this;
    }
    return AlarmColorsExtension(
      alarmColors: AlarmColors(
        class1: Color.lerp(alarmColors.class1, other.alarmColors.class1, t)!,
        class2: Color.lerp(alarmColors.class2, other.alarmColors.class2, t)!,
        class3: Color.lerp(alarmColors.class3, other.alarmColors.class3, t)!,
        class4: Color.lerp(alarmColors.class4, other.alarmColors.class4, t)!,
        class5: Color.lerp(alarmColors.class5, other.alarmColors.class5, t)!,
        class6: Color.lerp(alarmColors.class6, other.alarmColors.class6, t)!,
        class7: Color.lerp(alarmColors.class7, other.alarmColors.class7, t)!,
        class8: Color.lerp(alarmColors.class8, other.alarmColors.class8, t)!,
      ),
    );
  }
}