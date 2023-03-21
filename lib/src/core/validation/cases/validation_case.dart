import 'package:hmi_core/hmi_core_result.dart';
///
abstract class ValidationCase {
  ///
  Result<void> isSatisfiedBy(String? value);
}