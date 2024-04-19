import 'package:flutter/material.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: _displayDuration,
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
            Column(
              children: [
                if(title != null)
                  Text(title),
                Text(_message)
              ],
            ),
          ],
        ),
      ),
    );
  }
}