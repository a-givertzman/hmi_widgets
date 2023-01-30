import 'crane_load_chart_legend_data.dart';

abstract class CraneLoadChartData {
  double get height;
  double get  width;
  double get rawHeight;
  double get rawWidth;
  CraneLoadChartLegendData get legendData;
}