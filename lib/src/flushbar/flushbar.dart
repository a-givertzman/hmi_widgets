import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';
///
SnackBar _createSnackBar(Icon icon, Text text, {
  Duration? duration,
  Color? backgroundColor,
}) {
  final padding = const Setting('padding').toDouble;
  final flushBarDuration = duration ?? Duration(
      milliseconds: const Setting('flushBarDurationMedium').toInt,
  );
  return SnackBar(
    duration: flushBarDuration,
    backgroundColor: backgroundColor,
    padding: EdgeInsets.all(padding),
    showCloseIcon: true,
    content: Row(
      children: [
        icon,
        SizedBox(width: padding),
        text,
      ],
    ),
  );
}
///
abstract class FlushBar {
  const factory FlushBar.info(String message, {Duration? duration}) = _InfoFlushBar;
  const factory FlushBar.warning(String message, {Duration? duration}) = _WarningFlushBar;
  const factory FlushBar.alarm(String message, {Duration? duration}) = _AlarmFlushBar;
  const factory FlushBar.error(String message, {Duration? duration}) = _ErrorFlushBar;

  SnackBar toSnackBar(BuildContext context);
}
///
class _InfoFlushBar implements FlushBar {
  final String _message;
  final Duration? _duration;
  ///
  const _InfoFlushBar(
    String message, {
      Duration? duration,
    }) : 
      _message = message,
      _duration = duration;
  //
  @override
  SnackBar toSnackBar(BuildContext context) {
    return _createSnackBar(
      Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary), 
      Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      duration: _duration,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

class _WarningFlushBar implements FlushBar {
  final String _message;
  final Duration? _duration;
  ///
  const _WarningFlushBar(
    String message, {
      Duration? duration,
    }) : 
      _message = message,
      _duration = duration;
  //
  @override
  SnackBar toSnackBar(BuildContext context) {
    return _createSnackBar(
      Icon(Icons.warning_amber, color: Colors.yellow.shade400), 
      Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      duration: _duration,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

class _AlarmFlushBar implements FlushBar {
  final String _message;
  final Duration? _duration;
  ///
  const _AlarmFlushBar(
    String message, {
      Duration? duration,
    }) : 
      _message = message,
      _duration = duration;
  //
  @override
  SnackBar toSnackBar(BuildContext context) {
    return _createSnackBar(
      Icon(Icons.warning_amber, color: Theme.of(context).stateColors.alarm), 
      Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      duration: _duration,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

class _ErrorFlushBar implements FlushBar {
  final String _message;
  final Duration? _duration;
  ///
  const _ErrorFlushBar(
    String message, {
      Duration? duration,
    }) : 
      _message = message,
      _duration = duration;
  //
  @override
  SnackBar toSnackBar(BuildContext context) {
    return _createSnackBar(
      Icon(
        Icons.warning_amber, color: Colors.red.shade400), 
      Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      duration: _duration,
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}

