import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
///
/// Single Point status indicator.
/// Simple icon, indicates state of streamed boolean.
/// [DsDataPoint<bool>] value position
/// by [trueIcon] & [falseIcon] passed as parameters
class SpsIconIndicator extends StatefulWidget {
  final Stream<DsDataPoint<bool>>? _stream;
  final Icon? _trueIcon;
  final Icon? _falseIcon;
  ///
  const SpsIconIndicator({
      Key? key,
      Stream<DsDataPoint<bool>>? stream,
      Icon? trueIcon,
      Icon? falseIcon,
  }) : 
    _stream = stream,
    _trueIcon = trueIcon,
    _falseIcon = falseIcon,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<SpsIconIndicator> createState() => _SpsIconIndicatorState(
    stream: _stream,
    trueIcon: _trueIcon,
    falseIcon: _falseIcon,
  );
}

///
class _SpsIconIndicatorState extends State<SpsIconIndicator> {
  static const _debug = true;
  final Stream<DsDataPoint<bool>>? _stream;
  final Icon? _trueIcon;
  final Icon? _falseIcon;
  late StateColors _stateColors;
  ///
  _SpsIconIndicatorState({
      required Stream<DsDataPoint<bool>>? stream,
      Icon? trueIcon,
      Icon? falseIcon,
  }) :
    _stream = stream,
    _trueIcon = trueIcon,
    _falseIcon = falseIcon,
    super();  
  //
  @override
  Widget build(BuildContext context) {
    _stateColors = Theme.of(context).stateColors;
    return StreamBuilder<DsDataPoint<bool>>(
      // initialData: DsDataPoint<bool>(
      //   type: DsDataType.bool, path: '', name: '', value: false, status: DsStatus.obsolete(), timestamp: '',
      // ),
      stream: _stream,
      builder: (context, snapshot) {
        return _buildIcon(
          context,
          snapshot,
          _trueIcon,
          _falseIcon,
        );
      },
    );
  }
  ///
  Widget _buildIcon(
    BuildContext context, 
    AsyncSnapshot<DsDataPoint<bool>> snapshot,
    Icon? trueIcon, 
    Icon? falseIcon,
  ) {
    Color color = _stateColors.invalid; //Theme.of(context).backgroundColor;
    if (snapshot.hasError) {
      color = Theme.of(context).colorScheme.error;
    } else if (snapshot.hasData) {
      final point = snapshot.data;
      if (point != null) {
        color = _buildColor(point, color);
        if (point.value) {
          return trueIcon ?? _trueIconDefault(context, color);
        } else {
          return falseIcon ?? _falseIconDefault(context, color);
        }
      } else {
        log(_debug, '[$_SpsIconIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
      }
    } else {
      log(_debug, '[$_SpsIconIndicatorState._build] snapshot.connectionState: ', snapshot.connectionState);
    }
    return falseIcon ?? _falseIconDefault(context, color);
  }
  ///
  /// расчитывает текущий цвет в зависимости от point.status и point.value
  Color _buildColor(DsDataPoint<bool> point, Color color) {
    Color clr = color;
    if (point.status == DsStatus.ok) {
      clr = point.value
        ? _stateColors.on
        : _stateColors.off;
    }
    if (point.status == DsStatus.obsolete) {
      clr = _stateColors.obsolete;
    }
    if (point.status == DsStatus.invalid) {
      clr = _stateColors.invalid;
    }
    if (point.status == DsStatus.timeInvalid) {
      clr = _stateColors.timeInvalid;
    }
    return clr;
  }
  ///
  Icon _falseIconDefault(BuildContext context, Color? color) {
    return Icon(
      Icons.circle, 
      color: color, //Theme.of(context).backgroundColor,
    );
  }
  Icon _trueIconDefault(BuildContext context, Color? color) {
    return Icon(
      Icons.circle,
      color: color, //Theme.of(context).colorScheme.primary,
    );
  }
}
