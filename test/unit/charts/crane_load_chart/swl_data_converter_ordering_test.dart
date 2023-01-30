import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_converter.dart';

import 'converter_data.dart';
import 'fake_swl_data.dart';

void main() {
  test('SwlDataConverter conversion ordering', () async {
    final swlCount = (converterData[0]['swl'] as List<double>).length;
    // final swlDataConverter = SwlDataConverter(
    //   swlData: FakeSwlData(
    //     x: converterData
    //         .map((e) => e['input_point'] as Offset)
    //         .map((offset) => offset.dx)
    //         .toList(),
    //     y: converterData
    //         .map((e) => e['input_point'] as Offset)
    //         .map((offset) => offset.dy)
    //         .toList(),
    //     swl: converterData
    //           .map((e) => e['swl'] as List<double>)
    //           .fold(
    //             List.generate(swlCount, (index) => <double>[]), 
    //             (swls, swlInPoint) {
    //               for(int i = 0; i < swlInPoint.length; i++) {
    //                 swls[i].add(swlInPoint[i]);
    //               }
    //               return swls;
    //             },
    //           ),
    //   ),
    //   rawHeight: height, 
    //   height: height, 
    //   rawWidth: width, 
    //   width: width, 
    //   swlLimitSet: limitSet, 
    //   swlColorSet: colorSet,
    // );
    // final convertedPoints = await swlDataConverter.points;
    // final convertedColors = await swlDataConverter.swlColors;
    print(swlCount);
    for(int i = 0; i < converterData.length; i++) {
      final inputPoint = converterData[i]['input_point'] as Offset;
      final inputSwl = converterData[i]['swl'] as List<double>;
      final expectedPoint = converterData[i]['output_point'] as Offset;
      final expectedColors = converterData[i]['color'] as List<Color>;

      final swlDataConverter = SwlDataConverter(
        swlData: FakeSwlData(
          x: [inputPoint.dx],
          y: [inputPoint.dy],
          swl: inputSwl.map((swl) => [swl]).toList(),
        ), 
        rawHeight: height, 
        height: height, 
        rawWidth: width, 
        width: width, 
        swlLimitSet: limitSet, 
        swlColorSet: colorSet,
      );
      final convertedPoints = await swlDataConverter.points;
      final convertedColors = await swlDataConverter.swlColors;
      expect(convertedPoints[0], expectedPoint);
      print(inputSwl);
      expect(convertedColors, expectedColors.map((color) => [color]).toList());
    }
  });
}