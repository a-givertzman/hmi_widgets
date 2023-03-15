import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class ShowDotsSwitch extends StatelessWidget {
  final bool _isOn;
  final void Function(bool) _onChanged;
  final double _width;
  ///
  const ShowDotsSwitch({
    super.key,
    required double width,
    required bool isOn,
    required void Function(bool) onChanged,
  }) : 
    _width = width, 
    _isOn = isOn,
    _onChanged = onChanged;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return SizedBox(
      width: _width,
      child: Card(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: const Text(
                "Show dots",
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            const Spacer(),
            Switch(
              activeColor: Theme.of(context).colorScheme.primary,
              value: _isOn,
              onChanged: _onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
