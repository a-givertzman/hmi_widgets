import 'package:flutter/material.dart';
///
/// Conditionally wraps child with parent
class ConditionalParentWidget extends StatelessWidget {
  final bool _condition;
  final Widget _child;
  final Widget Function(BuildContext, Widget) _parentBuilder;
  ///
  /// Conditionally wraps child with parent
  const ConditionalParentWidget({
    super.key,
    required bool condition,
    required Widget child,
    required Widget Function(BuildContext, Widget) parentBuilder,
  }) :
    _parentBuilder = parentBuilder,
    _child = child,
    _condition = condition;
  //
  @override
  Widget build(BuildContext context) {
    return switch(_condition) {
      true => _parentBuilder.call(context, _child),
      false => _child,
    };
  }
}