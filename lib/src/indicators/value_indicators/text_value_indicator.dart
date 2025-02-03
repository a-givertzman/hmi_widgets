import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
///
/// Simple text field, indicates state of streamed [DsDataPoint] value, 
class TextValueIndicator extends StatefulWidget {
  final Stream<DsDataPoint<num>>? _stream;
  final int _fractionDigits;
  final String _valueUnit;
  final double? _high;
  final double? _low;
  ///
  const TextValueIndicator({
      Key? key,
      Stream<DsDataPoint<num>>? stream,
      int fractionDigits = 0,
      String valueUnit = '',
      double? high,
      double? low,
  }) : 
    _stream = stream,
    _fractionDigits = fractionDigits,
    _valueUnit = valueUnit,
    _high = high,
    _low = low,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<TextValueIndicator> createState() => _TextValueIndicatorState(
      stream: _stream,
      fractionDigits: _fractionDigits,
      valueUnit: _valueUnit,
      high: _high,
      low: _low,
  );
}
///
class _TextValueIndicatorState extends State<TextValueIndicator> {
  static const _log = Log('_TextValueIndicatorState');
  final Stream<DsDataPoint<num>>? _stream;
  final int _fractionDigits;
  final String _valueUnit;
  final double? _low;
  final double? _high;
  late TextStyle _textStyle;
  late TextStyle _unitTextStyle;
  late StateColors _stateColors;
  num _value = 0;
  ///
  _TextValueIndicatorState({
    required Stream<DsDataPoint<num>>? stream,
    required int fractionDigits,
    required String valueUnit,
    double? high,
    double? low,
  }) :
    _stream = stream,
    _fractionDigits = fractionDigits,
    _valueUnit = valueUnit,
    _high = high,
    _low = low,
    super();
  //
  @override
  void initState() {
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    _stateColors = Theme.of(context).stateColors;
    _textStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    _unitTextStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    return StreamBuilder<DsDataPoint<num>>(
      initialData: DsDataPoint<num>(
        type: DsDataType.bool, name: DsPointName('/test'), value: 0.0, status: DsStatus.obsolete, cot: DsCot.inf, timestamp: '',
      ),
      stream: _stream,
      builder: (context, snapshot) {
        return _buildValueText(
          context,
          snapshot, 
        );
      },
    );
  }
  ///
  Widget _buildValueText(BuildContext context, AsyncSnapshot<DsDataPoint<num>> snapshot) {
    Color? color;
    num value = _value;
    if (snapshot.hasError) {
      color = _stateColors.invalid;
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
          value.toStringAsFixed(_fractionDigits),
          style: _textStyle.apply(color: color),
          textScaler: TextScaler.linear(1.3),
        ),
        ..._buildUnitText(_valueUnit, color),
      ],
    );
  }
  ///
  List<Widget> _buildUnitText(String valueUnit, Color? color) {
    if (valueUnit.isNotEmpty) {
      return [
        const SizedBox(width: 3,),
        Text(
          _valueUnit,
          style: _unitTextStyle.apply(color: color),
          textScaler: TextScaler.linear(1.3),
        ),
      ];
    }
    return [];
  }
  ///
  /// корректирует цвет с учетом проверки нижнего и верхнего аврийных уровней
  Color? _buildColor(Color? color, num value) {
    if (_isHigh()) {
      return _stateColors.highLevel;
    }
    if (_isLow()) {
      return _stateColors.lowLevel;
    }
    return color;
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного нижнего уровня
  bool _isLow() {
    final low = _low;
    if (low != null) {
      return _value <= low;
    }
    return false;  
  }
  ///
  /// проверяет абсолютное значение с уставкой аварийного верхнего уровня
  bool _isHigh() {
    final high = _high;
    if (high != null) {
      return _value >= high;
    }
    return false;  
  }
}
