import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
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
  ResultF<void> isSatisfiedBy(String? value) {
    if (value != null && value.length <= _maxLength) {
      return Ok(true);
    }
    return Err(
      Failure(
        message: 'Too many characters', 
        stackTrace: StackTrace.current,
      ),
    );
  }
}