import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

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
  ///
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
  static const _debug = true;
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
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    _stateColors = Theme.of(context).stateColors;
    _textStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    _unitTextStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
    return StreamBuilder<DsDataPoint<num>>(
      initialData: DsDataPoint<num>(
        type: DsDataType.bool, path: '', name: '', value: 0.0, status: DsStatus.obsolete, timestamp: '',
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
      log(_debug, '[$_TextValueIndicatorState._buildValueText] snapshot.error: ', snapshot.error);
    } else if (snapshot.hasData) {
      final point = snapshot.data;
      if (point != null) {
        value = point.value;
        _value = value;
        color = _buildColor(color, value);
      } else {
        log(_debug, '[$_TextValueIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
      }
    } else {
      log(_debug, '[$_TextValueIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value.toStringAsFixed(_fractionDigits),
          style: _textStyle.apply(color: color),
          textScaleFactor: 1.5,
        ),
        ..._buildUnitText(_valueUnit, color),
      ],
    );
  }
  List<Widget> _buildUnitText(String valueUnit, Color? color) {
    if (valueUnit.isNotEmpty) {
      return [
        const SizedBox(width: 3,),
        Text(
          _valueUnit,
          style: _unitTextStyle.apply(color: color),
          textScaleFactor: 1.5,
        ),
      ];
    }
    return [];
  }
  ///
  /// ???????????????????????? ???????? ?? ???????????? ???????????????? ?????????????? ?? ???????????????? ???????????????? ??????????????
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
  /// ?????????????????? ???????????????????? ???????????????? ?? ???????????????? ???????????????????? ?????????????? ????????????
  bool _isLow() {
    final low = _low;
    if (low != null) {
      return _value <= low;
    }
    return false;  
  }
  ///
  /// ?????????????????? ???????????????????? ???????????????? ?? ???????????????? ???????????????????? ???????????????? ????????????
  bool _isHigh() {
    final high = _high;
    if (high != null) {
      return _value >= high;
    }
    return false;  
  }
}
