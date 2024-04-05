import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'invalid_status_indicator.dart';
///
/// Double Point status indicator.
/// Simple icon, indicates state of streamed int:
///   0 - undefined
///   1 - on
///   2 - off
///   3 - transient (intermidiate / faulty / trtipped)
/// [DsDataPoint] value position
/// by [trueIcon] & [falseIcon] passed as parameters
class DpsIconIndicator extends StatefulWidget {
  final Stream<DsDataPoint<int>>? _stream;
  final Widget? _posUndefinedIcon;
  final Widget? _posOffIcon;
  final Widget? _posOnIcon;
  final Widget? _posTransientIcon;
  final bool _showInvalidStatusIndicator;
  ///
  const DpsIconIndicator({
      Key? key,
      Stream<DsDataPoint<int>>? stream,
      Widget? posUndefinedIcon,
      Widget? posOffIcon,
      Widget? posOnIcon,
      Widget? posTransientIcon,
      bool showInvalidStatusIndicator = false,
  }) : 
    _stream = stream,
    _posUndefinedIcon = posUndefinedIcon,
    _posOffIcon = posOffIcon,
    _posOnIcon = posOnIcon,
    _posTransientIcon = posTransientIcon,
    _showInvalidStatusIndicator = showInvalidStatusIndicator,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<DpsIconIndicator> createState() => _DpsIconIndicatorState(
    stream: _stream,
    posUndefinedIcon: _posUndefinedIcon,
    posOffIcon: _posOffIcon,
    posOnIcon: _posOnIcon,
    posTransientIcon: _posTransientIcon,
    showInvalidStatusIndicator: _showInvalidStatusIndicator,
  );
}

///
class _DpsIconIndicatorState extends State<DpsIconIndicator> {
  static const _log = Log('_DpsIconIndicatorState');
  late DsDataStreamExtract<int> _extractDsDataStream;
  final Stream<DsDataPoint<int>>? _inputStream;
  final Widget? _posUndefinedIcon;
  final Widget? _posOffIcon;
  final Widget? _posOnIcon;
  final Widget? _posTransientIcon;
  final bool _showInvalidStatusIndicator;
  bool _streamIsCreated = false;
  ///
  _DpsIconIndicatorState({
      required Stream<DsDataPoint<int>>? stream,
      Widget? posUndefinedIcon,
      Widget? posOffIcon,
      Widget? posOnIcon,
      Widget? posTransientIcon,
      required bool showInvalidStatusIndicator,
  }) :
    _inputStream = stream,
    _posUndefinedIcon = posUndefinedIcon,
    _posOffIcon = posOffIcon,
    _posOnIcon = posOnIcon,
    _posTransientIcon = posTransientIcon,
    _showInvalidStatusIndicator = showInvalidStatusIndicator,
    super();  
  //
  @override
  Widget build(BuildContext context) {
    final stateColors = Theme.of(context).stateColors;
    if (!_streamIsCreated) {
      _streamIsCreated = true;
      _extractDsDataStream = DsDataStreamExtract(
        stream: _inputStream, 
        stateColors: stateColors
      );
    }
    if (_showInvalidStatusIndicator) {
      return InvalidStatusIndicator(
        stream: _inputStream,
        stateColors: stateColors,
        child: StreamBuilder<DsDataPointExtracted<int>>(
          stream: _extractDsDataStream.stream,
          builder: (context, snapshot) {
            return _buildIcon(
              context,
              snapshot,
              _posUndefinedIcon,
              _posOffIcon,
              _posOnIcon,
              _posTransientIcon,
              stateColors,
            );
          },
        ),
      );
    } else {
      return StreamBuilder<DsDataPointExtracted<int>>(
        stream: _extractDsDataStream.stream,
        builder: (context, snapshot) {
          return _buildIcon(
            context,
            snapshot,
            _posUndefinedIcon,
            _posOffIcon,
            _posOnIcon,
            _posTransientIcon,
            stateColors
          );
        },
      );
    }
  }
  ///
  Widget _buildIcon(
    BuildContext context, 
    AsyncSnapshot<DsDataPointExtracted<int>> snapshot,
    Widget? posUndefinedIcon, 
    Widget? posOffIcon,
    Widget? posOnIcon, 
    Widget? posTransientIcon,
    StateColors stateColors,
  ) {
    Color color = stateColors.invalid;
    Widget? invalidIndicator;
    if (snapshot.hasError) {
      color = Theme.of(context).colorScheme.error;
    } else if (snapshot.hasData) {
      final point = snapshot.data;
      if (point != null) {
        color = point.color;  //_buildColor(point, color);
        // invalidIndicator = InvalidStatusIndicator(point);
        if (point.value == DsDps.undefined.value) {
          return _undefinedIconDefault(
            context, color, 
            icon: posUndefinedIcon,
            invalidIndicator: invalidIndicator,
          );
        } else if (point.value == DsDps.off.value) {
          return _offIconDefault(
            context, color,
            icon: posOffIcon,
            invalidIndicator: invalidIndicator,
          );
        } else if (point.value == DsDps.on.value) {
          return _onIconDefault(
            context, color,
            icon: posOnIcon,
            invalidIndicator: invalidIndicator,
          );
        } else if (point.value == DsDps.transient.value) {
          return _transientIconDefault(
            context, color,
            icon: posTransientIcon,
            invalidIndicator: invalidIndicator,
          );
        }
      } else {
        _log.debug( '[$_DpsIconIndicatorState._build] snapshot.connectionState: ${snapshot.connectionState}');
      }
    } else {
      _log.debug('[._build] snapshot.connectionState: ${snapshot.connectionState}');
    }
    return posUndefinedIcon ?? _undefinedIconDefault(context, color);
  }
  ///
  Widget _undefinedIconDefault(
    BuildContext context, 
    Color? color, 
    {
      Widget? invalidIndicator,
      Widget? icon,
    }
  ) {
    return Stack(
      children: [
        if (icon != null)
          icon
        else
          Icon(
            Icons.question_mark_outlined, 
            color: color,
          ),
        if (invalidIndicator != null) Positioned(
          top: 0,
          left: 0,
          child: invalidIndicator,
        ),
      ],
    );
  }
  ///
  Widget _offIconDefault(
    BuildContext context, 
    Color? color, 
    {
      Widget? invalidIndicator,
      Widget? icon,
    }    
  ) {
    return Stack(
      children: [
        if (icon != null)
          icon
        else
          Icon(
            Icons.circle, 
            color: color,
          ),
        if (invalidIndicator != null) Positioned(
          top: 0,
          left: 0,
          child: invalidIndicator,
        ),
      ],
    );
  }
  ///
  Widget _onIconDefault(
    BuildContext context, 
    Color? color, 
    {
      Widget? invalidIndicator,
      Widget? icon,
    }    
  ) {
    return Stack(
      children: [
        if (icon != null)
          icon
        else
          Icon(
            Icons.circle,
            color: color,
          ),
        if (invalidIndicator != null) Positioned(
          top: 0,
          left: 0,
          child: invalidIndicator,
        ),
      ],
    );
  }
  ///
  Widget _transientIconDefault(
    BuildContext context, 
    Color? color, 
    {
      Widget? invalidIndicator,
      Widget? icon,
    }    
  ) {
    return Stack(
      children: [
        if (icon != null)
          icon
        else
          Icon(
            Icons.report_off_outlined, 
            color: color,
          ),
        if (invalidIndicator != null) Positioned(
          top: 0,
          left: 0,
          child: invalidIndicator,
        ),
      ],
    );
  }
}
