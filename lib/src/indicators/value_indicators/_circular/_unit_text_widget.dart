part of '../circular_value_indicator.dart';
///
class _UnitTextWidget extends StatelessWidget {
  final bool _showValueText;
  final double _size;
  final String _unitText;
  ///
  const _UnitTextWidget({
    required bool showValueText,
    required double size,
    required String unitText,
  }) :
    _unitText = unitText,
    _size = size,
    _showValueText = showValueText;
  //
  @override
  Widget build(BuildContext context) {
    if (_showValueText) {
      final textStyle = Theme.of(context).textTheme.bodySmall ?? const TextStyle();
      return Positioned(
        bottom: 0.18 * _size,
        child: Text(
          _unitText,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: textStyle.color!.withValues(alpha: 0.7),
          ),
          textScaler: TextScaler.linear(0.8 * 0.0168 * _size),
        ),
      );
    }
    return const SizedBox();
  }
}