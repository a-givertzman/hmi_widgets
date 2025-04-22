import 'dart:ui';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
///
/// Combine many [PaintItem]s into one.
class PaintJoined implements PaintItem {
  final List<(PaintItem, Offset)> _items;
  final Paint? _paint;
  ///
  /// Combine many [PaintItem]s into one.
  ///
  /// - [items] - collection of [PaintItem]s with corresponding offsets - indentation that is applied to each item relative to the previous;
  /// - [paint] - a common "brush" that will be used to draw the paths [items], overriding their own paints.
  /// 
  /// Example:
  /// ```dart
  /// PaintItems(
  ///   items: [
  ///     PaintJoined(
  ///      [
  ///        (PaintPoint(...), Offset.zero),
  ///        (PaintPoint(...), Offset(100, 0)),
  ///      ],
  ///     ),
  ///   ],
  /// );
  /// ```
  PaintJoined(
    List<(PaintItem, Offset)> items, {
    Paint? paint,
  }) :
    assert(items.isNotEmpty),
    _items = items,
    _paint = paint;
  //
  @override
  Path path(Size size) => _items.fold(
    Path(),
    (joinedPath, item) => joinedPath
    ..addPath(
      item.$1.path(size),
      item.$2,
    ),
  );
  //
  @override
  Paint get brush => _paint ?? _items.first.$1.brush;
}