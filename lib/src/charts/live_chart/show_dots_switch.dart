import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

import 'live_axis.dart';

///
class ShowDotsSwitch extends StatelessWidget {
  final double _legendWidth;
  final List<LiveAxis> _axesData;
  ///
  const ShowDotsSwitch({
    super.key,
    required double legendWidth,
    required List<LiveAxis> axes,
  }) : 
    _legendWidth = legendWidth, 
    _axesData = axes;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return SizedBox(
      width: _legendWidth,
      child: Card(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: const Text(
                "Show dots",
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            const Spacer(),
            Switch(
              activeColor: Theme.of(context).colorScheme.primary,
              value: _axesData.every((axisData) => axisData.showDots), 
              onChanged: (showDots) {
                for (final axisData in _axesData) {
                  axisData.showDots = showDots;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
