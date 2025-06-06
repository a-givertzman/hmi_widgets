import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
/// Limit character set of valid text to only double.
/// 
/// Valid double number:
/// - `10.10` - Ok
/// - `+10.10` - Ok
/// - `-10.10` - Ok (can be restricted by `onlyPisitive` = true)
/// - `.10` - Ok
/// - `0` - Ok
/// - `0.` - Err
class OnlyDoubleValidationCase implements ValidationCase {
  final bool onlyPositive;
  ///
  /// Check if input is a valid double number
  /// - [onlyPositive] - Allows numbers >= 0 only
  const OnlyDoubleValidationCase({
    this.onlyPositive = false,
  });
  //
  @override
  Result<void, Failure> isSatisfiedBy(String? value) {
    String onlyPos = '';
    if(value != null && value.isNotEmpty) {
      final regex = RegExp(r'^[-+]?[\d]*\.?[\d]+$');
      final matches = regex.allMatches(value);
      // final m = matches.map((m) => m[0]).join(', ');
      if (matches.length == 1) {
        final val = double.parse(value);
        if (onlyPositive && val <= 0) {
          onlyPos = 'Positive';
        } else {
          return Ok(null);
        }
      }
    }
    return Err(
      Failure(
        message: 'Only $onlyPos Double expected',
        stackTrace: StackTrace.current,
      ),
    );
  }

}