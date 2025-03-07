part of '../text_value_indicator.dart';
///
class _ValueTextWidget extends StatelessWidget {
  final num _value;
  final int _fractionDigits;
  final TextStyle? _valueStyle;
  final TextStyle? _unitStyle;
  final Color? _color;
  final String _valueUnit;
  ///
  const _ValueTextWidget({
    required num value,
    required int fractionDigits,
    TextStyle? valueStyle,
    TextStyle? unitStyle,
    Color? color,
    required String valueUnit,
  }) :
    _valueUnit = valueUnit,
    _color = color, _unitStyle = unitStyle,
    _valueStyle = valueStyle,
    _fractionDigits = fractionDigits,
    _value = value;
  //
  @override
  Widget build(BuildContext context) {
    final valueTextStyle = _valueStyle ?? Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final unitTextStyle = _unitStyle ?? Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _value.toStringAsFixed(_fractionDigits),
          style: valueTextStyle.apply(color: _color),
          textScaler: TextScaler.linear(1.3),
        ),
        if(_valueUnit.isNotEmpty)
          ...[
            const SizedBox(width: 3),
            Text(
              _valueUnit,
              style: unitTextStyle.apply(color: _color),
              textScaler: TextScaler.linear(1.3),
            ),
          ],
      ],
    );
  }
}