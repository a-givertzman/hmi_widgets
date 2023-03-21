import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'validation_case.dart';
///
class MaxLengthValidationCase implements ValidationCase {
  final int _maxLength;
  ///
  const MaxLengthValidationCase(int maxLength) : 
    assert(maxLength >= 0), 
    _maxLength = maxLength;
  //
  @override
  Result<bool> isSatisfiedBy(String? value) {
    if (value != null && value.length <= _maxLength) {
      return Result(data: true);
    }
    return Result(
      error: Failure(
        message: 'Too many characters', 
        stackTrace: StackTrace.current,
      ),
    );
  }
}