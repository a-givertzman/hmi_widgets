import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/validation/cases/min_length_validation_case.dart';

void main() {
  group('MinLengthValidationCase', () {
    test('is satisfied by long strings', () {
      const validData = [
        {
          'length': 3,
          'string': '1234567890',
        },
        {
          'length': 5,
          'string': '34589',
        },
        {
          'length': 4,
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
        final validationCase = MinLengthValidationCase(length);
        expect(validationCase.isSatisfiedBy(string).hasData, equals(true));
      }
    });
    test('is not satisfied by null', () {
      for(int length = 0; length < 100; length++) {
        expect(MinLengthValidationCase(length).isSatisfiedBy(null).hasError, equals(true));
      }
    });
    test('is not satisfied by short strings', () {
      const invalidData = [
        {
          'length': 20,
          'string': '1234567890a',
        },
        {
          'length': 7,
          'string': 'c34589',
        },
        {
          'length': 31,
          'string': '9072d16',
        },
        {
          'length': 1,
          'string': '',
        },
        {
          'length': 54,
          'string': '!@#\$%^&*()_+=-"№;:?',
        },
      ];
      for(final item in invalidData) {
        final length = item['length'] as int;
        final string = item['string'] as String;
        final validationCase = MinLengthValidationCase(length);
        expect(validationCase.isSatisfiedBy(string).hasError, equals(true));
      }
    });
    test('constructor asserts on negative values', () {
      for(int length = -100; length < 0; length++) {
        expect(
          () => MinLengthValidationCase(length),
          throwsAssertionError,  
        );
      }
    });
  });
}