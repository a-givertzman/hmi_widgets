import 'package:flutter/material.dart';

class CraneLoadChartLegendData {
  final List<double> _limits;
  final List<Color> _colors;
  final List<String> _names;

  const CraneLoadChartLegendData({
    required List<double> limits,
    required List<Color> colors,
    required List<String> names,
  }) : _limits = limits,
  _colors = colors,
  _names = names;
}