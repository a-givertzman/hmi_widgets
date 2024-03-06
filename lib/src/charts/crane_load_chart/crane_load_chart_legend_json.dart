import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
///
class CraneLoadChartLegendJson {
  final JsonList<Map<String, dynamic>> _jsonList;
  ///
  const CraneLoadChartLegendJson({
    required JsonList<Map<String, dynamic>> jsonList,
  }) :
    _jsonList = jsonList;
  ///
  Future<Map<String, List<List<dynamic>>>> get decoded {
    return _jsonList.decoded
      .then((result) {
        return switch(result) {
          Ok(:final value) => value,
          Err(:final error) => throw error,
        };
      })
      .then(
        (list) => list.fold<Map<String, List<List<dynamic>>>>(
          {
            'limits': <List<double>>[],
            'colors': <List<Color>>[],
            'names': <List<String>>[],
          }, 
          (craneLoadChartLegendMap, map) {
            final limits = <double>[];
            final colors = <Color>[];
            final names = <String>[];
            for (final entry in map.entries) {
              limits.add(entry.value['limit']);
              colors.add(
                Color(
                  int.parse(entry.value['color']),
                ),
              );
              names.add(entry.key);
            }
            craneLoadChartLegendMap['limits']!.add(limits);
            craneLoadChartLegendMap['colors']!.add(colors);
            craneLoadChartLegendMap['names']!.add(names);
            return craneLoadChartLegendMap;
          },
        ),
      ).onError((error, stackTrace) => throw Failure.convertion(
        message: 'Ошибка в методе $runtimeType.decoded: $error', 
        stackTrace: stackTrace,
      ));
  }
}