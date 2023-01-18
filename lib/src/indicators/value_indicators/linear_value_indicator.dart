import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/core/relative_value.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';

///
/// Линейный индикатор значения из потока [stream] <DsDataPoint<double>.
/// Значение в потоке может изменяться в диапазоне [min]...[max].
/// - Сигнализация выхода за нижнюю границу допустимого уровня, 
/// если [low] не null и при значении в [stream] меньше [low]
/// - Сигнализация выхода за верхнюю границу допустимого уровня, 
/// если [high] не null и при значении в [stream] больше [high]
class LinearValueIndicator extends StatelessWidget {
  static const _debug = true;
  static const double _valueBasis = 1;
  final RelativeValue _relativeValue;
  final Stream<DsDataPoint<double>> _stream;
  final double _angle;
  final double? _low;
  final double? _alarmLow;
  final double? _high;
  final double? _alarmHigh;
  final bool? _onTheCard;
  final double _cardPadding;
  static const _cardEdge = 4.0;
  final double _indicatorLength;
  final double _minWidth = 0;
  final double? _width;
  final double? _height;
  final String? _title;
  final int _fractionDigits;
  final Color? _lowColor;
  final Color? _alarmLowColor;
  final Color? _highColor;
  final Color? _alarmHighColor;
  final double _strokeWidth;
  ///
  LinearValueIndicator({
    Key? key,
    double min = 0,
    double max = 100,
    double? low,
    double? alarmLow,
    double? high,
    double? alarmHigh,
    required Stream<DsDataPoint<double>> stream,
    required double indicatorLength,
    required double strokeWidth,
    double? angle,
    double? width,
    double? height,
    String? title,
    bool showValueText = true,
    String valueUnit = '',
    int fractionDigits = 0,
    Color? lowColor,
    Color? alarmLowColor,
    Color? highColor,
    Color? alarmHighColor,
    bool? onTheCard,
    double? cardPadding,
  }) : 
    _stream = stream,
    _relativeValue = RelativeValue(basis: _valueBasis, min: min, max: max),
    _low = low,
    _alarmLow = alarmLow,
    _high = high,
    _alarmHigh = alarmHigh,
    _title = title,
    _fractionDigits = fractionDigits,
    _angle = angle ?? 0.0,
    _lowColor = lowColor,
    _alarmLowColor = alarmLowColor,
    _highColor = highColor,
    _alarmHighColor = alarmHighColor,
    _indicatorLength = indicatorLength,
    _strokeWidth = strokeWidth,
    _width = width,
    _height = height,
    _onTheCard = onTheCard,
    _cardPadding = cardPadding ?? 8.0,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    double value = 0;
    String valueText = '';
    final title = _title;
    final lowColor = _lowColor ?? Theme.of(context).stateColors.lowLevel;
    final alarmLowColor = _alarmLowColor ?? Theme.of(context).stateColors.alarmLowLevel;
    final highColor = _highColor ?? Theme.of(context).stateColors.highLevel;
    final alarmHighColor = _alarmHighColor ?? Theme.of(context).stateColors.alarmHighLevel;
    final titleTextStyle = Theme.of(context).textTheme.bodySmall;
    final valueTextStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final titleFontSize = _buildTitleFontSize(titleTextStyle);
    final width = _width ?? _buildWidth(_cardEdge, _cardPadding, _angle, _indicatorLength, _minWidth, _strokeWidth);
    final height = _height ?? _buildHeight(_cardEdge, _cardPadding, titleFontSize, _angle, _indicatorLength, _strokeWidth);
    final textBoxWidth = _boxWidth(_angle, _indicatorLength - _cardPadding * 2, _minWidth) + _boxHeight(_angle, _strokeWidth, 0);
    final textBoxHeight = _cardEdge * 2 + titleFontSize;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null) FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(title, style: titleTextStyle),
        ),
        StreamBuilder<DsDataPoint<double>>(
          stream: _stream,
          builder: (context, snapshot) {
            // TODO color behavior depanding on dataPoint.status to be implemented
            Color color = Theme.of(context).stateColors.on;
            if (snapshot.hasError) {
              color = Theme.of(context).stateColors.invalid;
              log(LinearValueIndicator._debug, '[$LinearValueIndicator.build] error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final dataPoint = snapshot.data;
              // log(LinearBarIndicatorV1._debug, '[$LinearBarIndicatorV1.build] dataPoint: $dataPoint');
              if (dataPoint != null) {
                final _nValue = dataPoint.value; 
                value = _relativeValue.relative(_nValue);  // _k * _nValue + _b;
                valueText = _nValue.toStringAsFixed(_fractionDigits);
              }
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  // alignment: Alignment.topCenter,
                  width: width,
                  height: height,
                  child: (_onTheCard ?? false) ? Card() : null,
                ),
                _buildIndicatorWidget(
                  value: _valueBasis, 
                  strokeWidth: _strokeWidth,
                  angle: _angle,
                  color: Theme.of(context).backgroundColor, 
                ),
                ..._buildValueWidgets(
                  context, 
                  Size(textBoxWidth, textBoxHeight), 
                  value, 
                  valueText,
                  color, 
                  lowColor, 
                  alarmLowColor, 
                  highColor,
                  alarmHighColor,
                  valueTextStyle,
                ),
              ],
            );
          },
        ),
      ],
    );  
  }
  ///
  List<Widget> _buildValueWidgets(
    BuildContext context, 
    Size textBoxSize,
    double value, 
    String valueText,
    Color? color,
    Color lowColor, 
    Color alarmLowColor, 
    Color highColor,
    Color alarmHighColor,
    valueTextStyle,
  ) {
    return [
        _buildValueTextBox(valueText, textBoxSize.width, textBoxSize.height, _cardPadding, valueTextStyle, value, lowColor, alarmLowColor, highColor, alarmHighColor),
        // _buildIndicatorValueText(context, _scale, _valueText, lowColor, highColor),
        // _buildIndicatorValueUnitText(context, _scale, _valueUnit),
        // _buildLowDiscreteIndicatorWidget(context, value, _low, _strokeWidth, lowColor),
        _buildLowIndicatorWidget(context, value, _low, _strokeWidth, lowColor),
        if (_alarmLow != null)
          _buildIndicatorWidget(value: _relativeValue.relative(_alarmLow), angle: _angle, color: Theme.of(context).backgroundColor, strokeWidth: _strokeWidth * 0.3, x: _strokeWidth * 0.7, backgroundColor: Colors.transparent),
        _buildLowIndicatorWidget(context, value, _alarmLow, _strokeWidth, alarmLowColor),
        _buildHighIndicatorWidget(context, value, _high, _strokeWidth, highColor),
        if (_alarmHigh != null)
          _buildIndicatorWidget(value: _valueBasis - _relativeValue.relative(_alarmHigh), angle: _angle + 180, color: Theme.of(context).backgroundColor, strokeWidth: _strokeWidth * 0.3, x: _strokeWidth * 0.7, backgroundColor: Colors.transparent),
        _buildHighIndicatorWidget(context, value, _alarmHigh, _strokeWidth, alarmHighColor),
        _buildIndicatorWidget(
          value: value, 
          angle: _angle,
          color: color, 
          strokeWidth: _strokeWidth, 
        ),
      ];
  }
  ///
  Widget _buildValueTextBox(String text, double width, double height, double padding, TextStyle textStyle, double value, Color lowColor, Color alarmLowColor, Color highColor, Color alarmHighColor) {
    final txt = text;
    if (txt.isNotEmpty) {
      return Positioned(
        width: width,
        height: height,
        top: padding,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: _buildValueTextStyle(value, textStyle, lowColor, alarmLowColor, highColor, alarmHighColor),
              textAlign: TextAlign.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
  ///
  TextStyle _buildValueTextStyle(double value, TextStyle textStyle, Color lowColor, Color alarmLowColor, Color highColor, Color alarmHighColor) {
    if (_isLow(value, _alarmLow)) {
      return textStyle.copyWith(color: alarmLowColor, fontWeight: FontWeight.w700,);
    }
    if (_isHigh(value, _alarmHigh)) {
      return textStyle.copyWith(color: alarmHighColor, fontWeight: FontWeight.w700,);
    }
    if (_isLow(value, _low)) {
      return textStyle.copyWith(color: lowColor, fontWeight: FontWeight.w700,);
    }
    if (_isHigh(value, _high)) {
      return textStyle.copyWith(color: highColor, fontWeight: FontWeight.w700,);
    }
    return textStyle;
  }
  ///
  double _buildTitleFontSize(TextStyle? style) {
    final fontStyle = style;
    if (fontStyle != null) {
      return fontStyle.fontSize ?? 14.0;
    }
    return 14.0;
  }
  ///
  /// проверяет относительное значение с уставкой аварийного нижнего уровня в о.е
  bool _isLow(double value, double? low) {
    // final low = _low;
    if (low != null) {
      // final lowRelative = _k * low + _b;
      return value <= _relativeValue.relative(low);
    }
    return false;  
  }
  ///
  /// проверяет относительное значение с уставкой аварийного верхнего уровня в о.е
  bool _isHigh(double value, double? high) {
    // final high = _high;
    if (high != null) {
      // final highRelative = _k * high + _b;
      return value >= _relativeValue.relative(high);
    }
    return false;
  }
  ///
  Widget _buildLowIndicatorWidget(
    BuildContext context, double value, double? low, double strokeWidth, Color lowColor,
  ) {
    // final low = _low;
    if (low != null) {
    // log(_debug, '[$LinearBarIndicatorV1._buildLowIndicatorWidget] strokeWidth: $strokeWidth');
      return _buildIndicatorWidget(
        value: _relativeValue.relative(low),
        strokeWidth: strokeWidth * 0.3,
        x: strokeWidth * 0.7,
        angle: _angle,
        color: _isLow(value, low) ? lowColor : lowColor.withOpacity(0.4), 
        backgroundColor: Colors.transparent,
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildHighIndicatorWidget(
    BuildContext context, double value, double? high, double strokeWidth, Color highColor,
  ) {
    // final high = _high;
    if (high != null) {
      final highRelative = _relativeValue.relative(high);
      return _buildIndicatorWidget(
        value: _valueBasis - highRelative,
        strokeWidth: strokeWidth * 0.3,
        x: strokeWidth * 0.7,
        angle: _angle + 180,
        color: _isHigh(value, high) ? highColor : highColor.withOpacity(0.4), 
        backgroundColor: Colors.transparent,
      );
    }
    return const SizedBox.shrink();
  }
  ///
  Widget _buildIndicatorWidget({
    required double value, 
    required double strokeWidth,
    double x = 0,
    required double angle,
    Color? color, 
    Color? backgroundColor,
  }) {
    return Positioned(
      bottom: -_cardPadding + _cardEdge - (strokeWidth - _cardPadding)/2 + _boxWidth(angle, strokeWidth + _cardPadding * 2, 0)/2 + _boxHeight(angle, _indicatorLength, 0)/2,
      child: SizedBox(
        width: _indicatorLength - _cardPadding * 2,
        child: Transform.translate(
          offset: Offset(x, 0),
          child: Transform.rotate(
            transformHitTests: false,
            angle: - _deg2Ran(angle),
            child: LinearProgressIndicator(
              value: value,
              minHeight: strokeWidth,
              color: color,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
  ///
  double _buildWidth(double edge, double padding, double angle, double length, double minWidth, double strokeWidth) {
    return edge * 2 + padding * 2 + _boxWidth(angle, length - padding * 2, minWidth) + _boxHeight(angle, strokeWidth, 0);
  }
  ///
  double _buildHeight(double edge, double padding, double fontSize, double angle, double length, double strokeWidth) {
    return edge * 2 + fontSize + padding + _boxWidth(angle, strokeWidth + padding * 2, 0) + _boxHeight(angle, length, 0);
  }
  //
  /// Converting degrees to radioans
  double _deg2Ran(double deg) => deg / (180 / pi);
  ///
  /// Calculating box width depending on diagonal length and angle in degrees
  /// if minW != null then if calculated height less then minW, minW will be returned instead
  double _boxWidth(double angle, double l, double minW) {
    final value = (l * cos(_deg2Ran(angle))).abs();
    // log(_debug, '[$LinearBarIndicatorV1._boxWidth] boxWidth: $value');
    return value < minW ? minW : value; // 20 your min height
  }
  ///
  /// Calculating box height depending on diagonal length and angle in degrees.
  /// if minH != null then if calculated height less then minH, minH will be returned instead
  double _boxHeight(double angle, double l, double minH) {
    final value = (l * sin(_deg2Ran(angle))).abs();
    // log(_debug, '[$LinearBarIndicatorV1._boxHeight] boxHeight: $value');
    return value < minH ? minH : value; // 20 your min height
  }
}
