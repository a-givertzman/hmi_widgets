import 'dart:ui';
///
sealed class RefOffset {
  ///
  Offset value(Size size);
  ///
  const factory RefOffset.center(Offset offset) = _CenterPoint;
  ///
  const factory RefOffset.centerRight(Offset offset) = _CenterRightPoint;
  ///
  const factory RefOffset.centerLeft(Offset offset) = _CenterLeftPoint;
  ///
  const factory RefOffset.topLeft(Offset offset) = _TopLeftPoint;
  ///
  const factory RefOffset.topCenter(Offset offset) = _TopCenterPoint;
  ///
  const factory RefOffset.topRight(Offset offset) = _TopRightPoint;
  ///
  const factory RefOffset.bottomLeft(Offset offset) = _BottomLeftPoint;
  ///
  const factory RefOffset.bottomCenter(Offset offset) = _BottomCenterPoint;
  ///
  const factory RefOffset.bottomRight(Offset offset) = _BottomRightPoint;
}
//
class _CenterPoint implements RefOffset {
  final Offset _offset;
  //
  const _CenterPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.center(Offset(0, 0)) + _offset;
}
//
class _TopLeftPoint implements RefOffset {
  final Offset _offset;
  //
  const _TopLeftPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.topLeft(Offset(0, 0)) + _offset;
}
//
class _TopCenterPoint implements RefOffset {
  final Offset _offset;
  //
  const _TopCenterPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.topCenter(Offset(0, 0)) + _offset;
}
//
class _TopRightPoint implements RefOffset {
  final Offset _offset;
  //
  const _TopRightPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.topRight(Offset(0, 0)) + _offset;
}
//
class _BottomLeftPoint implements RefOffset {
  final Offset _offset;
  //
  const _BottomLeftPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.bottomLeft(Offset(0, 0)) + _offset;
}
//
class _BottomCenterPoint implements RefOffset {
  final Offset _offset;
  //
  const _BottomCenterPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.bottomCenter(Offset(0, 0)) + _offset;
}
//
class _BottomRightPoint implements RefOffset {
  final Offset _offset;
  //
  const _BottomRightPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.bottomRight(Offset(0, 0)) + _offset;
}
//
class _CenterRightPoint implements RefOffset {
  final Offset _offset;
  //
  const _CenterRightPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.centerRight(Offset(0, 0)) + _offset;
}
//
class _CenterLeftPoint implements RefOffset {
  final Offset _offset;
  //
  const _CenterLeftPoint(this._offset);
  //
  @override
  Offset value(Size size) => size.centerLeft(Offset(0, 0)) + _offset;
}
