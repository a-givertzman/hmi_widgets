import 'package:flutter/services.dart';
import 'package:hmi_core/hmi_core.dart';

class SwlData {
  static const _debug = true;
  final String _assetPath;
  List<double>? _x;
  List<double>? _y;
  List<List<double>>? _swl;
  final int _count;
  ///
  SwlData({
    required String assetPath,
    required int count,
  }) :
    _assetPath = assetPath,
    _count = count;
  ///
  List<double> _parseStringList(List<String> strings) {
    return strings.map((e) {
      try {
        final v = double.parse(e);
        return v;
      } catch (error) {
        log(_debug, 'Ошибка в методе $runtimeType._parseStringList() значение: $e \nошибка: $error'); 
        return 0.0;       
      }
    }).toList();
  }
  ///
  Future<List<double>> _loadAsset(String assetName) {
    return rootBundle.loadString(assetName)
      .then((value) {
        final doubleList = _parseStringList(
          value.replaceAll('\n', ';').replaceAll(',', '.').trim().split(';'),
        );
        return doubleList;
      })
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе _loadAsset класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );        
      });
  }
  ///
  Future<List<double>> get x async {
    if (_x == null) {
      await _loadAsset('$_assetPath/x.csv')
        .then((value) => _x = value);
    }
    // log(_debug, '[SwlData.x] _x: ', _x);
    return Future.value(_x);
  }
  ///
  Future<List<double>> get y async {
    if (_y == null) {
      await _loadAsset('$_assetPath/y.csv')
        .then((value) => _y = value);
    }
    // log(_debug, '[SwlData.y] _y: ', _y);
    return Future.value(_y);
  }
  ///
  Future<List<List<double>>> get swl async {
    if (_swl == null) {
      _swl = [];
      for (int i = 0; i < _count; i++) {
        await _loadAsset('$_assetPath/swl_$i.csv')
          .then((value) => _swl!.add(value));
      }
    }
    // final list = _swl![0].take(22500).toList();
    // log(_debug, '\n\n[SwlData.swl] ___________');
    // for (int i = 0; i < 150; i++) {
    //   final lst = list.take(150);
    //   log(_debug, lst.toList());
    //   list.removeRange(0, 150);
    // }
    // log(_debug, '[SwlData.swl] _swl: ', _swl);
    return Future.value(_swl);
  }
}