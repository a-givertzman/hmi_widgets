import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
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
        return _buildValueText(
          theme.textTheme,
          snapshot,
          invalidColor: theme.stateColors.invalid,
        );
      },
    );
  }
  ///
  Widget _buildValueText(
    TextTheme textTheme,
    AsyncSnapshot<DsDataPoint<num>> snapshot, {
    Color? invalidColor,
  }) {
    Color? color;
    num value = _value;
    if (snapshot.hasError) {
      color = invalidColor;
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value.toStringAsFixed(widget._fractionDigits),
          style: widget._valueStyle?.apply(color: color)
            ?? textTheme.bodyLarge
            ?? const TextStyle(),
          textScaler: TextScaler.linear(1.3),
        ),
        ..._buildUnitText(textTheme, widget._valueUnit, color),
      ],
    );
  }
  ///
  List<Widget> _buildUnitText(TextTheme textTheme, String valueUnit, Color? color) {
    if (valueUnit.isNotEmpty) {
      return [
        const SizedBox(width: 3,),
        Text(
          widget._valueUnit,
          style: widget._unitStyle?.apply(color: color)
            ?? textTheme.bodySmall
            ?? const TextStyle(),
          textScaler: TextScaler.linear(1.3),
        ),
      ];
    }
    return [];
  }
  ///
  /// корректирует цвет с учетом проверки нижнего и верхнего аврийных уровней
  Color? _buildColor(Color? defaultColor, num value) {
    if (_isHigh()) {
      return widget._highColor;
    }
    if (_isHighCritical()) {
      return widget._criticalColor;
    }
    if (_isHighCritical2()) {
      return widget._critical2Color;
    }
    if (_isLow()) {
      return widget._lowColor;
    }
    if (_isLowCritical()) {
      return widget._criticalColor;
    }
    if (_isLowCritical2()) {
      return widget._critical2Color;
    }
    return defaultColor;
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного нижнего уровня
  bool _isLow() {
    final low = widget._low;
    if (low != null) {
      final lowCritical = widget._lowCritical;
      final rightCondition = lowCritical == null ? true : _value > lowCritical;
      return _value <= low && rightCondition;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного нижнего уровня
  bool _isLowCritical() {
    final lowCritical = widget._lowCritical;
    if (lowCritical != null) {
      final lowCritical2 = widget._lowCritical2;
      final rightCondition = lowCritical2 == null ? true : _value > lowCritical2;
      return _value <= lowCritical && rightCondition;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного нижнего уровня
  bool _isLowCritical2() {
    final lowCritical2 = widget._lowCritical2;
    if (lowCritical2 != null) {
      return _value <= lowCritical2;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного верхнего уровня
  bool _isHigh() {
    final high = widget._high;
    if (high != null) {
      final highCritical = widget._highCritical;
      final rightCondition = highCritical == null ? true : _value < highCritical;
      return _value >= high && rightCondition;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного верхнего уровня
  bool _isHighCritical() {
    final highCritical = widget._highCritical;
    if (highCritical != null) {
      final highCritical2 = widget._highCritical2;
      final rightCondition = highCritical2 == null ? true : _value < highCritical2;
      return _value >= highCritical && rightCondition;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного верхнего уровня
  bool _isHighCritical2() {
    final highCritical2 = widget._highCritical2;
    if (highCritical2 != null) {
      return _value >= highCritical2;
    }
    return false;  
  }
}
