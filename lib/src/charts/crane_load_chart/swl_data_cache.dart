import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/core/lazy_loadable.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';
///
class SwlDataCache {
  final LazyLoadable<List<Offset>> _pointsLoadable;
  final LazyLoadable<List<List<Color>>> _swlColorsLoadable;
  ///
  SwlDataCache({
    required SwlDataConverter swlDataConverter,
  }) : _pointsLoadable = LazyLoadable(
      load: () => swlDataConverter.points,
    ),
    _swlColorsLoadable = LazyLoadable(
      load: () => swlDataConverter.swlColors,
    );
  ///
  Future<List<Offset>> get points  => _pointsLoadable.value;
  ///
  Future<List<List<Color>>> get swlColors => _swlColorsLoadable.value;
}