import 'dart:math';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class FakeSwlData implements SwlData {
  final double _rawWidth;
  final double _rawHeight;
  final int _pointsCount;
  final int _swlIndexesCount;
  final double _maxSwlValue;
  ///
  FakeSwlData({
    required double rawWidth, 
    required double rawHeight, 
    required int swlIndexesCount,
    required int pointsCount,
    required double maxSwlValue,
  }) : _swlIndexesCount = swlIndexesCount,
    _pointsCount = pointsCount,
    _rawHeight = rawHeight,
    _rawWidth = rawWidth,
    _maxSwlValue = maxSwlValue;
  //
  @override
  Future<List<double>> get x {
    final random = Random();
    return Future.value(
      List.generate(_pointsCount, (index) => random.nextDouble() * _rawWidth),
    );
  }
  //
  @override
  Future<List<double>> get y {
    final random = Random();
    return Future.value(
      List.generate(_pointsCount, (index) => random.nextDouble() * _rawHeight),
    );
  }
  //
  @override
  Future<List<List<double>>> get swl {
    final random = Random();
    return Future.value(
      List.generate(_swlIndexesCount, (index) => 
        List.generate(
          _pointsCount, (index) => random.nextDouble() * _maxSwlValue,
        ),
      ),
    );
  }
}