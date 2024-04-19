import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
enum _MessageType {
  confirmation,
  info,
  warning,
  error,
}
///
class BottomMessage {
  final _MessageType _type;
  final Duration _displayDuration;
  final String? _title;
  final String _message;
  ///
  const BottomMessage._({
    required _MessageType type,
    required Duration displayDuration,
    String? title,
    required String message,
  }) : 
    _type = type,
    _displayDuration = displayDuration,
    _title = title,
    _message = message;
  ///
  const BottomMessage.confirmation({
    Duration displayDuration = const Duration(milliseconds: 500),
    String? title,
    required String message,
  }) : this._(
    type: _MessageType.confirmation,
    displayDuration: displayDuration,
    title: title,
    message: message,
  );
  ///
  const BottomMessage.info({
    Duration displayDuration = const Duration(milliseconds: 500),
    String? title,
    required String message,
  }) : this._(
    type: _MessageType.info,
    displayDuration: displayDuration,
    title: title,
    message: message,
  );
  ///
  const BottomMessage.warning({
    Duration displayDuration = const Duration(milliseconds: 500),
    String? title,
    required String message,
  }) : this._(
    type: _MessageType.warning,
    displayDuration: displayDuration,
    title: title,
    message: message,
  );
  ///
  const BottomMessage.error({
    Duration displayDuration = const Duration(milliseconds: 500),
    String? title,
    required String message,
  }) : this._(
    type: _MessageType.error,
    displayDuration: displayDuration,
    title: title,
    message: message,
  );
  ///
  void show(BuildContext context) {
    final title = _title;
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        duration: _displayDuration,
        backgroundColor: theme.colorScheme.surface,
        closeIconColor: theme.colorScheme.primary,
        content: Row(
          children: [
            switch(_type) {
              _MessageType.confirmation => const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.greenAccent,
              ),
              _MessageType.info => const Icon(
                Icons.info_outline_rounded,
                color: Colors.blueAccent,
              ),
              _MessageType.warning => const Icon(
                Icons.warning_amber_rounded,
                color: Colors.yellowAccent,
              ),
              _MessageType.error => const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
              ),
            },
            SizedBox(width: const Setting('blockPadding').toDouble),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(title != null)
                  Text(title, style: theme.textTheme.titleMedium),
                Text(_message, style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}