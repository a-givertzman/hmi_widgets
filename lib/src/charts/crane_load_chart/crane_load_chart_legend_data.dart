import 'package:flutter/material.dart';
///
/// Holds colors and names coresponding to swl values gaps for [CraneLoadChart] legend
class CraneLoadChartLegendData {
  final List<double> _limits;
  final List<Color> _colors;
  final List<String> _names;
  ///
  /// [limits.length] = [colors.length] = [names.length] 
  const CraneLoadChartLegendData({
    required List<double> limits,
    required List<Color> colors,
    required List<String> names,
  }) : 
    assert(limits.length > 0),
    assert(colors.length > 0),
    assert(names.length > 0),
    assert(limits.length == colors.length && colors.length == names.length),
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