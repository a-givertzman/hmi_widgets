import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
///
class AuthDialog extends StatefulWidget {
  final AppUserSingle? _currentUser;
  final Duration? _flushBarDuration;
  ///
  const AuthDialog({
    Key? key,
    AppUserSingle? currentUser,
    Duration? flushBarDuration,
  }) : 
    _currentUser = currentUser,
    _flushBarDuration = flushBarDuration,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<AuthDialog> createState() => _AuthDialogState(
    currentUser: _currentUser,
    flushbarDuration: _flushBarDuration,
  );
}

///
class _AuthDialogState extends State<AuthDialog> {
  static const _debug = true;
  final AppUserSingle? _currentUser;
  final Duration? _flushBarDuration;
  late Authenticate _auth;
  late UserLogin _userLogin;
  late UserPassword _userPass;
  _AuthDialogState({
    AppUserSingle? currentUser,
    Duration? flushbarDuration,
  }) :
    _currentUser = currentUser,
    _flushBarDuration = flushbarDuration;

  ///
  @override
  void initState() {
    _userLogin = const UserLogin(value: '');
    _userPass = UserPassword(value: '');
    _auth = Authenticate(
      user: AppUserSingle(),
    );
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    log(_debug, '[_AuthDialogState.build]');
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
                  const Localized('Please authenticate to continue...').v,
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
                          labelText: const Localized('Your login').v,
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
                        const Localized('Cancel').v,
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
                        const Localized('Next').v,
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
      milliseconds: AppUiSettingsNum.getSetting('flushBarDurationMedium') as int,
    );
    log(_debug, '[_AuthDialogState._onComplete] cancel: $cancel');
    if (cancel) {
      Navigator.of(context).pop<AuthResult>(
        AuthResult(
          authenticated: false, 
          message: const Localized('Canceled by user').v, 
          user: AppUserSingle(remote: DataSet.empty()),
        ),
      );
    } else {
      final currentUser = _currentUser;
      if ((currentUser != null) && (_userLogin.value() == '${currentUser['login']}')) {
        FlushbarHelper.createError(
          duration: flushBarDuration,
          title: const Localized('Authentication').v,
          message: const Localized('User already authenticated').v,
        ).show(context);
        return ;
      }
      if (_userLogin.validate().valid() && _userPass.validate().valid()) {
        _auth.authenticateByLoginAndPass(_userLogin.value(), _userPass.value())
          .then((authResult) {
            if (authResult.authenticated) {
              FlushbarHelper.createSuccess(
                duration: flushBarDuration,
                title: const Localized('Authentication').v,
                message: authResult.message,
              ).show(context);
              Future.delayed(flushBarDuration)
                .then((_) {
                  Navigator.of(context).pop<AuthResult>(authResult);
                });
            } else {
              FlushbarHelper.createError(
                duration: flushBarDuration,
                title: const Localized('Authentication').v,
                message: authResult.message,
              ).show(context);
            }
          });
      } else {
        final message = _buildWrongLoginPassMessage();
        log(_debug, '[_AuthDialogState._onComplete] message: $message');
        FlushbarHelper.createError(
          duration: flushBarDuration,
          title: const Localized('Authentication').v,
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
      : const Localized('Wrong login').v;
    final wrongPassMessage = _userPass.validate().valid() 
      ? ''
      : const Localized('Wrong password').v;
    final andText = (wrongLoginMessage.isNotEmpty && wrongPassMessage.isNotEmpty)
      ? ' ${const Localized('and')}'
      : '';
    return '$wrongLoginMessage$andText$wrongPassMessage';    
  }
}
