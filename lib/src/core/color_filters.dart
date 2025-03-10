import 'package:flutter/material.dart';
///
class ColorFilters {
  ///
  static ColorFilter disabled(BuildContext context, bool disabled) {
    return ColorFilter.mode(
      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
      disabled ? BlendMode.darken : BlendMode.dst,
    );
  }
}