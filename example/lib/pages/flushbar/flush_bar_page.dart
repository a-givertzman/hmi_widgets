import 'package:example/pages/home/home_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class FlushBarPage extends StatelessWidget {
  const FlushBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    const flushBarDuration = Duration(seconds: 1);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlushBar'),
      ),
      body: ListView(
        children: [
          MenuButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('kavo')));
              // const ShowFlushBar(
              //   FlushBar.info('Some info message', duration: flushBarDuration),
              // ).on(context);
            }, 
            text: 'Info',
          ),
          MenuButton(
            onPressed: () {
              ShowFlushBar(
                const FlushBar.warning('Some warning message', duration: flushBarDuration),
              ).on(context);
            }, 
            text: 'Warning',
          ),
          MenuButton(
            onPressed: () {
              ShowFlushBar(
                const FlushBar.alarm('Some alarm message', duration: flushBarDuration),
              ).on(context);
            }, 
            text: 'Alarm',
          ),
          MenuButton(
            onPressed: () {
              ShowFlushBar(
                const FlushBar.error('Some error message', duration: flushBarDuration),
              ).on(context);
            }, 
            text: 'Error',
          ),
        ],
      ),
    );
  }
}