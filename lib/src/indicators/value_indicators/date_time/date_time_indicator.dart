import 'package:flutter/widgets.dart' hide Localizations;
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/core/builders/stream_builder_widget.dart';
///
class DateTimeIndicator extends StatelessWidget {
  final Stream<DateTime> _stream;
  final String Function(DateTime) _format;
  final TextStyle? _style;
  ///
  DateTimeIndicator({
    super.key,
    Stream<DateTime>? stream,
    TextStyle? style,
    String Function(DateTime) format = _defaultFormat,
  }) : 
    _style = style,
    _format = format,
    _stream = stream ?? Stream.periodic(
      const Duration(seconds: 1),
    ).map((_) => DateTime.now());
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilderWidget(
      initialData: Ok(DateTime.now()),
      onStream: () => _stream.map((dateTime) => Ok(dateTime)),
      caseData: (context, dateTime, _) => Text(
        _format(dateTime),
        style: _style,
      ),
    );
  }
  //
  static String _defaultFormat(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}