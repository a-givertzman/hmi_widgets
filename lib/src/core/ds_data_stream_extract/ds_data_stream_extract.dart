import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_widgets/src/core/colors/state_colors.dart';
import 'package:hmi_widgets/src/core/ds_data_stream_extract/ds_data_point_extracted.dart';
///
///
class DsDataStreamExtract<T> {
  final List<StreamController<DsDataPointExtracted<T>>> _controllers = [];
  final Stream<DsDataPoint<T>>? _stream;
  final StateColors _stateColors;
  bool _isActive = false;
  ///
  DsDataStreamExtract({
    required Stream<DsDataPoint<T>>? stream,
    required StateColors stateColors,
  }) : 
    _stream = stream,
    _stateColors = stateColors;
  ///
  void _onListen() {
    if (!_isActive) {
      _isActive = true;
      final stream = _stream;
      if (stream != null) {
        stream.listen((point) {
          for (var controller in _controllers) {    
            if (!controller.isClosed) {
              controller.add(
                DsDataPointExtracted(
                  value: point.value, 
                  status: point.status,
                  color: _buildColor(point),
                ),
              );
            }
          }
        });        
      }
    }
  }
  ///
  Stream<DsDataPointExtracted<T>> get stream {
    final controller = StreamController<DsDataPointExtracted<T>>();
    controller.onListen = () {
      _controllers.add(controller);
      _onListen();
    };
    controller.onCancel = () {
      controller.close();
      _controllers.remove(controller);
    };
    return controller.stream;
  }
  ///
  /// расчитывает текущий цвет в зависимости от point.status и point.value
  Color _buildColor(DsDataPoint<T> point) {
    Color clr = _stateColors.invalid;
    if (point.status == DsStatus.ok) {
      clr = point.value == DsDps.off.value
        ? _stateColors.off
        : point.value == DsDps.on.value
          ? _stateColors.on
          : point.value == DsDps.transient.value
            ? _stateColors.error
            : clr;
    }
    if (point.status == DsStatus.obsolete) {
      clr = _stateColors.obsolete;
    }
    if (point.status == DsStatus.invalid) {
      clr = _stateColors.invalid;
    }
    if (point.status == DsStatus.timeInvalid) {
      clr = _stateColors.timeInvalid;
    }
    return clr;
  }  
}