import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/validation/cases/max_length_validation_case.dart';
import 'package:hmi_widgets/src/core/validation/cases/min_length_validation_case.dart';
import 'package:hmi_widgets/src/core/validation/cases/only_digits_validation_case.dart';
import 'package:hmi_widgets/src/core/validation/cases/validation_case.dart';
import 'package:hmi_widgets/src/core/validation/validator.dart';

void main() {
  group('Validator editFieldValidator', () {
    test('returns null on valid data', () {
      const validData = [
        {
          'cases': [
            MinLengthValidationCase(5),
            MaxLengthValidationCase(255),
            OnlyDigitsValidationCase(),
          ],
          'string': '12345',
        },
        {
          'cases': [
            MinLengthValidationCase(3),
          ],
          'string': 'a2c',
        },
        {
          'cases': [
            MaxLengthValidationCase(10),
          ],
          'string': '',
        },
        {
          'cases': [
            OnlyDigitsValidationCase(),
          ],
          'string': '123',
        },
      ];
      for(final item in validData) {
        final cases = item['cases'] as List<ValidationCase>;
        final string = item['string'] as String;
        expect(Validator(cases: cases).editFieldValidator(string), isNull);
      }
    });
    test('returns error message on invalid data', () {
      const invalidData = [
        {
          'cases': [
            MinLengthValidationCase(3),
            MaxLengthValidationCase(5),
            OnlyDigitsValidationCase(),
          ],
          'string': '123456',
          'message': 'Too many characters',
        },
        {
          'cases': [
            MinLengthValidationCase(3),
            MaxLengthValidationCase(5),
            OnlyDigitsValidationCase(),
          ],
          'string': '12',
          'message': 'Too few characters',
        },
        {
          'cases': [
            MinLengthValidationCase(3),
            MaxLengthValidationCase(5),
            OnlyDigitsValidationCase(),
          ],
          'string': '123a',
          'message': 'Only digits expected',
        },
        {
          'cases': [
            MinLengthValidationCase(3),
          ],
          'string': 'a2',
          'message': 'Too few characters',
        },
        {
          'cases': [
            MaxLengthValidationCase(10),
          ],
          'string': '123456890abcde',
          'message': 'Too many characters',
        },
        {
          'cases': [
            OnlyDigitsValidationCase(),
          ],
          'string': '123abc',
          'message': 'Only digits expected',
        },
      ];
      for(final item in invalidData) {
        final cases = item['cases'] as List<ValidationCase>;
        final string = item['string'] as String;
        final errorMessage = item['message'] as String;
        expect(
          Validator(cases: cases).editFieldValidator(string), 
          equals(errorMessage),
        );
      }
    });
  });
}