import 'package:hmi_core/hmi_core.dart';

///
/// Класс переводит любое значение в относительные единицы 
///   в методе relative(double inputValue) при заданном базисе [basis]
///   и пределах в которых изменяется входное значение
/// Например если входная величина меняется в пределах от 40 до 90,
/// а базис равен 1, то:
/// ```
/// 0           40            90
///              min           max
/// -|-----------|-------------|-----
/// basis = 1
/// ```
/// тогда класс будет возвращать следующие значения:
/// ```
/// input     relative
/// value     value
/// 40    -   0
/// 65    -   0.5
/// 90    -   1.0
/// ```
class RelativeValue {
  static const _debug = true;
  final double _basis;
  final double _k;
  final double _b;
  ///
  RelativeValue({
    double basis = 1,
    required double min,
    required double max,
  }) :
    _basis = basis,
    _k = basis / (max - min),
    _b = -basis * min / (max - min)
  {
    log(_debug, '[$RelativeValue] ');
  }
  ///
  double get basis => _basis;
  ///
  /// возвращает значение в относительных единицах,
  /// если [value] не null.
  /// Иначе возвращает 0.
  /// Если [limit] true, то когда значение 
  /// в относительных единицах превысит [basis]
  /// метод вернет [basis]
  double relative(double? value, {bool limit = false}) {
    final v = value;
    if (v != null) {
      final relativeValue = _k * v + _b;
      if (limit) {
        if (relativeValue > _basis) {
          return _basis;
        }
      }
      return relativeValue;
    }
    return 0;
  }
}