import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract class ValidationCase {
  ///
  ResultF<void> isSatisfiedBy(String? value);
}