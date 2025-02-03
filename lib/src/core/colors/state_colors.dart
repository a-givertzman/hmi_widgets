import 'package:flutter/material.dart';
///
class StateColors {
  final Color error;
  final Color alarm;
  final Color obsolete;
  final Color invalid;
  final Color timeInvalid;
  final Color lowLevel;
  final Color alarmLowLevel;
  final Color highLevel;
  final Color alarmHighLevel;
  final Color off;
  final Color on;
  ///
  const StateColors({
    required this.error,
    required this.alarm,
    required this.obsolete, 
    required this.invalid, 
    required this.timeInvalid, 
    required this.lowLevel,
    required this.alarmLowLevel,
    required this.highLevel,
    required this.alarmHighLevel,
    required this.off, 
    required this.on,
  });
}