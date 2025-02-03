import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';

void main() {
  test('StateColors test', () {
    final colors = {
      'alarm': const Color(0xAA000000),
      'error': const Color(0xAA000001),
      'obsolete': const Color(0xAA000002),
      'invalid': const Color(0xAA000003),
      'timeInvalid': const Color(0xAA000004),
      'lowLevel': const Color(0xAA000005),
      'alarmLowLevel': const Color(0xAA000006),
      'highLevel': const Color(0xAA000007),
      'alarmHighLevel': const Color(0xAA000008),
      'off': const Color(0xAA000009),
      'on': const Color(0xAA000010),
    };
    final stateColors = StateColors(
      error: colors['error']!,
      alarm: colors['alarm']!,
      obsolete: colors['obsolete']!,
      invalid: colors['invalid']!,
      timeInvalid: colors['timeInvalid']!,
      lowLevel: colors['lowLevel']!,
      alarmLowLevel: colors['alarmLowLevel']!,
      highLevel: colors['highLevel']!,
      alarmHighLevel: colors['alarmHighLevel']!,
      off: colors['off']!,
      on: colors['on']!,
    );
    expect(stateColors, isA<StateColors>());
    expect(stateColors.error, colors['error']!);
    expect(stateColors.alarm, colors['alarm']!); 
    expect(stateColors.obsolete, colors['obsolete']!);
    expect(stateColors.invalid, colors['invalid']!);
    expect(stateColors.timeInvalid, colors['timeInvalid']!);
    expect(stateColors.lowLevel, colors['lowLevel']!);
    expect(stateColors.alarmLowLevel, colors['alarmLowLevel']!);
    expect(stateColors.highLevel, colors['highLevel']!);
    expect(stateColors.alarmHighLevel, colors['alarmHighLevel']!);
    expect(stateColors.off, colors['off']!);
    expect(stateColors.on, colors['on']!);
  });
}