import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/core/ds_data_stream_extract/ds_data_stream_extract.dart';

void main() {
  const stateColors = StateColors(
    alarm: Color(0x00000000),
    error: Color(0x00000001), 
    obsolete: Color(0x00000002), 
    invalid: Color(0x00000003), 
    timeInvalid: Color(0x00000004), 
    lowLevel: Color(0x00000005), 
    alarmLowLevel: Color(0x00000006), 
    highLevel: Color(0x00000007),
    alarmHighLevel: Color(0x00000008),
    off: Color(0x00000009), 
    on: Color(0x00000010),
  );
  final pointsData = [
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: DsDps.off.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.off,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: DsDps.on.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.on,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: DsDps.transient.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.error,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: DsDps.undefined.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.invalid,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: 32767, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.invalid,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: 32767, status: DsStatus.obsolete, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.obsolete,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: 32767, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.invalid,
    },
    {
      'point': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test'), value: 32767, status: DsStatus.timeInvalid, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
      'color': stateColors.timeInvalid,
    },
  ];
  test('DsDataStreamExtract buildColors', () async {
    final controller = StreamController<DsDataPoint<int>>();
    final dsDataStreamExtract = DsDataStreamExtract<int>(
      stream: controller.stream,
      stateColors: stateColors,
    );
    for (final item in pointsData) {
      final point = item['point'] as DsDataPoint<int>;
      controller.add(point);
      final receivedExtractedPoint = await dsDataStreamExtract.stream.first;
      expect(receivedExtractedPoint.color, item['color'] as Color, reason: 'Wrong color for point:\n\t$point!\n\tExpected ${item['color']}, but received ${receivedExtractedPoint.color}');
      expect(receivedExtractedPoint.value, point.value, reason: 'Wrong value! Was changed from ${receivedExtractedPoint.value} to ${point.value}');
      expect(receivedExtractedPoint.status, point.status, reason: 'Wrong status! Was changed from ${receivedExtractedPoint.status} to ${point.status}');
    }
  });
  test('DsDataStreamExtract single stream ordering & consistensy', () async {
    final dsDataStreamExtract = DsDataStreamExtract(
      stream: Stream.fromIterable(
        pointsData.map(
          (entry) => entry['point'] as DsDataPoint,
        ),
      ),
      stateColors: stateColors,
    );
    final receivedExtractedPoints = await dsDataStreamExtract.stream
      .timeout(
        const Duration(milliseconds: 10),
        onTimeout: (sink) => sink.close(),
      )
      .toList();
    for (int i = 0; i < pointsData.length; i++) {
      final pointData = pointsData[i];
      final point = pointData['point'] as DsDataPoint;
      final color = pointData['color'] as Color;
      expect(receivedExtractedPoints[i].color, color, reason: 'Wrong color for point:\n\t$point!\n\tExpected $color, but received ${receivedExtractedPoints[i].color}');
      expect(receivedExtractedPoints[i].value, point.value, reason: 'Wrong value! Was changed from ${receivedExtractedPoints[i].value} to ${point.value}');
      expect(receivedExtractedPoints[i].status, point.status, reason: 'Wrong status! Was changed from ${receivedExtractedPoints[i].status} to ${point.status}');
    }
  });
}