import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class DsDataPointExtracted<T> {
  final T value;
  final DsStatus status;
  final Color color;
  ///
  const DsDataPointExtracted({
    required this.value,
    required this.status,
    required this.color,
  });
}