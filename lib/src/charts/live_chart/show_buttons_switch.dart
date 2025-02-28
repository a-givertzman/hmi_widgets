import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class ShowButtonsSwitch extends StatelessWidget {
  final bool _isOn;
  final void Function(bool) _onChanged;
  ///
  const ShowButtonsSwitch({
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
      height: 10,
      width: 30,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: StadiumBorder(),
      ),
      child: IconButton(
        tooltip: _isOn ? const Localized('Draw lines').v : const Localized('Draw dots').v,
        onPressed: () => _onChanged(!_isOn), 
        color: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(_isOn ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      ),
    );
  }
}
