import 'package:flutter/material.dart';
///
class CraneLoadChartLegendData {
  final List<double> _limits;
  final List<Color> _colors;
  final List<String> _names;
  ///
  const CraneLoadChartLegendData({
    required List<double> limits,
    required List<Color> colors,
    required List<String> names,
  }) : assert(limits.length == colors.length-1 && colors.length == names.length),
  _limits = limits,
  _colors = colors,
  _names = names;
  ///
  Iterable<double> get limits => _limits;
  ///
  Iterable<Color> get colors => _colors;
  ///
  Iterable<String> get names => _names;
}