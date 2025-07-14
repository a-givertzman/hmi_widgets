import 'package:flutter/widgets.dart' hide Localizations;
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/src/indicators/value_indicators/date_time/date_time_indicator.dart';
///
class LocalizedDateTimeIndicator extends StatelessWidget {
  final Map<AppLang, String Function(DateTime)> _langFormats;
  final Stream<DateTime>? _stream;
  final TextStyle? _style;
  ///
  LocalizedDateTimeIndicator({
    super.key,
    Stream<DateTime>? stream,
    TextStyle? style,
    Map<AppLang, String Function(DateTime)> langFormats = const {
      AppLang.ru: _ruFormat,
      AppLang.en: _westFormat,
      AppLang.de: _westFormat,
      AppLang.fr: _westFormat,
    },
  }) : _langFormats = langFormats, 
    _style = style,
    _stream = stream;
  //
  @override
  Widget build(BuildContext context) {
    return DateTimeIndicator(
      stream: _stream,
      style: _style,
      format: _langFormats[Localizations().appLang] ?? _westFormat,
    );
  }
  //
  static String _westFormat(DateTime dateTime) {
    final hour = _padLeftWithZeros(dateTime.hour, 2);
    final minute = _padLeftWithZeros(dateTime.minute, 2);
    final second = _padLeftWithZeros(dateTime.second, 2);
    final day = _padLeftWithZeros(dateTime.day, 2);
    final month = _padLeftWithZeros(dateTime.month, 2);
    final year = _padLeftWithZeros(dateTime.year, 4);
    return '$month/$day/$year $hour:$minute:$second';
  }
  //
  static String _ruFormat(DateTime dateTime) {
    final hour = _padLeftWithZeros(dateTime.hour, 2);
    final minute = _padLeftWithZeros(dateTime.minute, 2);
    final second = _padLeftWithZeros(dateTime.second, 2);
    final day = _padLeftWithZeros(dateTime.day, 2);
    final month = _padLeftWithZeros(dateTime.month, 2);
    final year = _padLeftWithZeros(dateTime.year, 4);
    return '$day.$month.$year $hour:$minute:$second';
  }
  //
  static String _padLeftWithZeros(int value, int width) {
    return value.toString().padLeft(width, '0');
  }
}