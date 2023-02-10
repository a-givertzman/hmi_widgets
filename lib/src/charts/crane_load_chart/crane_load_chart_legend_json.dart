import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
///
class CraneLoadChartLegendJson {
  final JsonList<Map<String, dynamic>> _jsonList;
  ///
  CraneLoadChartLegendJson(this._jsonList);
  ///
  Future<CraneLoadChartLegendData> get decoded async {
    return _jsonList.decoded
      .then((list) => list.fold(
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
      )
      .then((craneLoadChartLegendMap) => CraneLoadChartLegendData(
        limits: craneLoadChartLegendMap['limits'] as List<List<double>>,
        colors: craneLoadChartLegendMap['colors'] as List<List<Color>>,
        names: craneLoadChartLegendMap['names'] as List<List<String>>,
      ));
  }
}