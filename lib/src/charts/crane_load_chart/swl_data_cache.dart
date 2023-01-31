import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_data.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
import 'package:hmi_widgets/src/core/lazy_loadable.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';
///
/// Cached data for [CraneLoadChart] widget coming from SwlDataConverter
class SwlDataCache implements CraneLoadChartData {
  final SwlDataConverter _swlDataConverter;
  final LazyLoadable<List<Offset>> _pointsLazy;
  final LazyLoadable<List<List<Color>>> _swlColorsLazy;
  ///
  SwlDataCache({
    required SwlDataConverter swlDataConverter,
  }) : _pointsLazy = LazyLoadable(
      load: () => swlDataConverter.points,
    ),
    _swlColorsLazy = LazyLoadable(
      load: () => swlDataConverter.swlColors,
    ),
    _swlDataConverter = swlDataConverter;
  ///
  /// points (x, y) to be drawn on [CraneLoadChart]
  Future<List<Offset>> get points  => _pointsLazy.value;
  /// 
  /// colors of points on the [CraneLoadChart]
  Future<List<List<Color>>> get swlColors => _swlColorsLazy.value;
  //
  @override
  double get height => _swlDataConverter.height;
  //
  @override
  double get width => _swlDataConverter.width;
  //
  @override
  double get rawHeight => _swlDataConverter.rawHeight;
  //
  @override
  double get rawWidth => _swlDataConverter.rawWidth;
  //
  @override
  CraneLoadChartLegendData get legendData => _swlDataConverter.legendData;
}