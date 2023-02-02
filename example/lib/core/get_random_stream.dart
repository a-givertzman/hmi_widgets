import 'dart:math';
import 'package:hmi_core/hmi_core.dart';
///
Stream<DsDataPoint<T>> getRandomDataPointStream<T>(
  T Function(Random) randomDelegate, {
    Duration duration = const Duration(seconds: 1),
  }
) {
  return getRandomStream((random) => 
    DsDataPoint(
      type: DsDataType.uInt, 
      name: DsPointName(fullPath: '/test'),
      value: randomDelegate(random),
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ),
    duration: duration,
  );
}
///
Stream<T> getRandomStream<T>(
  T Function(Random) randomDelegate, {
    Duration duration = const Duration(seconds: 1),
  }
) {
  return Stream.periodic(
    const Duration( milliseconds: 1000),
    (_) => randomDelegate(Random()),
  );
}