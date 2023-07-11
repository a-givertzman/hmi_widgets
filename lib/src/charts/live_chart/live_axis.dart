import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class LiveAxis {
  final Stream<DsDataPoint<double>> stream;
  final String signalName;
  final String caption;
  final Color color;
  final double thickness;
  final double dotRadius;
  final int bufferLength;
  final double? curveSmoothness;
  bool showDots;
  bool isVisible;
  ///
  LiveAxis({
    required this.stream,
    required this.signalName,
    required this.caption,
    required this.color,
    this.thickness = 2,
    this.dotRadius = 2,
    this.bufferLength = 300,
    this.showDots = false,
    this.isVisible = true,
    this.curveSmoothness,
  });
}