import 'package:flutter/material.dart';
///
/// Holds colors and names coresponding to swl values gaps for [CraneLoadChart] legend
class CraneLoadChartLegendData {
  final List<List<double>> _limits;
  final List<List<Color>> _colors;
  final List<List<String>> _names;
  ///
  /// [limits.length] = [colors.length] = [names.length] 
  const CraneLoadChartLegendData({
    required List<List<double>> limits,
    required List<List<Color>> colors,
    required List<List<String>> names,
  }) : 
    assert(limits.length > 0),
    assert(colors.length > 0),
    assert(names.length > 0),
    assert(limits.length == colors.length && colors.length == names.length),
    // TODO assert for inner lengths  
    _limits = limits,
    _colors = colors,
    _names = names;
  ///
  Iterable<double> limits(int index) => _limits[index];
  ///
  Iterable<Color> colors(int index) => _colors[index];
  ///
  Iterable<String> names(int index) => _names[index];
}