import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_data.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';

import 'converter_data.dart';
import '../fake_swl_data.dart';

void main() {
  test('SwlDataConverter conversion ordering', () async {
    for(int i = 0; i < converterData.length; i++) {
      final inputPoint = converterData[i]['input_point'] as Offset;
      final inputSwls = converterData[i]['swl'] as List<double>;
      final expectedPoint = converterData[i]['output_point'] as Offset;
      final expectedColors = converterData[i]['color'] as List<Color>;
      final swlDataConverter = SwlDataConverter(
        swlData: FakeSwlData(
          x: [inputPoint.dx],
          y: [inputPoint.dy],
          swl: inputSwls.map((swl) => [swl]).toList(),
        ), 
        rawHeight: height, 
        height: height, 
        rawWidth: width, 
        width: width,
        legendData: CraneLoadChartLegendData(
          limits: limitSet,
          colors: colorSet,
          names: nameSet,
        ),
      );
      final convertedPoints = await swlDataConverter.points;
      final convertedColors = await swlDataConverter.swlColors;
      expect(
        convertedPoints[0].dx.toStringAsFixed(10), 
        expectedPoint.dx.toStringAsFixed(10),
        reason: 'Wrong X coordinate. Received point: ${convertedPoints[0]}. Expected point: $expectedPoint'
      );
      expect(
        convertedPoints[0].dy.toStringAsFixed(10), 
        expectedPoint.dy.toStringAsFixed(10),
        reason: 'Wrong Y coordinate. Received point: ${convertedPoints[0]}. Expected point: $expectedPoint'
      );
      expect(
        convertedColors, expectedColors.map((color) => [color]).toList(),
        reason: 'Wrong colors for swls: $inputSwls',
      );
    }
  });
}