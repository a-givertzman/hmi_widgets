import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

///
class YTitle extends StatelessWidget {
  final TitleMeta _meta;
  final double _value;
  ///
  const YTitle({
    super.key,
    required double value,
    required TitleMeta meta,
  }) : 
    _value = value,
    _meta = meta;
  //
  @override
  Widget build(BuildContext context) {
    return SideTitleWidget(
      axisSide: _meta.axisSide,
      child: Container(
        color: Theme.of(context).cardColor,
        child: Text(_value.toStringAsFixed(1)),
      ),
    );
  }
}