import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/colors/alarm_colors.dart';

void main() {
  test('AlarmColors test', () {
    final colors = {
      1: const Color(0xAA000001),
      2: const Color(0xAA000002),
      3: const Color(0xAA000003),
      4: const Color(0xAA000004),
      5: const Color(0xAA000005),
      6: const Color(0xAA000006),
      7: const Color(0xAA000006),
      8: const Color(0xAA000006),
    };
    final alarmColors = AlarmColors(
      class1: colors[1]!,
      class2: colors[2]!,
      class3: colors[3]!,
      class4: colors[4]!,
      class5: colors[5]!,
      class6: colors[6]!,
      class7: colors[7]!,
      class8: colors[8]!,
    );
    expect(alarmColors, isA<AlarmColors>());
    expect(alarmColors.class1, colors[1]!);
    expect(alarmColors.class2, colors[2]!);
    expect(alarmColors.class3, colors[3]!);
    expect(alarmColors.class4, colors[4]!);
    expect(alarmColors.class5, colors[5]!);
    expect(alarmColors.class6, colors[6]!);
    expect(alarmColors.class6, colors[7]!);
    expect(alarmColors.class6, colors[8]!);
  });
}