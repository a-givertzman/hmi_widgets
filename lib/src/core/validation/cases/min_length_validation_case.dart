import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'validation_case.dart';
///
class MinLengthValidationCase implements ValidationCase {
  final int _minLength;
  ///
  const MinLengthValidationCase(int minLength) : 
    assert(minLength >= 0),
    _minLength = minLength;
  //
  @override
  Result<bool> isSatisfiedBy(String? value) {
    if (value != null && value.length >= _minLength) {
      return Result(data: true);
    }
    return Result(
      error: Failure(
        message: 'Too few characters', 
        stackTrace: StackTrace.current,
      ),
    );
  }
}