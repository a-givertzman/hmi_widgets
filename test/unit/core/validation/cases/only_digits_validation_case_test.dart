import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/src/core/validation/cases/only_digits_validation_case.dart';

void main() {
  group('OnlyDigitsValidationCase', () {
    test('is satisfied by digit strings', () {
      final validData = ['1234567890', '34589', '907216'];
      const validationCase = OnlyDigitsValidationCase();
      for(final item in validData) {
        expect(validationCase.isSatisfiedBy(item) is Ok, equals(true));
      }
    });
    test('is not satisfied by empty/null strings', () {
      final invalidData = ['', null];
      const validationCase = OnlyDigitsValidationCase();
      for(final item in invalidData) {
        expect(validationCase.isSatisfiedBy(item) is Err, equals(true));
      }
    });
    test('is not satisfied by not digit strings', () {
      final invalidData = ['1234567890a', 'c34589', '9072d16', 'akhdsdkslfj', '!@#\$%^&*()_+=-"№;:?'];
      const validationCase = OnlyDigitsValidationCase();
      for(final item in invalidData) {
        expect(validationCase.isSatisfiedBy(item) is Err, equals(true));
      }
    });
  });
}