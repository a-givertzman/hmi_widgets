import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// Merge paths together like a logical operation.
class PaintLogical implements PaintItem {
  final List<PaintItem> _items;
  final PathOperation _operation;
  final Paint? _paint;
  ///
  /// Merge paths together like a logical [operation].
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintLogical(
  ///       [
  ///         PaintRect(...),
  ///         PaintPoint(...),
  ///       ],
  ///       operation: PathOperation.union,
  ///     ),
  ///   ],
  /// );
  /// ```
  PaintLogical(
    List<PaintItem> items, {
    required PathOperation operation,
    Paint? paint,
  }) :
    assert(items.isNotEmpty),
    _items = items,
    _paint = paint,
    _operation = operation;
  //
  @override
  Path path(Size size) {
    return _items
      .map((item) => item.path(size))
      .reduce(
        (combinedPath, path) => Path.combine(
          _operation,
          combinedPath,
          path,
        ),
      );
  }  
  //
  @override
  Paint get brush => _paint ?? _items.first.brush;
}