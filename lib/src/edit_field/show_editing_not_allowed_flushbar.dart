import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
void showEditingNotAllowedFlushbar(BuildContext context) {
  FlushbarHelper.createError(
    duration: Duration(
      milliseconds: const Setting('flushBarDurationMedium').toInt,
    ),
    message: const Localized('Editing is not permitted for current user').v,
  ).show(context);
}