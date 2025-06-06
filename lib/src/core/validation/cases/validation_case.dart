import 'package:hmi_core/hmi_core_result.dart';

/// 
/// An interface for rules by which a text can be considered valid.
abstract class ValidationCase {
  ///
  /// Returns [Ok] if text of [value] is valid, [Err] otherwise.
  ResultF<void> isSatisfiedBy(String? value);
}