import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_json.dart';
///
class FakeCraneLoadChartLegendJson implements CraneLoadChartLegendJson {
  final Map<String, List<List>> _map;
  FakeCraneLoadChartLegendJson(this._map);
  @override
  Future<Map<String, List<List>>> get decoded => Future.value(_map);
}