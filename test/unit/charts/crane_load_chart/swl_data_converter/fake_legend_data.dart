import 'dart:ui';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
///
class FakeCraneLoadChartLegendData implements CraneLoadChartLegendData {
  final List<List<double>> _limits;
  final List<List<Color>> _colors;
  final List<List<String>> _names;
  FakeCraneLoadChartLegendData(this._limits, this._colors, this._names);
  @override
  Future<List<List<Color>>> get colors => Future.value(_colors);
  @override
  Future<Iterable<Iterable<double>>> get limits => Future.value(_limits);
  @override
  Future<Iterable<Iterable<String>>> get names => Future.value(_names);
}