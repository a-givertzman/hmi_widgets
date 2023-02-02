import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_translate.dart' as translate;
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/src/dialogs/auth_dialog.dart';
///
  Future<AuthResult> networkFieldAuthenticate(
    BuildContext context, 
    AppUserStacked users,
    String passwordKey,
    translate.Localizations localizations,
    DataSource dataSource, {
      Duration flushbarDuration = const Duration(milliseconds: 1000),
    }
  ) {
    const _debug = true;
    return Navigator.of(context).push<AuthResult>(
      MaterialPageRoute(
        builder: (context) => AuthDialog(
          key: UniqueKey(),
          currentUser: users.peek,
          passwordKey: passwordKey,
          localizations: localizations,
          dataSource: dataSource,
          flushBarDuration: flushbarDuration,
        ),
        settings: const RouteSettings(name: "/authDialog"),
      ),
    ).then((authResult) {
      log(_debug, '[_authenticate] authResult: ', authResult);
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