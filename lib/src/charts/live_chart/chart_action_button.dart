import 'package:flutter/material.dart';
///
class ChartActionButton extends StatelessWidget {
  final String? _tooltip;
  final Icon _icon;
  final void Function()? _onPressed;
  ///
  const ChartActionButton({
    super.key,
    String? tooltip,
    void Function()? onPressed,
    required Icon icon,
  }) : 
    _icon = icon,
    _tooltip = tooltip,
    _onPressed = onPressed;
  //
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
      ),
      child: IconButton(
        
        tooltip: _tooltip,
        onPressed: _onPressed, 
        color: Theme.of(context).colorScheme.onPrimary,
        icon: _icon,
      ),
    );
  }
}