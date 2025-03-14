import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/src/popups/bottom_message/bottom_message.dart';
///
class AuthDialog extends StatefulWidget {
  final AppUserSingle? _currentUser;
  final Authenticate _auth;
  final Duration? _flushBarDuration;
  ///
  const AuthDialog({
    Key? key,
    AppUserSingle? currentUser,
    required Authenticate auth,
    Duration? flushBarDuration,
  }) : 
    _currentUser = currentUser,
    _auth = auth,
    _flushBarDuration = flushBarDuration,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<AuthDialog> createState() => _AuthDialogState(
    auth: _auth,
    currentUser: _currentUser,
    flushbarDuration: _flushBarDuration,
  );
}

///
class _AuthDialogState extends State<AuthDialog> {
  static const _log = Log('_AuthDialogState');
  final AppUserSingle? _currentUser;
  final Duration? _flushBarDuration;
  late Authenticate _auth;
  late UserLogin _userLogin;
  late UserPassword _userPass;
  _AuthDialogState({
    AppUserSingle? currentUser,
    Duration? flushbarDuration,
    required Authenticate auth,
  }) :
    _auth = auth,
    _currentUser = currentUser,
    _flushBarDuration = flushbarDuration;

  //
  @override
  void initState() {
    _userLogin = const UserLogin(value: '');
    _userPass = UserPassword(value: '');
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('[.build]');
    const paddingValue = 13.0;
    return Scaffold(
      // ignoring: true,
      body: Center(
        child: SizedBox(
          width: 600,
          // height: 400,
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              // padding: const EdgeInsets.all(paddingValue * 2),
              children: [
                Text(
                  'Please authenticate to continue...'.loc,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: paddingValue),
                SizedBox(
                  width: 600,
                  // height: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    RepaintBoundary(
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        keyboardType: TextInputType.number,
                        maxLength: 254,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.account_circle,
                          ),
                          prefixStyle: Theme.of(context).textTheme.bodyMedium,
                          labelText: 'Your login'.loc,
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          errorMaxLines: 3,
                        ),
                        autocorrect: false,
                        initialValue: _userLogin.value(),
                        validator: (value) => _userLogin.validate().message(),
                        onChanged: (phone) {
                          setState(() {
                            _userLogin = UserLogin(value: phone);
                          });
                        },
                      ),
                    ),
                      const SizedBox(height: paddingValue),
                      RepaintBoundary(
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: _userPass.maxLength,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              // color: appThemeData.colorScheme.onPrimary,
                            ),
                            errorStyle: TextStyle(
                              height: 1.1,
                            ),
                            errorMaxLines: 5,
                          ),
                          autocorrect: false,
                          onChanged: (value) {
                            setState(() {
                              _userPass = UserPassword(value: value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: paddingValue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onComplete(context, true);
                      },
                      child: Text(
                        'Cancel'.loc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingValue),
                    ElevatedButton(
                      onPressed: () {
                        _onComplete(context, false);
                      },
                      child: Text(
                        'Next'.loc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  ///
  void _onComplete(BuildContext context, bool cancel) {
    final flushBarDuration = _flushBarDuration ?? Duration(
      milliseconds: const Setting('flushBarDurationMedium').toInt,
    );
    _log.debug('[._onComplete] cancel: $cancel');
    if (cancel) {
      Navigator.of(context).pop<AuthResult>(
        AuthResult(
          authenticated: false, 
          message: 'Canceled by user'.loc, 
          user: _auth.getUser().clear(),
        ),
      );
    } else {
      final currentUser = _currentUser?.info;
      if ((currentUser != null) && (_userLogin.value() == currentUser.login)) {
        BottomMessage.error(
          displayDuration: flushBarDuration,
          title: 'Authentication'.loc,
          message: 'User already authenticated'.loc,
        ).show(context);
        return ;
      }
      if (_userLogin.validate().valid() && _userPass.validate().valid()) {
        _auth.authenticateByLoginAndPass(_userLogin.value(), _userPass.value())
          .then((authResult) {
            if (authResult.authenticated) {
              final flushBarDurationOnSucces = flushBarDuration * 0.2;
              BottomMessage.confirmation(
                displayDuration: flushBarDurationOnSucces,
                title: 'Authentication'.loc,
                message: authResult.message,
              ).show(context);
              Future.delayed(flushBarDurationOnSucces)
                .then((_) {
                  Navigator.of(context).pop<AuthResult>(authResult);
                });
            } else {
              BottomMessage.error(
                displayDuration: flushBarDuration,
                title: 'Authentication'.loc,
                message: authResult.message,
              ).show(context);
            }
          });
      } else {
        final message = _buildWrongLoginPassMessage();
        _log.debug('[._onComplete] message: $message');
        BottomMessage.error(
          displayDuration: flushBarDuration,
          title: 'Authentication'.loc,
          message: message,
        ).show(context);
      }
    }
  }
  ///
  /// Builds message on wrong login or password
  String _buildWrongLoginPassMessage() {
    final wrongLoginMessage = _userLogin.validate().valid() 
      ? ''
      : 'Wrong login'.loc;
    final wrongPassMessage = _userPass.validate().valid() 
      ? ''
      : 'Wrong password'.loc;
    final andText = (wrongLoginMessage.isNotEmpty && wrongPassMessage.isNotEmpty)
      ? ' ${'and'.loc}'
      : '';
    return '$wrongLoginMessage$andText$wrongPassMessage';    
  }
}
