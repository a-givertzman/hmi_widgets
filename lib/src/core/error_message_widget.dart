import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ErrorMessageWidget extends StatelessWidget {
  final TextStyle? _style;
  final Color? _iconColor;
  final String _message;
  ///
  const ErrorMessageWidget({
    super.key, 
    TextStyle? style, 
    Color? iconColor,
    String message = 'Some error occured',
  }) :
    _style = style,
    _iconColor = iconColor,
    _message = message;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded, 
              color: _iconColor ?? theme.stateColors.error,
            ),
            SizedBox(width: padding),
            Text(
              _message,
              style: _style ?? theme.textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}
