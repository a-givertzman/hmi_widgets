import 'package:hmi_core/hmi_core_result.dart';
///
abstract class ValidationCase {
  ///
  Result<bool> isSatisfiedBy(String? value);
}