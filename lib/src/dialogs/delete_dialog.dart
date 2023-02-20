import 'package:flutter/material.dart';
///
Future<bool?> showDeleteDialog(BuildContext context, Widget title, Widget content) {
  return showDialog<bool>(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text('Да'),
          ),
        ],
      );
    },
  );
}
