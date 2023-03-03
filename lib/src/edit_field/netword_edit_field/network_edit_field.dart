import 'package:hmi_networking/hmi_networking.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/edit_field/show_unauthorized_editing_flushbar.dart';

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
  final int _responseTimeout;
  final void Function(BuildContext)? _onUnauthorizedEdit;
  ///
  /// - [writeTagName] - the name of DataServer tag to send value
  /// - [responseTagName] - the name of DataServer tag to get response if value written
  /// - [users] - current stack of authenticated users
  /// tried to edit the value but not in list of allowed
  /// - [allowedGroups] - list of user group names allowed to edit this field
  /// - [responseTimeout] - timeout in seconds to wait server response
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
    int responseTimeout = 5,
    void Function(BuildContext)? onUnauthorizedEdit,
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
    _responseTimeout = responseTimeout,
    _onUnauthorizedEdit = onUnauthorizedEdit,
    super(key: key);
  //
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
    responseTimeout: _responseTimeout,
    onUnauthorizedEdit: _onUnauthorizedEdit,
  );
}

///
class _NetworkEditFieldState<T> extends State<NetworkEditField<T>> {
  final _log = Log('${_NetworkEditFieldState<T>}')..level = LogLevel.debug;
  OperationState _loadingState = OperationState.inProgress;
  OperationState _savingState = OperationState.undefined;
  OperationState _authState = OperationState.undefined;
  EditingState _editingState = EditingState.notChanged;
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
  final int _responseTimeout;
  final void Function(BuildContext) _onUnauthorizedEdit;
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
    required int responseTimeout,
    void Function(BuildContext)? onUnauthorizedEdit,
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
    _responseTimeout = responseTimeout,
    _onUnauthorizedEdit = onUnauthorizedEdit ?? showUnauthorizedEditingFlushbar,
    super();
  //
  @override
  void initState() {
    super.initState();
    final dsClient = _dsClient;
    final writeTagName = _writeTagName;
    final responseTagName = _responseTagName != null
        ? _responseTagName
        : writeTagName != null
            ? writeTagName.name
            : writeTagName != null
                ? writeTagName.name
                : null;
    if (responseTagName != null) {
      dsClient?.stream<T>(responseTagName).listen((event) {
        _log.debug('[$runtimeType.initState] event: $event');
        _log.debug('[$runtimeType.initState] event.value: ${event.value}');
        _initValue = (event.value as num).toStringAsFixed(_fractionDigits);
        _log.debug('[$runtimeType.initState] _initValue: $_initValue');
        _setEditingControllerValue(_initValue);
        if (mounted) {
          setState(() {
            _loadingState = OperationState.success;
            _editingState = EditingState.notChanged;
          });
        }
      });
    }
  }
  ///
  _setEditingControllerValue(String value) {
    _editingController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('[.build] _users', _users?.toList());
    return SizedBox(
      width: _width,
      child: RepaintBoundary(
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _valueValidator(value),
          controller: _editingController,
          keyboardType: _keyboardType,
          textAlign: TextAlign.end,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
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
          onChanged: (newValue) {
            _log.debug('[.build.onChanged] newValue: $newValue');
            if (_authState == OperationState.inProgress) {
              _setEditingControllerValue(_initValue);
            } else {
              if (newValue != _initValue) {
                _requestAccess(context).then((_) {
                  if (_authState == OperationState.success) {
                    if (_editingState == EditingState.notChanged) {
                      _editingState = EditingState.changed;
                    }
                    if (mounted) setState(() {;});
                  } else {
                    _setEditingControllerValue(_initValue);
                  }
                });
              } else {
                if (_editingState == EditingState.changed) {
                  if (mounted) setState(() {
                    _editingState = EditingState.notChanged;
                  });
                }
              }
            }
          },
          onEditingComplete: () => _onEditingComplete(),
          onFieldSubmitted: (value) {
            _log.debug('[.build] onFieldSubmitted');
          },
          onSaved: (newValue) {
            _log.debug('[.build] onSaved');
          },
        ),
      ),
    );
  }
  ///
  /// validating if the value can be parsed in to T (int / double)
  String? _valueValidator(value) {
    final result = _parseValue(value, fractionDigits: _fractionDigits);
    return result.hasError ? const Localized('Invalid date value').v : null;
  }
  ///
  void _onEditingComplete() {
    _log.debug('[._onEditingComplete]');
    _parseValue(_editingController.text, fractionDigits: _fractionDigits).fold(
      onData: (numValue) {
        if ('${numValue}' != _initValue) {
          _log.debug('[.build._onEditingComplete] new numValue: ${numValue}\t_initValue: $_initValue');
          _sendValue(_dsClient, _writeTagName, _responseTagName, numValue);
        }
      }, 
      onError: (failure) {
        _log.debug('[.build._onEditingComplete] error: ${failure.message}');
      },
    );
  }
  ///
  /// Parses string into T (int / double)
  Result<T> _parseValue(String value, {int fractionDigits = 0}) {
    if (T == int) {
      return _textToInt(value);
    } else if (T == double) {
      return _textToFixedDouble(value, fractionDigits);
    } else {
      return Result<T>(
        error: Failure.convertion(
          message: 'Ошибка в методе $runtimeType._textToFixedDouble: value "${_editingController.text}" can`t be converted', 
          stackTrace: StackTrace.current
        ),
      );
    }
  }
  ///
  Result<T> _textToInt(String value) {
    final intValue = int.tryParse(value);
    return intValue != null 
      ? Result<T>(data: intValue as T) 
      : Result<T>(
        error: Failure.convertion(
          message: 'Ошибка в методе $runtimeType._textToInt: value "$value" can`t be converted into int', 
          stackTrace: StackTrace.current),
        );
  }
  ///
  Result<T> _textToFixedDouble(String value, int fractionDigits) {
    final doubleValue = double.tryParse(value);
    if (doubleValue != null) {
      return Result<T>(data: double.parse(doubleValue.toStringAsFixed(fractionDigits)) as T);
    } else {
      return Result<T>(
        error: Failure.convertion(
          message: 'Ошибка в методе $runtimeType._textToFixedDouble: value "$value" can`t be converted into double', 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  void _sendValue(
    DsClient? dsClient, 
    DsPointName? writeTagName,
    String? responseTagName, 
    T? newValue,
  ) {
    _log.debug('[._sendValue] newValue: ', newValue);
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      setState(() {
        _savingState = OperationState.inProgress;
      });
      DsSend<T>(
        dsClient: dsClient,
        pointName: writeTagName,
        response: responseTagName,
        responseTimeout: _responseTimeout,
      ).exec(value).then((responseValue) {
        setState(() {
          if (responseValue.hasError) {
            _savingState = OperationState.undefined;
            _editingState = EditingState.changed;
          } else {
            _savingState = OperationState.success;
            _editingState = EditingState.notChanged;
          }
        });
      });
    }
  }
  ///
  Widget _buildSufixIcon() {
    if (_loadingState == OperationState.inProgress || _savingState == OperationState.inProgress) {
      return _buildProgressIndicator();
    }
    if (_editingState == EditingState.changed) {
      return const Icon(Icons.info_outline);
    }
    if (_savingState == OperationState.success) {
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
  Future<void> _requestAccess(BuildContext context) async {
    _authState = OperationState.inProgress;
    if (_allowedGroups.isEmpty) {
      _authState = OperationState.success;
      return;
    }
    final users = _users;
    if (users != null) {
      _log.debug('[._requestAccess] users:', users.toList());
      final user = users.peek;
      _log.debug('[._requestAccess] user:', user);
      _log.debug('[._requestAccess] _user.group:', user.userGroup().value);
      if (user.exists()) {
        if (_allowedGroups.contains(user.userGroup().value)) {
          _authState = OperationState.success;
          return;
        }
      }
    }
    _authState = OperationState.undefined;
    _onUnauthorizedEdit(context);
  }
}

enum EditingState {
  changed,
  notChanged,
}
