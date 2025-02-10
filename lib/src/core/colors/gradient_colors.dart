import 'package:flutter/painting.dart';
///
/// Provides color sampling from gradient.
class GradientColors {
  final LinearGradient gradient;
  ///
  /// Provides color sampling from gradient.
  /// [gradient] - a gradient to sample colors from.
  const GradientColors({
    required LinearGradient gradient,
  }) : gradient = gradient;
  ///
  /// Get specific color from a gradient.
  /// [position] - value from 0.0 to 1.0
  Color sample(double position) => _computeColor(
    position,
    gradient.stops ?? _generateStops(gradient.colors.length),
  );
  ///
  /// Get multiple equally spaced colors from a gradient.
  /// [count] - desired count of sampled colors.
  List<Color> sampleMany(int count) {
    final gradientStops = gradient.stops ?? _generateStops(gradient.colors.length);
    final sampleStops = _generateStops(count);
    return sampleStops
      .map((stop) => _computeColor(stop, gradientStops))
      .toList();
  }
  ///
  /// Get equally spaced stops.
  List<double> _generateStops(int colorsCount) {
    final step = 1.0 / (colorsCount - 1);
    return List.generate(
      colorsCount,
      (index) => index*step,
      growable: false,
    );
  }
  ///
  Color _computeColor(double stop, List<double> gradientStops) {
    final rightBorder = gradientStops.indexed.firstWhere((gradientStop) => stop <= gradientStop.$2);
    final leftIndex = rightBorder.$1 - 1;
    final leftBorder = gradientStops.indexed.elementAt(leftIndex > 0 ? leftIndex : 0);
    final relativeStop = (stop - leftBorder.$2) / (rightBorder.$2 - leftBorder.$2);
    return Color.lerp(
      gradient.colors[leftBorder.$1],
      gradient.colors[rightBorder.$1],
      relativeStop,
    )!;
  }
}
