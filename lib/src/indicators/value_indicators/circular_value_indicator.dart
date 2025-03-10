import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_relative_value.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
part '_circular/_value_text_widget.dart';
part '_circular/_unit_text_widget.dart';
part '_circular/_sector_indicator_widget.dart';
part '_circular/_sized_indicator_widget.dart';
part '_circular/_circular_indicator_stream_builder.dart';
///
/// Круговой индикатор значения из потока [stream] <DsDataPoint<double>.
/// Значение в потоке может изменяться в диапазоне [min]...[max].
/// - Сигнализация выхода за нижнюю границу допустимого уровня, 
/// если [low] не null и при значении в [stream] меньше [low]
/// - Сигнализация выхода за верхнюю границу допустимого уровня, 
/// если [high] не null и при значении в [stream] больше [high]
class CircularValueIndicator extends StatelessWidget {
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
    _strokeWidth = 0.12 * (size / 1.618),
    _title = title,
    _showValueText = showValueText,
    _valueUnit = valueUnit ?? '',
    _fractionDigits = fractionDigits,
    _lowColor = lowColor,
    _highColor = highColor,
    _criticalColor = criticalColor,
    _critical2Color = critical2Color,
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
        ),
        Padding(
          padding: EdgeInsets.all(_strokeWidth * 0.5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _SizedIndicatorWidget(
                value: _valueBasis,
                strokeWidth: _strokeWidth,
                angle: _angle,
                color: Theme.of(context).colorScheme.surface, 
                size: _size,
              ),
              _CircularIndicatorStreamBuilder(
                low: _low,
                lowEnd: _lowEnd,
                high: _high,
                highEnd: _highEnd,
                lowCritical: _lowCritical,
                lowCriticalEnd: _lowCriticalEnd,
                highCritical: _highCritical,
                highCriticalEnd: _highCriticalEnd,
                lowCritical2: _lowCritical2,
                lowCritical2End: _lowCritical2End,
                highCritical2: _highCritical2,
                highCritical2End: _highCritical2End,
                stream: _stream,
                size: _size,
                angle: _angle,
                showValueText: _showValueText,
                valueUnit: _valueUnit,
                fractionDigits: _fractionDigits,
                lowColor: _lowColor,
                highColor: _highColor,
                criticalColor: _criticalColor,
                critical2Color: _critical2Color,
                strokeWidth: _strokeWidth,
                relativeValue: _relativeValue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}