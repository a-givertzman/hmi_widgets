import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
/// Показывает прямоугольник с двумя индикатороми и надпись
/// индикатор 1 - состояние объекта
/// индикатор 2 - аврия объекта
/// Положение надписи можно определить в параметре [textPosition]
class AlarmedStatusIndicatorWidget extends StatelessWidget {
  final Widget _stateIndicator;
  final Widget _alarmIndicator;
  final Widget _caption;
  final Alignment _alignment;
  ///
  const AlarmedStatusIndicatorWidget({
    Key? key,
    required Widget stateIndicator,
    required Widget alarmIndicator,
    required Widget caption,
    Alignment alignment = Alignment.centerLeft,
  }) : 
    _stateIndicator = stateIndicator,
    _alarmIndicator = alarmIndicator,
    _caption = caption,
    _alignment = alignment,
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(
          const Setting('padding').toDouble
        ),
        child: _buildIndicatorWidget(
          stateIndicator: _stateIndicator, 
          alarmIndicator: _alarmIndicator, 
          caption: _caption, 
          alignment: _alignment,
        ),
      ),
    );
  }
  ///
  Widget _buildIndicatorWidget({
    required Widget stateIndicator, 
    required Widget alarmIndicator, 
    required Widget caption, 
    required Alignment alignment,
  }) {
    if (alignment == Alignment.centerLeft) {
      return Row(
        children: [
          Stack(
            children: [
              _stateIndicator,
              _alarmIndicator,
            ],
          ),
          SizedBox(width: const Setting('padding').toDouble),
          _caption,
        ],
      );
    }
    if (alignment == Alignment.centerRight) {
      return Row(
        children: [
          _caption,
          SizedBox(width: const Setting('padding').toDouble),
          Stack(
            children: [
              _stateIndicator,
              _alarmIndicator,
            ],
          ),
        ],
      );
    }
    throw Failure.unexpected(
      message: 'Ошибка в методе _buildIndicatorWidget класса $AlarmedStatusIndicatorWidget:\n unsupported alignment: $_alignment',
      stackTrace: StackTrace.current,
    );    
  }
}
