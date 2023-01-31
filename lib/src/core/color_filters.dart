import 'package:flutter/material.dart';

class ColorFilters {
  static ColorFilter disabled(BuildContext context, bool disabled) {
    return ColorFilter.mode(
      Theme.of(context).colorScheme.background.withOpacity(0.7),
      disabled ? BlendMode.darken : BlendMode.dst,
    );
  }
}