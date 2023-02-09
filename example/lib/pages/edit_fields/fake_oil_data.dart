import 'package:hmi_widgets/hmi_widgets.dart';
///
class FakeOilData implements OilData {
  ///
  const FakeOilData();
  //
  @override
  Future<List<String>> names() => Future.value(
    ['ISO VG68', 'ISO VG46', 'ISO VG32', 'ISO VG422'],
  );
}