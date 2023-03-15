import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

///
class XTitle extends StatelessWidget {
  final TitleMeta _meta;
  final DateTime _date;
  ///
  const XTitle({
    super.key,
    required DateTime date,
    required TitleMeta meta,
  }) : 
    _date = date,
    _meta = meta;
  //
  @override
  Widget build(BuildContext context) {
    return SideTitleWidget(
      axisSide: _meta.axisSide,
      fitInside: SideTitleFitInsideData.fromTitleMeta(
        _meta,
        distanceFromEdge: 2,
      ),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Text('${_date.hour}:${_date.minute}:${_date.second}'),
      ),
    );
  }
}