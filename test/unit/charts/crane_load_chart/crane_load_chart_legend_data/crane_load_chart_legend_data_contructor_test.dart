import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';

void main() {
  group('CraneLoadChartLegendData constructor', () {
    const validData = [
      {
        'limits': [0.0],
        'colors': [Colors.blue],
        'names': ['Gap1'],
      },
      {
        'limits': [0.0, 1.3],
        'colors': [Colors.blue, Colors.black],
        'names': ['Gap1', 'Gap2'],
      },
      {
        'limits': [0.0, 1.3, 10.1],
        'colors': [Colors.blue, Colors.black, Colors.lime],
        'names': ['Gap1', 'Gap2', 'Gap3'],
      },
      {
        'limits': [13.6, 15.2, 20.1, 40.5],
        'colors': [Colors.blue, Colors.black, Colors.lime, Colors.orange],
        'names': ['Gap1', 'Gap2', 'Gap3', 'Gap4'],
      },
    ];
    const invalidData = [
      {
        'limits': <double>[],
        'colors': [Colors.blue],
        'names': ['Gap1'],
      },
      {
        'limits': [0.0],
        'colors': <Color>[],
        'names': ['Gap1'],
      },
      {
        'limits': [0.0],
        'colors': [Colors.blue],
        'names': <String>[],
      },
      {
        'limits': [0.0, 1.3],
        'colors': [Colors.blue, Colors.black, Colors.lime, Colors.orange],
        'names': ['Gap1', 'Gap2', 'Gap3'],
      },
      {
        'limits': [13.6, 15.2, 20.1],
        'colors': [Colors.blue, Colors.black, Colors.lime, Colors.orange],
        'names': ['Gap1'],
      },
    ];
    test('completes normally on valid data', () {
      for(final data in validData) {
        expect(() => CraneLoadChartLegendData(
          limits: data['limits'] as List<double>, 
          colors: data['colors'] as List<Color>,
          names: data['names'] as List<String>,
          ), 
          returnsNormally,
        );
      }
    });
    test('asserts on invalid data', () {
      for(final data in invalidData) {
        expect(() => CraneLoadChartLegendData(
          limits: data['limits'] as List<double>, 
          colors: data['colors'] as List<Color>,
          names: data['names'] as List<String>,
          ), 
          throwsA(isA<AssertionError>()),
        );
      }
    });
  });
  
}