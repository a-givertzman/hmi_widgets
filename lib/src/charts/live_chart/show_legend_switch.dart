import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class ShowLegendSwitch extends StatelessWidget {
  final bool _isOn;
  final void Function(bool) _onChanged;
  ///
  const ShowLegendSwitch({
    super.key, 
    required bool isOn, 
    required void Function(bool) onChanged,
  }) :
    _isOn = isOn,
    _onChanged = onChanged;
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
      ),
      child: IconButton(
        tooltip: _isOn ? 'Hide legend'.loc : 'Show legend'.loc,
        onPressed: () => _onChanged(!_isOn), 
        color: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.legend_toggle),
      ),
    );
  }
}