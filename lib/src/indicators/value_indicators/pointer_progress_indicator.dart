import 'package:flutter/material.dart';
///
class PointerProgressIndicator extends StatelessWidget {
  final double _value;
  final double _minHeight;
  final double _pointerThickness;
  final double _scaleLineThickness;
  final Color? _color;
  ///
  const PointerProgressIndicator({
    super.key,
    required double minHeight,
    double value = 0,
    Color? color,
    double pointerThickness = 4, 
    double scaleLineThickness = 0.25,
  }) : 
    _value = value,
    _color = color,
    _minHeight = minHeight, 
    _pointerThickness = pointerThickness, 
    _scaleLineThickness = scaleLineThickness;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onSurface;
    final currentColor = _color ?? defaultColor;
    return SizedBox(
      height: _minHeight,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: _scaleLineThickness,
                color: currentColor,
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, contraints) {
              final leftOffset = (contraints.maxWidth - _pointerThickness) * _value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: leftOffset),
                  Container(
                    width: _pointerThickness,
                    decoration:  BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(_pointerThickness/2),
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