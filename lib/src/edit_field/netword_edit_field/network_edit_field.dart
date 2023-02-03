import 'package:another_flushbar/flushbar_helper.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/edit_field/network_field_authenticate.dart';
import 'package:hmi_widgets/src/theme/app_theme.dart';

///
/// Gets and shows the value of type [T] from the DataServer.
/// If the value edited by user, sends new value to the DataServer.
/// The value can be edited onle if current user present in the list of allwed.
/// Shows progress indicator until network operation complited.
class NetworkEditField<T> extends StatefulWidget {
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final AppUserStacked? _users;
  final List<String> _allowedGroups;
  final TextInputType? _keyboardType;
  final int _fractionDigits;
  final String? _labelText;
  final String? _unitText;
  final double _width;
  final bool _showApplyButton;
  final Duration _flushBarDuration;
  final String _passwordKey;
  ///
  /// - [writeTagName] - the name of DataServer tag to send value
  /// - [responseTagName] - the name of DataServer tag to get response if value written
  /// - [users] - current stack of authenticated users
  /// tried to edit the value but not in list of allowed
  /// - [allowedGroups] - list of user group names allowed to edit this field
  const NetworkEditField({
    Key? key,
    List<String> allowedGroups = const [],
    AppUserStacked? users,
    DsClient? dsClient,
    DsPointName? writeTagName,
    String? responseTagName,
    TextInputType? keyboardType,
    int fractionDigits = 0,
    String? labelText,
    String? unitText,
    double width = 230.0,
    showApplyButton = false,
    Duration flushBarDuration = const Duration(milliseconds: 1000),
    required String passwordKey,
  }) : 
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _keyboardType = keyboardType,
    _fractionDigits = fractionDigits,
    _labelText = labelText,
    _unitText = unitText,
    _width = width,
    _showApplyButton = showApplyButton,
    _flushBarDuration = flushBarDuration,
    _passwordKey = passwordKey,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<NetworkEditField<T>> createState() => _NetworkEditFieldState<T>(
    users: _users,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    allowedGroups: _allowedGroups,
    keyboardType: _keyboardType,
    fractionDigits: _fractionDigits,
    labelText: _labelText,
    unitText: _unitText,
    width: _width,
    showApplyButton: _showApplyButton,
    flushBarDuration: _flushBarDuration,
    passwordKey: _passwordKey,
  );
}

