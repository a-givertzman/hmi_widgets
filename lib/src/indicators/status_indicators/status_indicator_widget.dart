import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/core/color_filters.dart';

///
/// Показывает прямоугольник с индикатором и надпись
/// Положение надписи можно определить в параметре [textPosition]
class StatusIndicatorWidget extends StatelessWidget {
  final Widget _indicator;
  final Widget? _caption;
  final Alignment _alignment;
  final double? _width;
  final double? _height;
  final bool _disabled;
  ///
  const StatusIndicatorWidget({
    Key? key,
    required Widget indicator,
    Widget? caption,
    Alignment alignment = Alignment.centerLeft,
    double? width,
    double? height,
    bool disabled = false,
  }) : 
    _indicator = indicator,
    _caption = caption,
    _alignment = alignment,
    _width = width,
    _height = height,
    _disabled = disabled,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: ColorFiltered(
        colorFilter: ColorFilters.disabled(context, _disabled),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: _buildIndicatorWidget(
              _indicator, 
              _caption, 
              _alignment,
            ),
          ),
        ),
      ),
    );
  }
  ///
  Widget _buildIndicatorWidget(Widget indicator, Widget? caption, Alignment alignment) {
    if (alignment == Alignment.centerLeft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          indicator,
          if (caption != null) ...[
            const SizedBox(width: 7.0,),
            caption,
          ],
        ],
      );
    }
    if (alignment == Alignment.centerRight) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (caption != null) ...[
            caption,
            const SizedBox(width: 7.0,),
          ],
          indicator,
        ],
      );
    }
    if (alignment == Alignment.center) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (_width != null && _height != null)
            SizedBox(
              width: _width,
              height: _height,
              child: FittedBox(child: indicator),
            )
          else
            indicator,
          if (caption != null) caption,
        ],
      );
    }
    throw Failure.unexpected(
      message: 'Ошибка в методе _buildIndicatorWidget класса $StatusIndicatorWidget:\n unsupported alignment: $_alignment',
      stackTrace: StackTrace.current,
    );    
  }
}
