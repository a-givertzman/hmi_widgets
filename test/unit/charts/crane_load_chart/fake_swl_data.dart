import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data.dart';
//
class FakeSwlData implements SwlData {
  final List<double> _x;
  final List<double> _y;
  final List<List<double>> _swl;
  ///
  const FakeSwlData({
    required List<double> x,
    required List<double> y,
    required List<List<double>> swl,
  }) : _x = x, 
    _y = y,
    _swl = swl;
  //
  @override
  Future<List<double>> get x => Future.value(_x);
  //
  @override
  Future<List<double>> get y => Future.value(_y);
  //
  @override
  Future<List<List<double>>> get swl => Future.value(_swl);
}