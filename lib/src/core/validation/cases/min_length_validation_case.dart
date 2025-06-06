import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'validation_case.dart';
/// 
/// Limit minimum length of valid text.
class MinLengthValidationCase implements ValidationCase {
  final int _minLength;
  /// 
  /// Limit minimum length of valid text using [minLength] value.
  /// 
  /// Usage:
  /// ```
  /// Validator(
  ///   cases: [
  ///     MinLengthValidationCase(3),
  ///   ],
  /// );
  /// ```
  const MinLengthValidationCase(int minLength) : 
    assert(minLength >= 0),
    _minLength = minLength;
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && value.length >= _minLength) {
      return Ok(true);
    }
    return Err(
      Failure(
        message: 'Too few characters', 
        stackTrace: StackTrace.current,
      ),
    );
  }
}