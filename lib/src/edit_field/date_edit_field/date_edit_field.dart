import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateEditField extends StatefulWidget {
  final String? _label;
  final void Function(DateTime?)? _onChanged;
  final void Function(DateTime?)? _onComplete;
  final void Function(DateTime?)? _onSubmitted;
  ///
  const DateEditField({
    Key? key,
    String? label,
    void Function(DateTime?)? onChanged,
    void Function(DateTime?)? onComplete,
    void Function(DateTime?)? onSubmitted,
  }) : 
    _label = label,
    _onChanged = onChanged,
    _onComplete = onComplete,
    _onSubmitted = onSubmitted,
    super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DateEditFieldState(
      label: _label,
      onChanged: _onChanged,
      onComplete: _onComplete,
      onSubmitted: _onSubmitted,
    );
  }
}

class _DateEditFieldState extends State<DateEditField> {
  final String? _label;
  final double _suffixPadding;
  final void Function(DateTime?)? _onChanged;
  final void Function(DateTime?)? _onComplete;
  final void Function(DateTime?)? _onSubmitted;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _textController = TextEditingController();
  DateTime? _dateTime;
  ///
  _DateEditFieldState({
    String? label,
    double suffixPadding = 8.0,
    void Function(DateTime?)? onChanged,
    void Function(DateTime?)? onComplete,
    void Function(DateTime?)? onSubmitted,
  }) :
    _label = label,
    _onChanged = onChanged,
    _onComplete = onComplete,
    _onSubmitted = onSubmitted,
    _suffixPadding = suffixPadding,
    super();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      maxLength: 10,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        counterText: '',
        label: _label != null ? Text(_label!) : null,
        errorStyle: TextStyle(height: 0),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2.0),
        ),
        suffix: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                final onComplete = _onComplete;
                if (onComplete != null) {
                  onComplete(_dateTime);
                }
              },
              child: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(width: _suffixPadding * 0.5),
            InkWell(
              onTap: () {
                _dateTime = null;
                _textController.clear();
                final onComplete = _onComplete;
                if (onComplete != null) {
                  onComplete(null);
                }
              }, 
              child: Icon(Icons.cancel_outlined, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),

      ),
      inputFormatters: [
        DateInputFormatter(separator: '.'),
      ],
      onChanged: (value) {
        _dateTime = _parseDate(_textController.text);
        final onChanged = _onChanged;
        if (onChanged != null) {
          onChanged(_dateTime);
        }
      },
      onEditingComplete: () {
        setState(() {
          _autovalidateMode = AutovalidateMode.always;
        });
        final onComplete = _onComplete;
        if (onComplete != null) {
          onComplete(_dateTime);
        }
      },
      onFieldSubmitted: (value) {
        setState(() {
          _autovalidateMode = AutovalidateMode.always;
        });
        final onSubmitted = _onSubmitted;
        if (onSubmitted != null) {
          onSubmitted(_dateTime);
        }
      },
      autovalidateMode: _autovalidateMode,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return null;
        }
        return _dateTime == null ? '' : null;
      },
    );
  }
  ///
  DateTime? _parseDate(String? value) {
    if (value != null) {
      return DateTime.tryParse(value.split('.').reversed.join());
    }
    return null;
  }
  ///
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

///
class DateInputFormatter extends TextInputFormatter {
  final String _separator;
  ///
  DateInputFormatter({
    String separator = '.',
  }) : 
    _separator = separator;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: _addSeperators(newValue.text, _separator), 
      selection: updateCursorPosition(oldValue, newValue),
    );
  }
  ///
  String _addSeperators(String value, String seperator) {
    value = value.replaceAll(RegExp(r"\D"), '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
      if (i == 3) {
        newString += seperator;
      }
    }
    return newString;
  }
  ///
  TextSelection updateCursorPosition(TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.length == 1 && newValue.text.length == 2) {
        return TextSelection.fromPosition(TextPosition(offset: 3));
    } else if (oldValue.text.length == 4 && newValue.text.length == 5) {
        return TextSelection.fromPosition(TextPosition(offset: 6));
    }
    return newValue.selection;
  }
}