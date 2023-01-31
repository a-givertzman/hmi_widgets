import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
///
/// Simple icon, indicates state of streamed boolean 
/// [DsDataPoint] value position by colored circle, 
/// if icon provided, then by colored icon
class BoolColorIndicator extends StatefulWidget {
  final Stream<DsDataPoint<bool>>? _stream;
  final Color? _trueColor;
  final Color? _falseColor;
  final IconData? _iconData;
  ///
  const BoolColorIndicator({
      Key? key,
      Stream<DsDataPoint<bool>>? stream,
      Color? trueColor,
      Color? falseColor,
      IconData? iconData,
  }) : 
    _stream = stream,
    _trueColor = trueColor,
    _falseColor = falseColor,
    _iconData = iconData,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<BoolColorIndicator> createState() => _BoolColorIndicatorState(
      stream: _stream,
      trueColor: _trueColor,
      falseColor: _falseColor,
      iconData: _iconData,
  );
}

///
class _BoolColorIndicatorState extends State<BoolColorIndicator> {
  static const _debug = true;
  final Stream<DsDataPoint<bool>>? _stream;
  final Color? _trueColor;
  final Color? _falseColor;
  final IconData? _iconData;
  late Color _invalidValueColor;
  late AsyncSnapshot<DsDataPoint<bool>> _snapshot = AsyncSnapshot<DsDataPoint<bool>>.nothing();
  ///
  _BoolColorIndicatorState({
      required Stream<DsDataPoint<bool>>? stream,
      Color? trueColor,
      Color? falseColor,
      IconData? iconData,
  }) :
    _stream = stream,
    _trueColor = trueColor,
    _falseColor = falseColor,
    _iconData = iconData,
    super();
  ///
  @override
  Widget build(BuildContext context) {
    _invalidValueColor = Theme.of(context).stateColors.invalid;
    return StreamBuilder<DsDataPoint<bool>>(
      initialData: DsDataPoint<bool>(
        type: DsDataType.bool, name: DsPointName(fullPath: '/'), value: false, status: DsStatus.obsolete, timestamp: '',
      ),
      stream: _stream,
      builder: (context, snapshot) {
        if (_snapshot != snapshot) {
          _snapshot = snapshot;
        }
        return _buildIcon(
          _iconData, 
          _buildColor(context, _snapshot),
        );
      },
    );
  }
  ///
  Widget _buildIcon(IconData? iconData, Color? color) {
    final inputIconData = iconData;
    if (inputIconData != null) {
      return Icon(
        inputIconData,
        color: color,
      );
    } else {
      return Icon(
        Icons.circle,
        color: color,
      );
    }
  }
  ///
  Color? _buildColor(BuildContext context, AsyncSnapshot<DsDataPoint<bool>> snapshot) {
    final trueColor = _trueColor ?? Theme.of(context).stateColors.on;
    final falseColor = _falseColor ?? Theme.of(context).stateColors.off;
    Color? color;
    // log(_debug, '[$_BoolColorIndicatorState._buildColor] snapshot: ', snapshot);
    if (snapshot.hasError) {
      color = _invalidValueColor;
      log(_debug, '[$_BoolColorIndicatorState._buildColor] snapshot.error: ', snapshot.error);
    } else if (snapshot.hasData) {
      final point = snapshot.data;
      if (point != null) {
        color = point.value ? trueColor : falseColor;
      } else {
        log(_debug, '[$_BoolColorIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
      }
    } else {
      log(_debug, '[$_BoolColorIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
    }
    return color;
  }

}
