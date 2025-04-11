///
/// Width or height of canvas item.
sealed class PaintItemDimension {
  ///
  /// Item size provided by user.
  const factory PaintItemDimension.sizedFrom(double value) = ValueSizedDimension;
  ///
  /// Item size taken from canvas size.
  const factory PaintItemDimension.sizedFromCanvas() = CanvasSizedDimension;
}
///
/// Canvas item size provided by user.
class ValueSizedDimension implements PaintItemDimension {
  final double value;
  ///
  /// Canvas item size provided by user through [value].
  const ValueSizedDimension(this.value);
}
///
/// Canvas item size taken from canvas size.
class CanvasSizedDimension implements PaintItemDimension {
  ///
  /// Canvas item size taken from canvas size.
  const CanvasSizedDimension();
}