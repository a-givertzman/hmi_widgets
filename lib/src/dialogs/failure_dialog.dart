import 'package:flutter/material.dart';

void showFailureDialog(BuildContext context, {Widget? title, Widget? content}) {
  showDialog<bool>(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
