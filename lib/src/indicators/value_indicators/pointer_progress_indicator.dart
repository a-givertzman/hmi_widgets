import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class PointerProgressIndicator extends StatelessWidget {
  final double _value;
  final double _indicatorHeight;
  final double _pointerWidth;
  final double _horizontalLineWidth;
  ///
  const PointerProgressIndicator({
    super.key,
    double value = 0,
    required double indicatorHeight,
    double pointerWidth = 4, 
    double horizontalLineWidth = 0.25,
  }) : 
    _value = value, 
    _indicatorHeight = indicatorHeight, 
    _pointerWidth = pointerWidth, 
    _horizontalLineWidth = horizontalLineWidth;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onBackground;
    final blockedColor = theme.stateColors.alarmLowLevel;
    final currentColor = (_value == 0 || _value == 1) ? blockedColor : defaultColor;
    return SizedBox(
      height: _indicatorHeight,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: _horizontalLineWidth,
                color: currentColor,
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, contraints) {
              final leftOffset = (contraints.maxWidth - _pointerWidth) * _value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: leftOffset),
                  Container(
                    width: _pointerWidth,
                    decoration:  BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(_pointerWidth/2),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}