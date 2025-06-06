import 'package:hmi_core/hmi_core_result.dart';
import 'cases/validation_case.dart';

/// 
/// Provides validation for Flutter's [TextFormField].
class Validator {
  final List<ValidationCase> _cases;
  /// Provides validation for Flutter's [TextFormField].
  /// 
  /// You can determine valid input conditions with [cases].
  /// 
  /// Usage:
  /// ```dart
  /// const validator = Validator(cases: [MinLengthValidationCase(5)]);
  /// TextFormField(
  ///   ...,
  ///   validator: (value) => validator.editFieldValidator(value),
  /// );
  /// ```
  const Validator({
    required List<ValidationCase> cases,
  }) :
    _cases = cases;
  /// 
  /// Validates an input. Returns an error string to display if the input is invalid, or null otherwise
  String? editFieldValidator(String? value) {
    for (final validationCase in _cases) {
      final result = validationCase.isSatisfiedBy(value);
      if (result case Err(:final error)) {
        return error.message;
      }
    }
    return null;
  }
}