import 'dart:ui';
/// 
/// Point that is an offset from some position in a container.
sealed class ReferencePoint {
  ///
  /// Point, translated by [offset] from center of container.
  const factory ReferencePoint.center([Offset offset]) = _CenterPoint;
  ///
  /// Point, translated by [offset] from the middle of right edge of container.
  const factory ReferencePoint.centerRight([Offset offset]) = _CenterRightPoint;
  ///
  /// Point, translated by [offset] from the middle of left edge of container.
  const factory ReferencePoint.centerLeft([Offset offset]) = _CenterLeftPoint;
  ///
  /// Point, translated by [offset] from top left angle of container.
  const factory ReferencePoint.topLeft([Offset offset]) = _TopLeftPoint;
  ///
  /// Point, translated by [offset] from the middle of top edge of container.
  const factory ReferencePoint.topCenter([Offset offset]) = _TopCenterPoint;
  ///
  /// Point, translated by [offset] from top right angle of container.
  const factory ReferencePoint.topRight([Offset offset]) = _TopRightPoint;
  ///
  /// Point, translated by [offset] from bottom left angle of container.
  const factory ReferencePoint.bottomLeft([Offset offset]) = _BottomLeftPoint;
  ///
  /// Point, translated by [offset] from the middle of bottom edge of container.
  const factory ReferencePoint.bottomCenter([Offset offset]) = _BottomCenterPoint;
  ///
  /// Point, translated by [offset] from bottom right angle of container.
  const factory ReferencePoint.bottomRight([Offset offset]) = _BottomRightPoint;
  ///
  /// Returns relative offset depending on [size] of container.
  Offset value(Size size);
}
//
class _CenterPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _CenterPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.center(Offset.zero) + _offset;
}
//
class _TopLeftPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _TopLeftPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.topLeft(Offset.zero) + _offset;
}
//
class _TopCenterPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _TopCenterPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.topCenter(Offset.zero) + _offset;
}
//
class _TopRightPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _TopRightPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.topRight(Offset.zero) + _offset;
}
//
class _BottomLeftPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _BottomLeftPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.bottomLeft(Offset.zero) + _offset;
}
//
class _BottomCenterPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _BottomCenterPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.bottomCenter(Offset.zero) + _offset;
}
//
class _BottomRightPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _BottomRightPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.bottomRight(Offset.zero) + _offset;
}
//
class _CenterRightPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _CenterRightPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.centerRight(Offset.zero) + _offset;
}
//
class _CenterLeftPoint implements ReferencePoint {
  final Offset _offset;
  //
  const _CenterLeftPoint([this._offset = Offset.zero]);
  //
  @override
  Offset value(Size size) => size.centerLeft(Offset.zero) + _offset;
}
