import 'package:hmi_core/hmi_core_result.dart';

///
abstract class ValidationCase {
  ///
  ResultF<void> isSatisfiedBy(String? value);
}