import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
/// Показывает прямоугольник с индикатором и надпись
/// Положение надписи можно определить в параметре [textPosition]
class TextIndicatorWidget extends StatelessWidget {
  final Widget _indicator;
  final Widget _caption;
  final Alignment _alignment;
  final double? _width;
  final double? _height;
  ///
  const TextIndicatorWidget({
    Key? key,
    required Widget indicator,
    required Widget caption,
    required Alignment alignment,
    double? width,
    double? height,
  }) : 
    _indicator = indicator,
    _caption = caption,
    _alignment = alignment,
    _width = width,
    _height = height,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: SizedBox(
          width: _width,
          height: _height,
          child: _buildWidget(
            context,
            _indicator,
            _caption,
          ),
        ),
      ),
    );
  }
  Widget _buildWidget(BuildContext context, Widget indicator, Widget caption) {
    // top alignment
    if (_alignment == Alignment.topLeft) {
      return _buildWidgetALignmentTopLeft();
    }
    if (_alignment == Alignment.topCenter) {
      return _buildWidgetALignmentTopCenter();
    }
    if (_alignment == Alignment.topRight) {
      return _buildWidgetALignmentTopRight();
    }
    // center alignment
    if (_alignment == Alignment.centerLeft) {
      return _buildWidgetALignmentCenterLeft();
    }
    if (_alignment == Alignment.centerRight) {
      return _buildWidgetALignmentCenterRight();
    }
    // bottom alignment
    if (_alignment == Alignment.bottomLeft) {
      return _buildWidgetALignmentBottomLeft();
    }
    if (_alignment == Alignment.bottomCenter) {
      return _buildWidgetALignmentBottomCenter();
    }
    if (_alignment == Alignment.bottomRight) {
      return _buildWidgetALignmentBottomRight();
    }
    throw Failure.unexpected(
      message: 'Ошибка в методе _buildWidget класса $TextIndicatorWidget:\n unsupported alignment: $_alignment',
      stackTrace: StackTrace.current,
    );
  }
  ///
  Column _buildWidgetALignmentBottomRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _indicator,
        const SizedBox(height: 3.0,),
        _caption,
      ],
    );
  }
  ///
  Column _buildWidgetALignmentBottomCenter() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _indicator,
        const SizedBox(height: 3.0,),
        _caption,
      ],
    );
  }
  ///
  Column _buildWidgetALignmentBottomLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _indicator,
        const SizedBox(height: 3.0,),
        _caption,
      ],
    );
  }
  ///
  Row _buildWidgetALignmentCenterRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _caption,
        const SizedBox(width: 3.0,),
        _indicator,
      ],
    );
  }
  ///
  Row _buildWidgetALignmentCenterLeft() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _caption,
        const SizedBox(width: 3.0,),
        _indicator,
      ],
    );
  }
  ///
  Column _buildWidgetALignmentTopRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _caption,
        const SizedBox(height: 3.0,),
        _indicator,
      ],
    );
  }
  ///
  Column _buildWidgetALignmentTopCenter() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _caption,
        const SizedBox(height: 3.0,),
        _indicator,
      ],
    );
  }
  ///
  Column _buildWidgetALignmentTopLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _caption,
        const SizedBox(height: 3.0,),
        _indicator,
      ],
    );
  }
}
