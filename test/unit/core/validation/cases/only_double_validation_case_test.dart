import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/core/validation/cases/only_double_validation_case.dart';

void main() {
  group('OnlyDoubleValidationCase', () {
    test('is satisfied by any double', () async {
      final log = Log('OnlyDoubleValidationCase.test');
      Log.initialize();    
      final List<(int, String, Result<void, void>)> testData = [
        (02, '10', Ok(null)),
        (03, '10.10', Ok(null)),
        (03, '+10.10', Ok(null)),
        (03, '-10.10', Ok(null)),
        (04, '.10', Ok(null)),
        (05, '10.', Err(null)),
        (06, '0.1 10.', Err(null)),
        (07, '0.1 .10', Err(null)),
        (07, '0.1 0.1', Err(null)),
        (08, '0.1e', Err(null)),
        (09, '0e1', Err(null)),
        (10, '0d1', Err(null)),
        (11, 'e01', Err(null)),
        (12, 'e', Err(null)),
      ];
      final validationCase = OnlyDoubleValidationCase();
      for (final item in testData) {
        int step = item.$1;
        String value = item.$2;
        Result<void, void> target = item.$3;
        final result = validationCase.isSatisfiedBy(value);
        log.debug(' | step $step  value: $value,   result: $result');
        switch (target) {
          case Ok(value: final _): 
            expect(result.isOk(), true, reason: 'step $step  \n result: $result \n target: $target');
          case Err(error: final _): 
            expect(result.isErr(), true, reason: 'step $step  \n result: $result \n target: $target');
        }
      }
    });
    test('is satisfied by only pisitive double', () async {
      final log = Log('OnlyDoubleValidationCase.test');
      Log.initialize();    
      final List<(int, String, Result<void, void>)> testData = [
        (02, '10', Ok(null)),
        (03, '10.10', Ok(null)),
        (03, '+10.10', Ok(null)),
        (03, '-10.10', Err(null)),
        (04, '.10', Ok(null)),
        (05, '10.', Err(null)),
        (06, '0.1 10.', Err(null)),
        (07, '0.1 .10', Err(null)),
        (07, '0.1 0.1', Err(null)),
        (08, '0.1e', Err(null)),
        (09, '0e1', Err(null)),
        (10, '0d1', Err(null)),
        (11, 'e01', Err(null)),
        (12, 'e', Err(null)),
      ];
      final validationCase = OnlyDoubleValidationCase(onlyPositive: true);
      for (final item in testData) {
        int step = item.$1;
        String value = item.$2;
        Result<void, void> target = item.$3;
        final result = validationCase.isSatisfiedBy(value);
        log.debug(' | step $step  value: $value,   result: $result');
        switch (target) {
          case Ok(value: final _): 
            expect(result.isOk(), true, reason: 'step $step  \n result: $result \n target: $target');
          case Err(error: final _): 
            expect(result.isErr(), true, reason: 'step $step  \n result: $result \n target: $target');
        }
      }
    });
  });
}
