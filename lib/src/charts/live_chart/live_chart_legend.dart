import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'live_axis.dart';

///
class LiveChartLegend extends StatelessWidget {
  final double _legendWidth;
  final List<LiveAxis> _axes;
  ///
  const LiveChartLegend({
    super.key,
    required double legendWidth,
    required List<LiveAxis> axes,
  }) : 
    _legendWidth = legendWidth, 
    _axes = axes;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding', factor: 0.5).toDouble;
    return SizedBox(
      width: _legendWidth,
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final axisData in _axes)
            Padding(
              padding: EdgeInsets.symmetric(vertical: padding * 0.5),
              child: Container(
                color: axisData.color.withOpacity(0.5),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: padding),
                      child: Text(
                            axisData.caption,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      activeColor: Theme.of(context).colorScheme.primary,
                      value: axisData.isVisible, 
                      onChanged: (isVisible) {
                        axisData.isVisible = isVisible!;
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}