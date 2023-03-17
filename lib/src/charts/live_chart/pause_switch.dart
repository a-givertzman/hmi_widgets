import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class PauseSwitch extends StatelessWidget {
  final bool _isOn;
  final void Function(bool) _onChanged;
  ///
  const PauseSwitch({
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
        tooltip: _isOn ? const Localized('Continue').v : const Localized('Pause').v,
        onPressed: () => _onChanged(!_isOn), 
        color: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(_isOn ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}