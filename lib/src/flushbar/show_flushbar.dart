import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'flushbar.dart';

class ShowFlushBar implements TickerProvider {
  final FlushBar _flushBar;
  Ticker? _ticker;
  ShowFlushBar(FlushBar flashBar) : 
    _flushBar = flashBar;

  void on(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      _flushBar.toSnackBar(context)
    );
  }
  
  @override
  Ticker createTicker(TickerCallback onTick) {
    if(_ticker==null) {
      _ticker = Ticker(onTick);
    }
    return _ticker!;
  }
}