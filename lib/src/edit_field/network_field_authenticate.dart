import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/src/dialogs/auth_dialog.dart';
///
  Future<AuthResult> networkFieldAuthenticate(
    BuildContext context, 
    AppUserStacked users,
    Authenticate auth,
  ) {
    const _log = Log('networkFieldAuthenticate');
    final flushBarDuration = Duration(
      milliseconds: const Setting('flushBarDurationMedium').toInt,
    );
    return Navigator.of(context).push<AuthResult>(
      MaterialPageRoute(
        builder: (context) => AuthDialog(
          key: UniqueKey(),
          currentUser: users.peek,
          auth: auth,
          flushBarDuration: flushBarDuration,
        ),
        settings: const RouteSettings(name: "/authDialog"),
      ),
    ).then((authResult) {
      _log.debug( 'authResult: $authResult');
      final result = authResult;
      if (result != null) {
        if (result.authenticated) {
          users.push(result.user);
        }
        return result;
      }
      throw Failure.unexpected(
        message: 'Authentication error, null returned instead of AuthResult ', 
        stackTrace: StackTrace.current,
      );
    });    
  }