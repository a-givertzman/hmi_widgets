///
/// Width or height of canvas item.
sealed class CanvasItemDimension {
  ///
  /// Item size provided by user.
  const factory CanvasItemDimension.sizedFrom(double value) = ValueSizedDimension;
  ///
  /// Item size taken from canvas size.
  const factory CanvasItemDimension.sizedFromCanvas() = CanvasSizedDimension;
}
///
/// Canvas item size provided by user.
class ValueSizedDimension implements CanvasItemDimension {
  final double value;
  ///
  /// Canvas item size provided by user through [value].
  const ValueSizedDimension(this.value);
}
///
/// Canvas item size taken from canvas size.
class CanvasSizedDimension implements CanvasItemDimension {
  ///
  /// Canvas item size taken from canvas size.
  const CanvasSizedDimension();
}