///
sealed class CanvasItemDimension {
  ///
  const factory CanvasItemDimension.sizedFrom(double value) = ValueSizedDimension;
  ///
  const factory CanvasItemDimension.sizedFromCanvas() = CanvasSizedDimension;
}
///
class ValueSizedDimension implements CanvasItemDimension {
  final double value;
  ///
  const ValueSizedDimension(this.value);
}
///
class CanvasSizedDimension implements CanvasItemDimension {
  ///
  const CanvasSizedDimension();
}