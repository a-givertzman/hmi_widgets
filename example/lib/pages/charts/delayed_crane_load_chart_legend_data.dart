import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class DelayedCraneLoadChartLegendData extends CraneLoadChartLegendData {
  final Duration _delay;
  ///
  DelayedCraneLoadChartLegendData({
    required super.legendJson, 
    Duration delay = const Duration(milliseconds: 500),
  }) : _delay = delay;
  //
  @override
  Future<Iterable<Iterable<double>>> get limits => Future.delayed(
    _delay,
    () => super.limits,
  );
  //
  @override
  Future<Iterable<Iterable<String>>> get names => Future.delayed(
    _delay,
    () => super.names,
  );
  //
  @override
  Future<Iterable<Iterable<Color>>> get colors => Future.delayed(
    _delay,
    () => super.colors,
  );
}