import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';

///
class ControlButtonIndicator extends StatefulWidget {
  final Stream<DsDataPoint<num>>? _stream;
  final List<String> _stateValues;
  final String? _caption;
  final Color? _stateColor;
  final Color? _captionColor;
  ///
  const ControlButtonIndicator({
    Key? key,
      Stream<DsDataPoint<num>>? stream,
      required List<String> stateValues,
      String? caption,
      Color? stateColor,
      Color? captionColor,
  }) : 
    _stream = stream,
    _caption = caption,
    _stateValues = stateValues,
    _stateColor = stateColor,
    _captionColor = captionColor,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<ControlButtonIndicator> createState() => _ControlButtonIndicatorState(
    stream: _stream,
    stateValues: _stateValues,
    caption: _caption,
    stateColor: _stateColor,
    captionColor: _captionColor,
  );
}


///
class _ControlButtonIndicatorState extends State<ControlButtonIndicator> with TickerProviderStateMixin {
  static const _debug = false;
  final Stream<DsDataPoint<num>>? _stream;
  final List<String> _stateValues;
  final String? _caption;
  final Color? _stateColor;
  final Color? _captionColor;
  late Color _invalidValueColor;
  late AnimationController _animationController;
  static const _stateTextScaleFactor = 1.4;
  DsDataPoint<num>? _point;
  num _stateIndex = - 1;
  String _stateText = '';
  bool _isUpdated = false;
  ///
  _ControlButtonIndicatorState({
      required Stream<DsDataPoint<num>>? stream,
      required List<String> stateValues,
      String? caption,
      Color? stateColor,
      Color? captionColor,
  }) :
    _stream = stream,
    _caption = caption,
    _stateValues = stateValues,
    _stateColor = stateColor,
    _captionColor = captionColor,
    super() {
      log(_debug, '[$_ControlButtonIndicatorState]');
    }
  //
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    );
    if (!_isUpdated) {
      _animationController.forward();
    }
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    _invalidValueColor = Theme.of(context).stateColors.invalid;
    final stream = _stream;
    final caption = _caption;
    Color? color = _stateColor ?? Theme.of(context).colorScheme.onTertiary;
    final captionColor = _captionColor ?? color.withOpacity(0.7);// colorShiftLightness(color, 1.2);
    const padding = 8.0;
    final stateTextStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
    final captionTextStyle = stateTextStyle;
    return StreamBuilder<DsDataPoint<num>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          color = _invalidValueColor;
        } else if (snapshot.hasData) {
          if (snapshot.data != null && snapshot.data != _point) {
            _point = snapshot.data;
            final point = _point;
            if (point != null) {
              _stateIndex = point.value;
              _stateText = _buildStateText(_stateValues, _stateIndex);
              if (!_isUpdated) {
                _isUpdated = true;
                _animationController.reverse();
              }
              if (_stateIndex < 0) {
                _isUpdated = false;
                _animationController.forward();
              }
            }
          } else {
            log(_debug, '[$_ControlButtonIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
          }
        } else {
          log(_debug, '[$_ControlButtonIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
        }
        final fontSize = stateTextStyle.fontSize;
        final stateTextHeight = stateTextStyle.height;
        final boxHeight = stateTextHeight ?? (fontSize != null ? fontSize * 1.5 : 18);
        // log(_debug, '[$_ControlButtonIndicatorState._build] boxHeight: ', boxHeight);
        return SizedBox(
          height: boxHeight * 1.0 + padding * 2,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (caption != null) AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + (_stateTextScaleFactor - 1) * _animationController.value,
                    child: Transform.translate(
                      offset: Offset(0.0, - boxHeight * 0.7 * (1 - _animationController.value)),
                      child: Text(
                        caption,
                        style: captionTextStyle.apply(color: _isUpdated ? captionColor : color),
                      ),
                    ),
                  );
                },
              ),
              if (_isUpdated) FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  _stateText,
                  style: stateTextStyle.apply(color: color),
                  textScaler: TextScaler.linear(_stateTextScaleFactor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  ///
  String _buildStateText(List<String> stateValues, num stateIndex) {
    if (stateIndex >= 0 && stateIndex < stateValues.length) {
      return stateValues[stateIndex.toInt()];
    }
    return '';
  }
  ///
  // TextStyle _captionStyle(
  //   BuildContext context, 
  //   bool isUpdated, 
  //   TextStyle stateTextStyle,
  // ) {
  //   if (isUpdated) {
  //     return Theme.of(context).textTheme.caption ?? const TextStyle(fontSize: 10);
  //   } else {
  //     return stateTextStyle;
  //   }
  // }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
