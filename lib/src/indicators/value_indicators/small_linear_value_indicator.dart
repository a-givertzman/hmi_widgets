import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
import 'pointer_progress_indicator.dart';
import 'text_value_indicator.dart';
///
enum IndicationStyle {
  bar,
  pointer,
}
///
class SmallLinearValueIndicator extends StatelessWidget {
  final Widget? _caption;
  final String _valueUnit;
  final double _textIndicatorWidth;
  final double _min;
  final double _max;
  final double? _high;
  final double? _low;
  final Stream<DsDataPoint<num>> _stream;
  final IndicationStyle _indicationStyle;
  final Color? _defaultColor;
  final Color? _alarmColor;
  ///
  const SmallLinearValueIndicator({
    super.key,
    required Stream<DsDataPoint<num>> stream,
    required double max,
    double min = 0.0,
    double? high,
    double? low,
    Widget? caption,
    String valueUnit = '',
    double textIndicatorWidth = 55, 
    IndicationStyle indicationStyle = IndicationStyle.pointer,
    Color? defaultColor,
    Color? alarmColor,
  }) : _indicationStyle = indicationStyle, 
    _stream = stream,
    _min = min,
    _max = max,
    _high = high,
    _low = low,
    _caption = caption,
    _valueUnit = valueUnit,
    _textIndicatorWidth = textIndicatorWidth,
    _defaultColor = defaultColor,
    _alarmColor = alarmColor;
  //
  @override
  Widget build(BuildContext context) {
    final delta = (_max - _min).abs();
    final caption = _caption;
    final padding = const Setting('padding').toDouble;
    final smallPadding = const Setting('smallPadding').toDouble;
    final theme = Theme.of(context);
    final alarmColor = _alarmColor ?? theme.stateColors.alarm;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: smallPadding, 
          horizontal: padding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(caption != null)
              ...[
                caption, 
                SizedBox(height: smallPadding),
              ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: StreamBuilder<DsDataPoint<num>>(
                    stream: _stream,
                    builder:(context, snapshot) {
                      final indicatorHeight = smallPadding * 3;
                      final snapshotValue = min(
                        max(
                          snapshot.data?.value.toDouble() ?? _min,
                          _min,
                        ), 
                        _max,
                      );
                      final percantage = (snapshotValue - _min) / delta;
                      final isAlarm = _isAlarm(snapshotValue);
                      switch(_indicationStyle) {
                        case IndicationStyle.bar:
                          return LinearProgressIndicator(
                            value: percantage,
                            minHeight: indicatorHeight,
                            color: isAlarm ? alarmColor : _defaultColor,
                          );
                        case IndicationStyle.pointer:
                          return PointerProgressIndicator(
                            value: percantage,
                            minHeight: indicatorHeight,
                            color: isAlarm ? alarmColor : _defaultColor,
                          );
                      }
                    },
                  ),
                ),
                SizedBox(width: smallPadding),
                SizedBox(
                  width: _textIndicatorWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      TextValueIndicator(
                        stream: _stream,
                        valueUnit: _valueUnit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isAlarm(double currentValue) {
    final low = _low;
    final high = _high;
    final isAlarmLow = low != null && currentValue <= low;
    final isAlarmHigh = high != null && currentValue >= high;
    return isAlarmLow || isAlarmHigh;
  }
}
