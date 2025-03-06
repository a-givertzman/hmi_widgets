part of '../circular_value_indicator.dart';
///
class _CircularIndicatorStreamBuilder extends StatelessWidget {
  static const _log = Log('_CircularIndicatorStreamBuilder');
  final RelativeValue _relativeValue;
  final Stream<DsDataPoint<num>>? _stream;
  final double _angle;
  final double? _high;
  final double _highEnd;
  final double? _low;
  final double _lowEnd;
  final double? _highCritical;
  final double _highCriticalEnd;
  final double? _lowCritical;
  final double _lowCriticalEnd;
  final double? _highCritical2;
  final double _highCritical2End;
  final double? _lowCritical2;
  final double _lowCritical2End;
  final double _size;
  final double _strokeWidth;
  final bool _showValueText;
  final String _valueUnit;
  final int _fractionDigits;
  final Color? _lowColor;
  final Color? _highColor;
  final Color? _criticalColor;
  final Color? _critical2Color;
  //
  _CircularIndicatorStreamBuilder({
    required double? low,
    required double lowEnd,
    required double? high,
    required double highEnd,
    required double? lowCritical,
    required double lowCriticalEnd,
    required double? highCritical,
    required double highCriticalEnd,
    required double? lowCritical2,
    required double lowCritical2End,
    required double? highCritical2,
    required double highCritical2End,
    required Stream<DsDataPoint<num>>? stream,
    required double size,
    required double angle,
    required bool showValueText,
    required String valueUnit,
    required int fractionDigits,
    required Color? lowColor,
    required Color? highColor,
    required Color? criticalColor,
    required Color? critical2Color,
    required double strokeWidth,
    required RelativeValue relativeValue,
  }) : 
    _relativeValue = relativeValue,
    _angle = angle,
    _low = low,
    _lowEnd = lowEnd,
    _lowCritical = lowCritical,
    _lowCriticalEnd = lowCriticalEnd,
    _lowCritical2 = lowCritical2,
    _lowCritical2End = lowCritical2End,
    _high = high,
    _highEnd = highEnd,
    _highCritical = highCritical,
    _highCriticalEnd = highCriticalEnd,
    _highCritical2 = highCritical2,
    _highCritical2End = highCritical2End,
    _stream = stream,
    _size = size,
    _strokeWidth = strokeWidth,
    _showValueText = showValueText,
    _valueUnit = valueUnit,
    _fractionDigits = fractionDigits,
    _lowColor = lowColor,
    _highColor = highColor,
    _criticalColor = criticalColor,
    _critical2Color = critical2Color;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DsDataPoint<num>>(
      stream: _stream,
      builder: (context, snapshot) {
        double value = 0;
        double clampedValue = 0;
        String valueText = '';
        final theme = Theme.of(context);
        Color color = theme.colorScheme.tertiaryFixedDim;
        final lowColor = _lowColor ?? theme.alarmColors.class4;
        final highColor = _highColor ?? theme.alarmColors.class4;
        final criticalColor = _criticalColor ?? theme.alarmColors.class3;
        final critical2Color = _critical2Color ?? theme.alarmColors.class1;
        final invalidValueColor = theme.stateColors.invalid;
        if (snapshot.hasError) {
          color = invalidValueColor;
          _log.debug('[$CircularValueIndicator.build] error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final dataPoint = snapshot.data;
          _log.debug('[$CircularValueIndicator.build] dataPoint: $dataPoint');
          if (dataPoint != null) {
            final nValue = dataPoint.value;
            _log.debug('[$CircularValueIndicator.build] dataPoint: $nValue');
            value = _relativeValue.relative(nValue.toDouble(), limit: false);
            clampedValue = _relativeValue.relative(nValue.toDouble(), limit: true);
            _log.debug('[$CircularValueIndicator.build] dataPoint: $dataPoint');
            valueText = nValue.toStringAsFixed(_fractionDigits);
          }
        }
        final defaultValueTextStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
        final valueTextStyle = _isGreaterOrEqual(value, _highCritical2) || _isLessOrEqual(value, _lowCritical2)
          ? defaultValueTextStyle.copyWith(color: _critical2Color, fontWeight: FontWeight.w700,) 
          : _isGreaterOrEqual(value, _highCritical) || _isLessOrEqual(value, _lowCritical)
            ? defaultValueTextStyle.copyWith(color: _criticalColor, fontWeight: FontWeight.w700,) 
            : _isLessOrEqual(value, _low) 
              ? defaultValueTextStyle.copyWith(color: _lowColor, fontWeight: FontWeight.w700,)
              : _isGreaterOrEqual(value, _high) 
                ? defaultValueTextStyle.copyWith(color: _highColor, fontWeight: FontWeight.w700,)
                : defaultValueTextStyle;
        return Stack(
          alignment: Alignment.center,
          children: [
            _ValueTextWidget(
              showValueText: _showValueText, 
              size: _size,
              isUnitShown: _valueUnit.isNotEmpty,
              style: valueTextStyle,
              valueText: valueText,
            ),
            _UnitTextWidget(
              showValueText: _showValueText,
              size: _size,
              unitText: _valueUnit,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isLessOrEqual(value, _low)
                ? lowColor
                : lowColor.withValues(alpha: 0.3),
              ending: _low,
              beginning: _lowEnd,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isLessOrEqual(value, _lowCritical)
                ? criticalColor
                : criticalColor.withValues(alpha: 0.3),
              ending: _lowCritical,
              beginning: _lowCriticalEnd,
              padding: _low != null ? 1 : 0,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isLessOrEqual(value, _lowCritical2)
                ? critical2Color
                : critical2Color.withValues(alpha: 0.3),
              ending: _lowCritical2,
              beginning: _lowCritical2End,
              padding: (_low != null || _lowCritical != null) ? 1 : 0,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isGreaterOrEqual(value, _high)
                ? highColor
                : highColor.withValues(alpha: 0.3),
              ending: _highEnd,
              beginning: _high,
              padding: (_highCritical != null || _highCritical2 != null) ? 1 : 0,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isGreaterOrEqual(value, _highCritical)
                ? criticalColor
                : criticalColor.withValues(alpha: 0.3),
              ending: _highCriticalEnd,
              beginning: _highCritical,
              padding: _highCritical2 != null ? 1 : 0,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SectorIndicatorWidget(
              strokeWidth: _strokeWidth * 0.7,
              color: _isGreaterOrEqual(value, _highCritical2) 
                ? critical2Color
                : critical2Color.withValues(alpha: 0.3),
              ending: _highCritical2End,
              beginning: _highCritical2,
              parentSize: _size,
              relativeValue: _relativeValue,
            ),
            _SizedIndicatorWidget(
              value: clampedValue,
              angle: _angle,
              color: color,
              strokeWidth: _strokeWidth,
              size: _size,
            ),
          ],
        );
      },
    );
  }
  ///
  bool _isLessOrEqual(double value, double? threshold) {
    if (threshold != null) {
      return value <= _relativeValue.relative(threshold);
    }
    return false;
  }
  ///
  bool _isGreaterOrEqual(double value, double? threshold) {
    if (threshold != null) {
      return value >= _relativeValue.relative(threshold);
    }
    return false;
  }
}