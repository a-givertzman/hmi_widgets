import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_widgets/src/core/validation/cases/validation_case.dart';
///
class OnlyDigitsValidationCase implements ValidationCase {
  ///
  const OnlyDigitsValidationCase();
  //
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    if(value != null && value.isNotEmpty) {
      final regex = RegExp(r'[\d]*');
      final match = regex.matchAsPrefix(value);
      if (match?.end == value.length) {
        return Ok(true);
      }
    }
    return Err(
      Failure(
        message: 'Only digits expected',
        stackTrace: StackTrace.current,
      ),
    );
  }

}