import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/src/popups/bottom_message/bottom_message.dart';
///
void showUnauthorizedEditingFlushbar(BuildContext context) {
  BottomMessage.error(
    displayDuration: Duration(
      milliseconds: const Setting('flushBarDurationMedium').toInt,
    ),
    message: const Localized('Editing is not permitted for current user').v,
  ).show(context);
}