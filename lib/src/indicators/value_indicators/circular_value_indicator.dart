import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_relative_value.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
///
/// Круговой индикатор значения из потока [stream] <DsDataPoint<double>.
/// Значение в потоке может изменяться в диапазоне [min]...[max].
/// - Сигнализация выхода за нижнюю границу допустимого уровня, 
/// если [low] не null и при значении в [stream] меньше [low]
/// - Сигнализация выхода за верхнюю границу допустимого уровня, 
/// если [high] не null и при значении в [stream] больше [high]
class CircularValueIndicator extends StatelessWidget {
  static const _log = Log('CircularValueIndicator');
  static const double _valueBasis = 270 / 360;
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
  final double _scale;
  final double _strokeWidth;
  final String? _title;
  final bool _showValueText;
  final String _valueUnit;
  final int _fractionDigits;
  final Color? _lowColor;
  final Color? _highColor;
  final Color? _criticalColor;
  final Color? _critical2Color;
  // final bool _disabled;
  /// 
  /// Builds home body using current user
  /// [min] - минимальное значение входного сигнала
  /// [max] - максимальное значение входного сигнала
  /// [low] - аварино низкое значение
  /// [high] - аварино высокое значение
  CircularValueIndicator({
    Key? key,
    double min = 0,
    double max = 100,
    double? low,
    double? lowEnd,
    double? high,
    double? highEnd,
    double? lowCritical,
    double? lowCriticalEnd,
    double? highCritical,
    double? highCriticalEnd,
    double? lowCritical2,
    double? lowCritical2End,
    double? highCritical2,
    double? highCritical2End,
    required Stream<DsDataPoint<num>>? stream,
    required double size,
    double angle = 0,
    String? title,
    bool showValueText = true,
    String? valueUnit,
    int fractionDigits = 0,
    Color? lowColor,
    Color? highColor,
    Color? criticalColor,
    Color? critical2Color,
    // bool? disabled,
  }) : 
    _relativeValue = RelativeValue(basis: _valueBasis, min: min, max: max),
    _angle = angle - 135,
    _low = low,
    _lowEnd = lowEnd ?? lowCritical ?? lowCritical2 ?? min,
    _lowCritical = lowCritical,
    _lowCriticalEnd = lowCriticalEnd ?? lowCritical2 ?? min,
    _lowCritical2 = lowCritical2,
    _lowCritical2End = lowCritical2End ?? min,
    _high = high,
    _highEnd = highEnd ?? highCritical ?? highCritical2 ?? max,
    _highCritical = highCritical,
    _highCriticalEnd = highCriticalEnd ?? highCritical2 ?? max,
    _highCritical2 = highCritical2,
    _highCritical2End = highCritical2End ?? max,
    _stream = stream,
    _size = size,
    _scale = size / 1.618,
    _strokeWidth = 0.12 * (size / 1.618),
    _title = title,
    _showValueText = showValueText,
    _valueUnit = valueUnit ?? '',
    _fractionDigits = fractionDigits,
    _lowColor = lowColor,
    _highColor = highColor,
    _criticalColor = criticalColor,
    _critical2Color = critical2Color,
    // _disabled = disabled ?? false,
    assert(
      lowEnd == null || (low != null && lowEnd < low),
      "lowEnd must be less than low",
    ),
    assert(
      lowCriticalEnd == null || (lowCritical != null && lowCriticalEnd < lowCritical),
      "lowCriticalEnd must be less than lowCritical",
    ),
    assert(
      lowCritical2End == null || (lowCritical2 != null && lowCritical2End < lowCritical2),
      "lowCritical2End must be less than lowCritical2",
    ),
    assert(
      highEnd == null || (high != null && highEnd > high),
      "highEnd must be greater than high",
    ),
    assert(
      highCriticalEnd == null || (highCritical != null && highCriticalEnd > highCritical),
      "highCriticalEnd must be greater than highCritical",
    ),
    assert(
      highCritical2End == null || (highCritical2 != null && highCritical2End > highCritical2),
      "highCritical2End must be greater than highCritical2",
    ),
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    // log(CircularBarIndicator._debug, '[$CircularBarIndicator.build]');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title != null) Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: (_title != null) 
            ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('$_title'),
            )
            : null,
          // child: Text('$_title',
          //   textScaleFactor: 0.4 * _scale,
          // ),
        ),
        Padding(
          padding: EdgeInsets.all(_strokeWidth * 0.5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildIndicatorWidget(
                value: _valueBasis, 
                strokeWidth: _strokeWidth,
                angle: _angle,
                color: Theme.of(context).colorScheme.surface, 
              ),
              valueBuilder(context, _stream),
            ],
          ),
        ),
      ],
    );
  }
  ///
  Widget valueBuilder(BuildContext context, Stream<DsDataPoint<num>>? dataStream) {
    return StreamBuilder<DsDataPoint<num>>(
      stream: dataStream,
      builder: (context, snapshot) {
        // log(CircularBarIndicator._debug, '[$CircularBarIndicator.build] data: ${snapshot.data}');
        double value = 0;
        double clampedValue = 0;
        String valueText = '';
        Color color = Theme.of(context).colorScheme.tertiaryFixedDim;
        final lowColor = _lowColor ?? Theme.of(context).alarmColors.class4;
        final highColor = _highColor ?? Theme.of(context).alarmColors.class4;
        final criticalColor = _criticalColor ?? Theme.of(context).alarmColors.class3;
        final critical2Color = _critical2Color ?? Theme.of(context).alarmColors.class1;
        final invalidValueColor = Theme.of(context).stateColors.invalid;
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
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildIndicatorValueText(context, _scale, value, valueText),
            _buildIndicatorValueUnitText(context, _scale, _valueUnit),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isLessOrEqual(value, _low)
                ? lowColor
                : lowColor.withValues(alpha: 0.3),
              ending: _low,
              beginning: _lowEnd,
            ),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isLessOrEqual(value, _lowCritical)
                ? criticalColor
                : criticalColor.withValues(alpha: 0.3),
              ending: _lowCritical,
              beginning: _lowCriticalEnd,
              padding: _low != null ? 1 : 0,
            ),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isLessOrEqual(value, _lowCritical2)
                ? critical2Color
                : critical2Color.withValues(alpha: 0.3),
              ending: _lowCritical2,
              beginning: _lowCritical2End,
              padding: (_low != null || _lowCritical != null) ? 1 : 0,
            ),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isGreaterOrEqual(value, _high)
                ? highColor
                : highColor.withValues(alpha: 0.3),
              ending: _highEnd,
              beginning: _high,
              padding: (_highCritical != null || _highCritical2 != null) ? 1 : 0,
            ),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isGreaterOrEqual(value, _highCritical)
                ? criticalColor
                : criticalColor.withValues(alpha: 0.3),
              ending: _highCriticalEnd,
              beginning: _highCritical,
              padding: _highCritical2 != null ? 1 : 0,
            ),
            _buildSectorIndicatorWidget(
              value,
              _strokeWidth * 0.7,
              _isGreaterOrEqual(value, _highCritical2) 
                ? critical2Color
                : critical2Color.withValues(alpha: 0.3),
              ending: _highCritical2End,
              beginning: _highCritical2,
            ),
            _buildIndicatorWidget(
              value: clampedValue, 
              angle: _angle,
              color: color, 
              strokeWidth: _strokeWidth, 
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
  ///
  Widget _buildIndicatorValueUnitText(
    BuildContext context, 
    double scale, 
    String valueUnit,
  ) {
    if (_showValueText) {
      final textStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
      return Positioned(
        bottom: 0.18 * _size,
        child: Text(valueUnit,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: textStyle.color!.withValues(alpha: 0.7),
          ),
          textScaler: TextScaler.linear(0.8 * 0.0168 * _size),
        ),
      );
    }
    return const SizedBox();
  }
  ///
  Widget _buildIndicatorValueText(
    BuildContext context, 
    double scale, 
    double value,
    String valueText,
  ) {
    if (_showValueText) {
      final textStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
      return Positioned(
        top: (_valueUnit.isNotEmpty ? 0.19 : 0.25) * _size,
        child: RepaintBoundary(
          key: UniqueKey(),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: _isGreaterOrEqual(value, _highCritical2) || _isLessOrEqual(value, _lowCritical2)
              ? textStyle.copyWith(color: _critical2Color, fontWeight: FontWeight.w700,) 
              : _isGreaterOrEqual(value, _highCritical) || _isLessOrEqual(value, _lowCritical)
                ? textStyle.copyWith(color: _criticalColor, fontWeight: FontWeight.w700,) 
                : _isLessOrEqual(value, _low) 
                  ? textStyle.copyWith(color: _lowColor, fontWeight: FontWeight.w700,)
                  : _isGreaterOrEqual(value, _high) 
                    ? textStyle.copyWith(color: _highColor, fontWeight: FontWeight.w700,)
                    : textStyle,
            child: Text(valueText,
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(1.5 * 0.01618 * _size),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildSectorIndicatorWidget(
    double value,
    double strokeWidth,
    Color color, {
    double? beginning,
    double? ending,
    double? padding,
  }) {
    if (ending != null && beginning != null) {
      final size = _size * 0.85;
      final endingRelative = _relativeValue.relative(ending);
      final beginningRelative = _relativeValue.relative(beginning);
      final paddingRelative = _relativeValue.relative(padding);
      return SizedBox(
          width: size,
          height: size,
        child: _buildIndicatorWidget(
          value: endingRelative - beginningRelative - paddingRelative,
          strokeWidth: strokeWidth,
          angle: _angle + 360 * beginningRelative,
          color: color,
        ),
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildIndicatorWidget({
    required double value, 
    required double strokeWidth,
    required double angle,
    Color? color, 
    Color? backgroundColor,
  }) {
    return Transform.rotate(
      angle: 2 * pi * angle / 360,
      child: _buildSizedIndicatorWidget(
        value: value,
        color: color,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
  ///
  Widget _buildSizedIndicatorWidget({
    required double value, 
    required double strokeWidth,
    Color? color, 
    Color? backgroundColor,
  }) {
    return RepaintBoundary(
      key: UniqueKey(),
      child: SizedBox(
        width: _size,
        height: _size,
          child: CircularProgressIndicator(
            backgroundColor: backgroundColor,
            color: color,
            value: value,
            strokeWidth: strokeWidth,
          ),
      ),
    );
  }
}
