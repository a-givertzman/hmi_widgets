import 'package:hmi_core/hmi_core_translate.dart' as translate;
///
class FakeLocalizations implements translate.Localizations {
  const FakeLocalizations();
  @override
  String tr(String value, {translate.AppLang? lng}) => value;
}