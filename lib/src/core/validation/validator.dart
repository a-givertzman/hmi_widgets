import 'cases/validation_case.dart';

///
class Validator {
  final List<ValidationCase> _cases;
  ///
  const Validator({
    required List<ValidationCase> cases,
  }) :
    _cases = cases;
  ///
  String? editFieldValidator(String? value) {
    for (final validationCase in _cases) {
      final result = validationCase.isSatisfiedBy(value);
      if (result.hasError) {
        return result.error.message;
      }
    }
    return null;
  }
}