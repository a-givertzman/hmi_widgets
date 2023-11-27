import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/src/core/validation/cases/max_length_validation_case.dart';

void main() {
  group('MaxLengthValidationCase', () {
    test('is satisfied by short strings', () {
      const validData = [
        {
          'length': 10,
          'string': '1234567890',
        },
        {
          'length': 6,
          'string': '34589',
        },
        {
          'length': 30,
          'string': '907216',
        },
        {
          'length': 0,
          'string': '',
        },
      ];
      for(final item in validData) {
        final length = item['length'] as int;
        final string = item['string'] as String;
        final validationCase = MaxLengthValidationCase(length);
        expect(validationCase.isSatisfiedBy(string) is Ok, true);
      }
    });
    test('is not satisfied by null', () {
      for(int length = 0; length < 100; length++) {
        expect(MaxLengthValidationCase(length).isSatisfiedBy(null) is Err, true);
      }
    });
    test('is not satisfied by long strings', () {
      const invalidData = [
        {
          'length': 10,
          'string': '1234567890a',
        },
        {
          'length': 4,
          'string': 'c34589',
        },
        {
          'length': 1,
          'string': '9072d16',
        },
        {
          'length': 0,
          'string': '1',
        },
        {
          'length': 5,
          'string': '!@#\$%^&*()_+=-"№;:?',
        },
      ];
      for(final item in invalidData) {
        final length = item['length'] as int;
        final string = item['string'] as String;
        final validationCase = MaxLengthValidationCase(length);
        expect(validationCase.isSatisfiedBy(string) is Err, true);
      }
    });
    test('constructor asserts on negative values', () {
      for(int length = -100; length < 0; length++) {
        expect(
          () => MaxLengthValidationCase(length),
          throwsAssertionError,  
        );
      }
    });
  });
}