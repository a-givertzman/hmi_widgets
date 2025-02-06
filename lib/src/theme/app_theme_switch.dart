import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class AppThemeSwitch with ChangeNotifier {
  static const _log = Log('AppThemeSwitch');
  // final _streamController = StreamController<AppTheme>();
  late ThemeData _themeData;
  AppTheme _theme = AppTheme.dark;
  ThemeMode _themeMode = ThemeMode.light;
  ///
  AppTheme get theme => _theme;
  ///
  ThemeMode get themeMode => _themeMode;
  ///
  ThemeData get themeData => _themeData;
  ///
  AppThemeSwitch() : super() {
    _log.debug('[$AppThemeSwitch]');
    if (appThemes.containsKey(_theme)) {
      final defaultThemeData = appThemes[_theme];
      if (defaultThemeData != null) {
        _themeData = defaultThemeData;
      } else {
        throw _unexpectedFailure();
      }
    } else {
      throw _unexpectedFailure();
    }
  }
  ///
  Failure _unexpectedFailure() {
    return Failure.unexpected(
      message: '[$AppThemeSwitch] несуществующая тема $_themeMode',
      stackTrace: StackTrace.current,
    );
  }
  ///
  void toggleMode(ThemeMode? mode) {
    if (mode != null) {
      _themeMode = mode;
    }
    notifyListeners();
  }
  ///
  void toggleTheme(AppTheme? theme) {
    _log.debug('[.toggleTheme()] theme: $theme');
    if (theme != null) {
      if (appThemes.containsKey(theme)) {
        _theme = theme;
        final appTheme = appThemes[theme];
        if (appTheme != null) {
          _themeData = appTheme;
        }
      } else {
        throw _unexpectedFailure();
      }
    }
    notifyListeners();
  }
}
