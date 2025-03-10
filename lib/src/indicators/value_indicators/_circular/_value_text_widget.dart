part of '../circular_value_indicator.dart';
///
class _ValueTextWidget extends StatelessWidget {
  final bool _isUnitShown;
  final double _size;
  final bool _showValueText;
  final TextStyle? _style;
  final String _valueText;
  ///
  const _ValueTextWidget({
    required bool isUnitShown,
    required double size,
    required bool showValueText,
    required String valueText,
    TextStyle? style,
  }) :
    _valueText = valueText,
    _style = style,
    _showValueText = showValueText,
    _size = size,
    _isUnitShown = isUnitShown;
  //
  @override
  Widget build(BuildContext context) {
    if (_showValueText) {
      final textStyle = _style ?? Theme.of(context).textTheme.bodySmall ?? const TextStyle();
      return Positioned(
        top: (_isUnitShown ? 0.19 : 0.25) * _size,
        child: RepaintBoundary(
          key: UniqueKey(),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: textStyle,
            child: Text(_valueText,
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.5 * 0.01618 * _size),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}