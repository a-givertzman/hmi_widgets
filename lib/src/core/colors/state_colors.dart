import 'package:flutter/material.dart';
///
/// Colors indicating the state of a UI element or data point
class StateColors {
  /// 
  /// Used for indication of application or infrastructure error.
  final Color error;
  ///
  /// Used for indication of `DsDataPoint` with non-zero Alarm Class.
  final Color alarm;
  ///
  /// Used for indication of DsDataPoint with obsolete Status.
  final Color obsolete;
  ///
  /// Used for indication of DsDataPoint with invalid Status.
  final Color invalid;
  ///
  /// Used for indication of DsDataPoint with timeInvalid Status.
  final Color timeInvalid;
  ///
  /// Used for indication of low metric values.
  final Color lowLevel;
  ///
  /// Used for indication of abnormally low metric values.
  final Color alarmLowLevel;
  ///
  /// Used for indication of high metric values.
  final Color highLevel;
  ///
  /// Used for indication of abnormally high metric values.
  final Color alarmHighLevel;
  ///
  /// Used for indication that something is turned off.
  final Color off;
  /// Used for indication that something is turned on.
  final Color on;
  ///
  /// - [error] - Used for indication of application or infrastructure error.
  /// - [alarm] - Used for indication of `DsDataPoint` with non-zero Alarm Class.
  /// - [obsolete] - Used for indication of DsDataPoint with obsolete Status.
  /// - [invalid] - Used for indication of DsDataPoint with invalid Status.
  /// - [timeInvalid] - Used for indication of DsDataPoint with timeInvalid Status.
  /// - [lowLevel] - Used for indication of low metric values.
  /// - [alarmLowLevel] - Used for indication of abnormally low metric values.
  /// - [highLevel] - Used for indication of high metric values.
  /// - [alarmHighLevel] - Used for indication of abnormally high metric values.
  /// - [off] - Used for indication that something is turned off.
  /// - [on] - Used for indication that something is turned on.
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