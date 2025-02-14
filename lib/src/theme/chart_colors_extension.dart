import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/colors/gradient_colors.dart';
///
class ChartColorsExtension extends ThemeExtension<ChartColorsExtension> {
  final GradientColors gradientColors;
  ///
  const ChartColorsExtension({
    required this.gradientColors,
  });
  //
  @override
  ThemeExtension<ChartColorsExtension> copyWith({
    LinearGradient? gradient,
  }) => ChartColorsExtension(
    gradientColors: gradient != null
      ? GradientColors(gradient: gradient)
      : this.gradientColors,
  );
  //
  @override
  ThemeExtension<ChartColorsExtension> lerp(covariant ThemeExtension<ChartColorsExtension>? other, double t) {
    if (other is! ChartColorsExtension) {
      return this;
    }
    return ChartColorsExtension(
      gradientColors: GradientColors(
        gradient: LinearGradient.lerp(gradientColors.gradient, other.gradientColors.gradient, t)!,
      ),
    );
  }
}