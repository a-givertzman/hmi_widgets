import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
  final bool _spreadBetween;
  ///
  const StatusIndicatorWidget({
    Key? key,
    required Widget indicator,
    Widget? caption,
    Alignment alignment = Alignment.centerLeft,
    double? width,
    double? height,
    bool disabled = false, 
    bool spreadBetween = false,
  }) : 
    _spreadBetween = spreadBetween, 
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
            padding: EdgeInsets.all(
              const Setting('padding').toDouble,
            ),
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
    final padding = const Setting('padding').toDouble;
    final mainAxisSize = _spreadBetween ? MainAxisSize.max : MainAxisSize.min;
    final inbetweenSpace = _spreadBetween ? Expanded(
        child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: padding)
          ),
      ) 
      : SizedBox(width: padding); 
    if (alignment == Alignment.centerLeft) {
      return Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          indicator,
          if (caption != null) ...[
            inbetweenSpace,
            caption,
          ],
        ],
      );
    }
    if (alignment == Alignment.centerRight) {
      return Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (caption != null) ...[
            caption,
            inbetweenSpace,
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
