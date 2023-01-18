import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/core/relative_value.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
///
/// Круговой индикатор значения из потока [stream] <DsDataPoint<double>.
/// Значение в потоке может изменяться в диапазоне [min]...[max].
/// - Сигнализация выхода за нижнюю границу допустимого уровня, 
/// если [low] не null и при значении в [stream] меньше [low]
/// - Сигнализация выхода за верхнюю границу допустимого уровня, 
/// если [high] не null и при значении в [stream] больше [high]
class CircularValueIndicator extends StatelessWidget {
  static const _debug = false;
  static const double _valueBasis = 270 / 360;
  final RelativeValue _relativeValue;
  final Stream<DsDataPoint<num>>? _stream;
  final double _angle;
  final double? _high;
  final double? _low;
  final double _size;
  final double _scale;
  final double _strokeWidth;
  final String? _title;
  final bool _showValueText;
  final String _valueUnit;
  final int _fractionDigits;
  final Color? _lowColor;
  final Color? _highColor;
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
    double? high,
    required Stream<DsDataPoint<num>>? stream,
    required double size,
    double angle = 0,
    String? title,
    bool showValueText = true,
    String? valueUnit,
    int fractionDigits = 0,
    Color? lowColor,
    Color? highColor,
    // bool? disabled,
  }) : 
    _relativeValue = RelativeValue(basis: _valueBasis, min: min, max: max),
    _angle = angle - 135,
    _high = high,
    _low = low,
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
    // _disabled = disabled ?? false,
    super(key: key);
  ///
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
                color: Theme.of(context).backgroundColor, 
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
        String valueText = '';
        Color color = Theme.of(context).stateColors.on;
        final lowColor = _lowColor ?? Theme.of(context).stateColors.lowLevel;
        final highColor = _highColor ?? Theme.of(context).stateColors.highLevel;
        final invalidValueColor = Theme.of(context).stateColors.invalid;
        if (snapshot.hasError) {
          color = invalidValueColor;
          log(CircularValueIndicator._debug, '[$CircularValueIndicator.build] error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final dataPoint = snapshot.data;
          log(CircularValueIndicator._debug, '[$CircularValueIndicator.build] dataPoint: $dataPoint');
          if (dataPoint != null) {
            final _nValue = dataPoint.value;
            log(CircularValueIndicator._debug, '[$CircularValueIndicator.build] dataPoint: $_nValue');
            value = _relativeValue.relative(_nValue.toDouble(), limit: true);
            log(CircularValueIndicator._debug, '[$CircularValueIndicator.build] dataPoint: $dataPoint');
            valueText = _nValue.toStringAsFixed(_fractionDigits);
          }
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildIndicatorValueText(context, _scale, value, valueText),
            _buildIndicatorValueUnitText(context, _scale, _valueUnit),
            _buildLowIndicatorWidget(context, value, _strokeWidth * 0.7, lowColor),
            _buildHighIndicatorWidget(context, value, _strokeWidth * 0.7, highColor),
            _buildIndicatorWidget(
              value: value, 
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
  /// проверяет относительное значение с уставкой аварийного нижнего уровня в о.е
  bool _isLow(double value) {
    final low = _low;
    if (low != null) {
      // final lowRelative = _k * low + _b;
      return value <= _relativeValue.relative(low);
    }
    return false;  
  }
  ///
  /// проверяет относительное значение с уставкой аварийного верхнего уровня в о.е
  bool _isHigh(double value) {
    final high = _high;
    if (high != null) {
      // final highRelative = _k * high + _b;
      return value >= _relativeValue.relative(high);
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
      final textStyle = Theme.of(context).textTheme.bodySmall ?? TextStyle();
      return Positioned(
        bottom: 0.18 * _size,
        child: Text(valueUnit,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: textStyle.color!.withOpacity(0.7),
          ),
          textScaleFactor: 0.8 * 0.0168 * _size,
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
      final textStyle = Theme.of(context).textTheme.bodySmall ?? TextStyle();
      return Positioned(
        top: (_valueUnit.isNotEmpty ? 0.19 : 0.25) * _size,
        child: RepaintBoundary(
          key: UniqueKey(),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            textAlign: TextAlign.center,
            style: _isLow(value) 
                ? textStyle.copyWith(color: _lowColor, fontWeight: FontWeight.w700,) 
                : _isHigh(value) 
                  ? textStyle.copyWith(color: _highColor, fontWeight: FontWeight.w700,) 
                  : textStyle,
            child: Text(valueText,
              textAlign: TextAlign.center,
              textScaleFactor: 1.5 * 0.01618 * _size,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildLowIndicatorWidget(
    BuildContext context, double value, double strokeWidth,
    Color lowColor,
  ) {
    if (_low != null) {
      final size = _size * 0.85;
      return SizedBox(
          width: size,
          height: size,
        child: _buildIndicatorWidget(
          value: _relativeValue.relative(_low),
          strokeWidth: strokeWidth,
          angle: _angle,
          color: _isLow(value) ? lowColor : lowColor.withOpacity(0.3), 
        ),
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildHighIndicatorWidget(
    BuildContext context, double value, double strokeWidth,
    Color highColor,
  ) {
    if (_high != null) {
      final size = _size * 0.85;
      final highRelative = _relativeValue.relative(_high);
      return SizedBox(
        width: size,
        height: size,
        child: _buildIndicatorWidget(
          value: _valueBasis - highRelative,
          strokeWidth: strokeWidth,
          angle: (_angle) + 360 * highRelative,
          color: _isHigh(value) ? highColor : highColor.withOpacity(0.3), 
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
