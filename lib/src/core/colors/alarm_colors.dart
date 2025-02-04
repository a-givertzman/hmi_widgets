import 'package:flutter/material.dart';
///
/// Colors indicating the presence or severity of a failure.
class AlarmColors {
  ///
  /// Failure, malfunction that doesn't allow continued operation, automatic or emergency shutdown.
  final Color class1;
  ///
  /// Failure, dangerous, critical deviation from the norm, when mechanisms remain operational, but require urgent load reduction or shutdown.
  final Color class2;
  ///
  /// Failure, significant deviation from the norm, when the mechanisms remain operational, but require attention or shutdown.
  final Color class3;
  ///
  /// Failure, minor deviation from the norm, when the mechanisms remain operational, but require attention.
  final Color class4;
  ///
  /// Failure, defined by user.
  final Color class5;
  ///
  /// Failure, defined by user.
  final Color class6;
  ///
  /// Failure, defined by user.
  final Color class7;
  ///
  /// Failure, defined by user.
  final Color class8;
  ///
  /// - [class1] - Failure, malfunction that doesn't allow continued operation, automatic or emergency shutdown.
  /// - [class2] - Failure, dangerous, critical deviation from the norm, when mechanisms remain operational, but require urgent load reduction or shutdown.
  /// - [class3] - Failure, significant deviation from the norm, when the mechanisms remain operational, but require attention or shutdown.
  /// - [class4] - Failure, minor deviation from the norm, when the mechanisms remain operational, but require attention.
  /// - [class5] - Failure, defined by user.
  /// - [class6] - Failure, defined by user.
  /// - [class7] - Failure, defined by user.
  /// - [class8] - Failure, defined by user.
  const AlarmColors({
    required this.class1,
    required this.class2, 
    required this.class3, 
    required this.class4, 
    required this.class5,
    required this.class6,
    required this.class7,
    required this.class8,
  });
}