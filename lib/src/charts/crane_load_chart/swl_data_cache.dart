import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/lazy_loadable.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';
///
class SwlDataCache {
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
    );
  ///
  Future<List<Offset>> get points  => _pointsLazy.value;
  ///
  Future<List<List<Color>>> get swlColors => _swlColorsLazy.value;
}