import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
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
  final Stream<DsDataPoint<num>> _stream;
  final IndicationStyle _indicationStyle;
  ///
  const SmallLinearValueIndicator({
    super.key,
    required Stream<DsDataPoint<num>> stream,
    required double max,
    double min = 0.0,
    Widget? caption,
    String valueUnit = '',
    double textIndicatorWidth = 55, 
    IndicationStyle indicationStyle = IndicationStyle.pointer,
  }) : _indicationStyle = indicationStyle, 
    _stream = stream,
    _min = min,
    _max = max,
    _caption = caption,
    _valueUnit = valueUnit,
    _textIndicatorWidth = textIndicatorWidth;
  //
  @override
  Widget build(BuildContext context) {
    final delta = (_max - _min).abs();
    final caption = _caption;
    final padding = const Setting('padding').toDouble;
    final smallPadding = const Setting('smallPadding').toDouble;
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
                      final snapshotValue = snapshot.data?.value.toDouble();
                      final value = snapshotValue == null 
                        ? 0.0 
                        : (max(snapshotValue, _min) - _min) / delta;
                      switch(_indicationStyle) {
                        case IndicationStyle.bar:
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: indicatorHeight,
                            color: Theme.of(context).stateColors.on,
                          );
                        case IndicationStyle.pointer:
                          return PointerProgressIndicator(
                            value: value,
                            minHeight: indicatorHeight,
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
}
