import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
part '_text/_value_text_widget.dart';
///
/// Simple text field, indicates state of streamed [DsDataPoint] value, 
class TextValueIndicator extends StatefulWidget {
  final Stream<DsDataPoint<num>>? _stream;
  final int _fractionDigits;
  final String _valueUnit;
  final double? _high;
  final double? _low;
  final double? _lowCritical;
  final double? _highCritical;
  final double? _lowCritical2;
  final double? _highCritical2;
  final TextStyle? _valueStyle;
  final TextStyle? _unitStyle;
  final Color? _highColor;
  final Color? _lowColor;
  final Color? _criticalColor;
  final Color? _critical2Color;

  ///
  const TextValueIndicator({
    Key? key,
    Stream<DsDataPoint<num>>? stream,
    int fractionDigits = 0,
    String valueUnit = '',
    double? high,
    double? low,
    double? lowCritical,
    double? highCritical,
    double? lowCritical2,
    double? highCritical2,
    TextStyle? valueStyle,
    TextStyle? unitStyle,
    Color? highColor,
    Color? lowColor,
    Color? criticalColor,
    Color? critical2Color,
  }) : 
    _stream = stream,
    _fractionDigits = fractionDigits,
    _valueUnit = valueUnit,
    _high = high,
    _low = low,
    _highCritical = highCritical,
    _lowCritical = lowCritical,
    _highCritical2 = highCritical2,
    _lowCritical2 = lowCritical2,
    _valueStyle = valueStyle,
    _unitStyle = unitStyle,
    _highColor = highColor,
    _lowColor = lowColor,
    _criticalColor = criticalColor,
    _critical2Color = critical2Color,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<TextValueIndicator> createState() => _TextValueIndicatorState();
}
///
class _TextValueIndicatorState extends State<TextValueIndicator> {
  static const _log = Log('_TextValueIndicatorState');
  late num _value;
  //
  @override
  void initState() {
    _value = 0;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DsDataPoint<num>>(
      initialData: DsDataPoint<num>(
        type: DsDataType.bool, name: DsPointName('/test'), value: 0.0, status: DsStatus.obsolete, cot: DsCot.inf, timestamp: '',
      ),
      stream: widget._stream,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        Color? color;
        num value = _value;
        if (snapshot.hasError) {
          color = theme.stateColors.invalid;
          _log.debug('[._buildValueText] snapshot.error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final point = snapshot.data;
          if (point != null) {
            value = point.value;
            _value = value;
            color = _buildColor(color, value);
          } else {
            _log.debug('[._build] snapshot.connectionState: ${snapshot.connectionState}');
          }
        } else {
          _log.debug('[._build] snapshot.connectionState: ${snapshot.connectionState}');
        }
        return _ValueTextWidget(
          value: value,
          fractionDigits: widget._fractionDigits,
          valueUnit: widget._valueUnit,
          valueStyle: widget._valueStyle,
          unitStyle: widget._unitStyle,
          color: color,
        );
      },
    );
  }
  ///
  /// корректирует цвет с учетом проверки нижнего и верхнего аврийных уровней
  Color? _buildColor(Color? defaultColor, num value) {
    if (_isGreaterOrEqual(value, widget._highCritical2)) {
      return widget._critical2Color;
    }
    if (_isGreaterOrEqual(value, widget._highCritical)) {
      return widget._criticalColor;
    }
    if (_isGreaterOrEqual(value, widget._high)) {
      return widget._highColor;
    }
    if (_isLessOrEqual(value, widget._lowCritical2)) {
      return widget._critical2Color;
    }
    if (_isLessOrEqual(value, widget._lowCritical)) {
      return widget._criticalColor;
    }
    if (_isLessOrEqual(value, widget._low)) {
      return widget._lowColor;
    }
    return defaultColor;
  }
  ///
  /// проверяет значение с уставкой аварийного нижнего уровня
  bool _isLessOrEqual(num value, num? threshold) {
    if (threshold != null) {
      return value <= threshold;
    }
    return false;
  }
  ///
  /// проверяет значение с уставкой аварийного верхнего уровня
  bool _isGreaterOrEqual(num value, num? threshold) {
    if (threshold != null) {
      return value >= threshold;
    }
    return false;
  }
}