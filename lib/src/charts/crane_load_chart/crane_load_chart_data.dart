import 'crane_load_chart_legend_data.dart';

abstract class CraneLoadChartData {
  /// The height of the CraneLoadChart widget canvas, px
  double get height;
  /// The width of the CraneLoadChart widget canvas, px
  double get width;
  /// The real height of the Crane load area, m
  double get rawHeight;
  /// The real width of the Crane load area, m
  double get rawWidth;
  /// The data (limits, colors, names) for CraneLoadChart legend
  CraneLoadChartLegendData get legendData;
}