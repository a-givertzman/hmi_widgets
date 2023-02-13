import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_json.dart';
///
/// Holds colors and names corresponding to swl values gaps for [CraneLoadChart] legend
class CraneLoadChartLegendData {
  final CraneLoadChartLegendJson _legendJson;
  final List<List<double>> _limits = [];
  final List<List<Color>> _colors = [];
  final List<List<String>> _names = [];
  ///
  /// [limits.length] = [colors.length] = [names.length] 
  CraneLoadChartLegendData({
    required CraneLoadChartLegendJson legendJson,
  }) : 
    _legendJson = legendJson;
  ///
  Future<Iterable<Iterable<double>>> get limits async {
    if (_limits.isEmpty) {
      await _fillListsFromJson(_legendJson);
    }
    return Future.value(_limits);
  }
  ///
  Future<Iterable<Iterable<Color>>> get colors async {
    if (_colors.isEmpty) {
      await _fillListsFromJson(_legendJson);
    }
    return Future.value(_colors);
  }
  ///
  Future<Iterable<Iterable<String>>> get names async {
    if (_names.isEmpty) {
      await _fillListsFromJson(_legendJson);
    }
    return Future.value(_names);
  }
  ///
  Future<void> _fillListsFromJson(CraneLoadChartLegendJson legendJson) {
    return legendJson.decoded
    .then((legendMap) {
      final limits = legendMap['limits'] as List<List<double>>;
      final colors = legendMap['colors'] as List<List<Color>>;
      final names = legendMap['names'] as List<List<String>>;
      assert(limits.length == colors.length && colors.length == names.length);
      for(int i = 0; i < limits.length; i++) {
        assert(limits[i].length == colors[i].length && colors[i].length == names[i].length);
      }
      _limits.addAll(limits);
      _colors.addAll(colors);
      _names.addAll(names);
    }); 
  } 
}