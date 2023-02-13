import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
import 'fake_legend_json.dart';
void main() {
  group('CraneLoadChartLegendData constructor', () {
    const validData = [
      {
        'limits': [[0.0]],
        'colors': [[Colors.blue]],
        'names': [['Gap1']],
      },
      {
        'limits': [[0.0, 1.3]],
        'colors': [[Colors.blue, Colors.black]],
        'names': [['Gap1', 'Gap2']],
      },
      {
        'limits': [[0.0, 1.3, 10.1]],
        'colors': [[Colors.blue, Colors.black, Colors.lime]],
        'names': [['Gap1', 'Gap2', 'Gap3']],
      },
      {
        'limits': [[13.6, 15.2, 20.1, 40.5]],
        'colors': [[Colors.blue, Colors.black, Colors.lime, Colors.orange]],
        'names': [['Gap1', 'Gap2', 'Gap3', 'Gap4']],
      },
    ];
    test('completes normally on valid data', () async {
      for(final data in validData) {
        final legendData = CraneLoadChartLegendData(
          legendJson: FakeCraneLoadChartLegendJson(data),
        );
        expect(
          await legendData.limits,
          data['limits'],
          reason: 'Passed limits is not equals to it\'s origin.'
        );
        expect(
          await legendData.colors,
          data['colors'],
          reason: 'Passed colors is not equals to it\'s origin.'
        );
        expect(
          await legendData.names,
          data['names'],
          reason: 'Passed names is not equals to it\'s origin.'
        ); 
      }
    });
    const invalidData = [
      {
        'limits': <List<double>>[[]],
        'colors': [[Colors.blue]],
        'names': [['Gap1']],
      },
      {
        'limits': [[0.0]],
        'colors': <List<Color>>[[]],
        'names': [['Gap1']],
      },
      {
        'limits': [[0.0]],
        'colors': [[Colors.blue]],
        'names': <List<String>>[],
      },
      {
        'limits': [[0.0, 1.3]],
        'colors': [[Colors.blue, Colors.black, Colors.lime, Colors.orange]],
        'names': [['Gap1', 'Gap2', 'Gap3']],
      },
      {
        'limits': [[13.6, 15.2, 20.1]],
        'colors': [[Colors.blue, Colors.black, Colors.lime, Colors.orange]],
        'names': [['Gap1']],
      },
    ];
    test('asserts on invalid data', () {
      for(final data in invalidData) {
        final legendData = CraneLoadChartLegendData(
          legendJson: FakeCraneLoadChartLegendJson(data),
        );
        expect(() async {
            await legendData.limits;
            await legendData.colors;
            await legendData.names;
          }, 
          throwsA(isA<AssertionError>()),
          reason: 'Error wasn\'t thrown on invalid json.'
        );
      }
    });
  });
}