///
class _NetworkEditFieldState<T> extends State<NetworkEditField<T>> {
  static const _debug = true;
  final _state = NetworkOperationState(isLoading: true);
  final TextEditingController _editingController = TextEditingController();
  final List<String> _allowedGroups;
  late AppUserStacked? _users;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final TextInputType? _keyboardType;
  final int _fractionDigits;
  final String? _labelText;
  final String? _unitText;
  final double _width;
  final bool _showApplyButton;
  final Duration _flushBarDuration;
  final String _passwordKey;
  // bool _accessAllowed = false;
  String _initValue = '';
  ///
  _NetworkEditFieldState({
    required List<String> allowedGroups,
    required AppUserStacked? users,
    required DsClient? dsClient,
    required DsPointName? writeTagName,
    required String? responseTagName,
    required TextInputType? keyboardType,
    required int fractionDigits,
    required String? labelText,
    required String? unitText,
    required double width,
    required bool showApplyButton,
    required Duration flushBarDuration,
    required String passwordKey,
  }) : 
    assert(T == int || T == double, 'Generic <T> must be int or double.'),
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _keyboardType = keyboardType,
    _fractionDigits = fractionDigits,
    _labelText = labelText,
    _unitText = unitText,
    _width = width,
    _showApplyButton = showApplyButton,
    _flushBarDuration = flushBarDuration,
    _passwordKey = passwordKey,
    super();
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  @override
  void didChangeDependencies() {
    // final themeData = Theme.of(context);
    final statusColors = Theme.of(context).stateColors;
    // _editingController = TextEditingController(text: _newValue);
    final dsClient = _dsClient;
    final writeTagName = _writeTagName;
    final responseTagName = _responseTagName != null
        ? _responseTagName
        : writeTagName != null
            ? writeTagName.name
            : writeTagName != null
                ? writeTagName.name
                : null;
    if (dsClient != null) {
      DsDataStreamExtract<T>(
        stream: (responseTagName != null)
            ? dsClient.stream<T>(responseTagName)
            : null,
        stateColors: statusColors,
      ).stream.listen((event) {
        log(_debug, '[$runtimeType.didChangeDependencies] event: $event');
        log(_debug, '[$runtimeType.didChangeDependencies] event.value: ${event.value}');
        _initValue = (event.value as num).toStringAsFixed(_fractionDigits);
        if (!_state.isEditing) {
          log(_debug, '[$runtimeType.didChangeDependencies] _initValue: $_initValue');
          // setState(() {
          _editingController.text = _initValue;
          // });
        }
        if (mounted) {
          setState(() {
            _state.setLoaded();
          });
        }
      });
    }
    super.didChangeDependencies();
  }
  ///
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$_NetworkEditFieldState.build] _users', _users?.toList());
    return SizedBox(
      width: _width,
      child: RepaintBoundary(
        child: TextFormField(
          controller: _editingController,
          keyboardType: _keyboardType,
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            suffixText: _unitText,
            prefixStyle: Theme.of(context).textTheme.bodyMedium,
            label: Text(
              '$_labelText',
              softWrap: false,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                  ),
            ),
            alignLabelWithHint: true,
            errorMaxLines: 3,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_showApplyButton)
                  IconButton(
                    onPressed: () => _onEditingComplete(), 
                    icon: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
                  ),
                _buildSufixIcon(),
              ],
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
          ),
          onChanged: (newValue) async {
            log(_debug, '[$_NetworkEditFieldState.build.onChanged] newValue: $newValue');
            if (_state.isAuthenticating) {
              _editingController.text = _initValue;
            } else {
              if (newValue != _initValue) {
                await _requestAccess().then((_) {
                  if (_state.isAuthenticeted) {
                    if (newValue == _initValue) {
                      _state.setLoaded();
                    } else if (!_state.isChanged) {
                      _state.setEditing();
                      _state.setChanged();
                    }
                    if (mounted) setState(() {;});
                  } else {
                    _editingController.text = _initValue;
                  }
                });
              }
            }
          },
          onEditingComplete: () => _onEditingComplete(),
          onFieldSubmitted: (value) {
            log(_debug, '[$_NetworkEditFieldState.build] onFieldSubmitted');
          },
          onSaved: (newValue) {
            log(_debug, '[$_NetworkEditFieldState.build] onSaved');
          },
        ),
      ),
    );
  }
  ///
  void _onEditingComplete() {
    log(_debug, '[$_NetworkEditFieldState._onEditingComplete]');
    T? numValue;
    if (T == int) {
      numValue = int.tryParse(_editingController.text) as T;
    }
    if (T == double) {
      numValue = _textToFixedDouble(_editingController.text, _fractionDigits) as T;
    }
    log(_debug, '[$_NetworkEditFieldState.build.onEditingComplete] numValue: $numValue\t_initValue: $_initValue');
    if (numValue != double.parse(_initValue)) {
      _sendValue(_dsClient, _writeTagName, _responseTagName, numValue);
    } else {
      _editingController.text = _initValue;
      setState(() => _state.setLoaded());
    }
  }
  ///
  double _textToFixedDouble(String value, int fractionDigits) {
    final doubleValue = double.tryParse(_editingController.text);
    if (doubleValue != null) {
      return double.parse(doubleValue.toStringAsFixed(fractionDigits));
    } else {
      return 0.0;
    }
  }
  ///
  void _sendValue(
    DsClient? dsClient, 
    DsPointName? writeTagName,
    String? responseTagName, 
    T? newValue,
  ) {
    log(_debug, '[$_NetworkEditFieldState._sendValue] newValue: ', newValue);
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      setState(() {
        _state.setSaving();
      });
      DsSend<T>(
        dsClient: dsClient,
        pointName: writeTagName,
        response: responseTagName,
      ).exec(value).then((responseValue) {
        setState(() => _state.setSaved());
      });
    }
  }
  ///
  Widget _buildSufixIcon() {
    if (_state.isLoading || _state.isSaving) {
      return _buildProgressIndicator();
    }
    if (_state.isChanged) {
      return const Icon(Icons.info_outline);
    }
    if (_state.isSaved) {
      return Icon(Icons.check, color: Theme.of(context).primaryColor);
    }
    return Icon(null);
  }
  ///
  Widget _buildProgressIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
  }
  /// Проверяет наличие доступа у текущего пользователя
  /// на редактирования данного поля
  Future<void> _requestAccess() async {
    _state.setAuthenticating();
    if (_allowedGroups.isEmpty) {
      _state.setAuthenticated();
      // _accessAllowed = true;
      return;
    }
    final users = _users;
    if (users != null) {
      log(_debug, '[$_NetworkEditFieldState._requestAccess] users:', users.toList());
      final user = users.peek;
      log(_debug, '[$_NetworkEditFieldState._requestAccess] user:', user);
      log(_debug, '[$_NetworkEditFieldState._requestAccess] _user.group:', user.userGroup().value);
      if (user.exists()) {
        if (_allowedGroups.contains(user.userGroup().value)) {
          _state.setAuthenticated();
          // _accessAllowed = true;
          return;
        }
      }
      networkFieldAuthenticate(
        context, 
        users, 
        _passwordKey,
        flushbarDuration: _flushBarDuration,
      ).then((AuthResult authResult) {
        if (authResult.authenticated) {
          setState(() {
            _state.setAuthenticated();
            // _accessAllowed = true;
            return;
          });
        }
      });
    }
    FlushbarHelper.createError(
      duration: _flushBarDuration,
      message: const Localized('Editing is not permitted for current user').toString(),
    ).show(context);
    _state.setAuthenticated(authenticated: false);
    // _accessAllowed = false;
  }
}
