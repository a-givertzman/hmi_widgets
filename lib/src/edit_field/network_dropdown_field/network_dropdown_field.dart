import 'dart:core';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:flutter/material.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/src/core/ds_data_stream_extract/ds_data_point_extracted.dart';
import 'package:hmi_widgets/src/core/ds_data_stream_extract/ds_data_stream_extract.dart';
import 'package:hmi_widgets/src/edit_field/show_unauthorized_editing_flushbar.dart';
import 'package:hmi_widgets/src/theme/app_theme_colors_extension.dart';
import 'oil_data.dart';

///
class NetworkDropdownFormField extends StatefulWidget {
  // final Future<AuthResult> Function(BuildContext context)? _onAuthRequested;
  final List<String> _allowedGroups;
  final AppUserStacked? _users;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final String? _labelText;
  final double _width;
  final OilData _oilData;
  final Duration _responseTimeout;
  final void Function(BuildContext)? _onUnauthorizedEdit;
  ///
  /// - [writeTagName] - the name of DataServer tag to send value
  /// - [responseTagName] - the name of DataServer tag to get response if value written
  /// - [users] - current stack of authenticated users
  /// tried to edit the value but not in list of allowed
  /// - [allowedGroups] - list of user group names allowed to edit this field
  /// - [responseTimeout] - timeout in seconds to wait server response
  const NetworkDropdownFormField({
    Key? key,
    List<String> allowedGroups = const [],
    AppUserStacked? users,
    DsClient? dsClient,
    DsPointName? writeTagName,
    String? responseTagName,
    String? labelText,
    double width = 350.0,
    void Function(BuildContext)? onUnauthorizedEdit,
    required OilData oilData,
    Duration responseTimeout = const Duration(seconds: 5),
  }) : 
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _labelText = labelText,
    _width = width,
    _oilData = oilData,
    _responseTimeout = responseTimeout,
    _onUnauthorizedEdit = onUnauthorizedEdit,
    super(key: key);
  //
  @override
  State<NetworkDropdownFormField> createState() => _NetworkDropdownFormFieldState(
    allowedGroups: _allowedGroups,
    users: _users,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    labelText: _labelText,
    width: _width,
    oilData: _oilData,
    responseTimeout: _responseTimeout,
    onUnauthorizedEdit: _onUnauthorizedEdit,
  );
}
///
class _NetworkDropdownFormFieldState extends State<NetworkDropdownFormField> {
  static final _log = const Log('_NetworkDropdownFormFieldState')..level = LogLevel.debug;
    final dropdownState = GlobalKey<FormFieldState>();
  final _state = NetworkOperationState(isLoading: true);
  final OilData _oilData;
  final List<String> _allowedGroups;
  late AppUserStacked? _users;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final String? _labelText;
  final double _width;
  void Function(BuildContext) _onUnauthorizedEdit;
  final Duration _responseTimeout;
  bool _accessAllowed = false;
  int? _dropdownValue;
  int? _initValue;
  List<String> _oilNames = [];
  ///
  _NetworkDropdownFormFieldState({
    required List<String> allowedGroups,
    required AppUserStacked? users,
    required DsClient? dsClient,
    required DsPointName? writeTagName,
    required String? responseTagName,
    required String? labelText,
    required double width,
    required OilData oilData,
    required Duration responseTimeout,
    void Function(BuildContext)? onUnauthorizedEdit,
  }) :
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _labelText = labelText,
    _width = width,
    _oilData = oilData,
    _responseTimeout = responseTimeout,
    _onUnauthorizedEdit = onUnauthorizedEdit ?? showUnauthorizedEditingFlushbar,
    super();
  //
  @override
  void initState() {
    super.initState();
    _oilData.names()
      .then((value) {
        setState(() {
          _oilNames = value;
        });
      });
  }
  //
  @override
  Widget build(BuildContext context) {
    final width = _width;
    final _dropMenuItemWidth = width * 0.7;
    final stateColors = Theme.of(context).stateColors;
    final dsClient = _dsClient;
    final responseTagName = _buildResponseTagName(_responseTagName,  _writeTagName);
    return SizedBox(
      width: _width,
      child: StreamBuilder<DsDataPointExtracted<int>>(
        stream: DsDataStreamExtract<int>(
          stream: (dsClient != null && responseTagName != null) 
            ? dsClient.streamInt(responseTagName) 
            : null,
          stateColors: stateColors,
        ).stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final point = snapshot.data;
            if (point != null) {
              _initValue = point.value;
              _dropdownValue = _initValue;
              _state.setLoaded();
            }
          }
          return DropdownButtonFormField<int>(
            key: dropdownState,
            value: _dropdownValue,
            onChanged: (newValue) {
              _log.debug('[.onChanged] value: $newValue');
              if (newValue != _initValue) {
                dropdownState.currentState?.didChange(_initValue);
              }
              _requestAccess(context).then((value) {
                if (_accessAllowed) {
                  _sendValue(_dsClient, _writeTagName, _responseTagName, newValue);
                }
              });
            },
            decoration: InputDecoration(
              labelText: _labelText,
              labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
              ),
              suffixIcon: _buildSufixIcon(),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            alignment: AlignmentDirectional.centerEnd,
            items: _buildDropdownMenuItems(context, _oilNames, _dropMenuItemWidth), 
          );
        },
      ),
    );
  }
  ///
  void _sendValue(DsClient? dsClient, DsPointName? writeTagName, String? responseTagName, int? newValue) {
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      setState(() {
        _state.setSaving();
      });
      DsSend<int>(
        dsClient: dsClient, 
        pointName: writeTagName, 
        responseTimeout: _responseTimeout,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr, DsCot.inf],
      )
        .exec(value)
        .then((responseValue) {
          if (mounted) {
            setState(() {
              _state.setSaved();
              if (responseValue case Err(error: final _)) {
                _state.setChanged();
              }
            });
          }
        });
    }
  }
  ///
  List<DropdownMenuItem<int>> _buildDropdownMenuItems(BuildContext context, List<String> oilNames, double width) {
    return oilNames.asMap().map((index, name) {
      _log.debug('[._buildDropdownMenuItems]');
      return MapEntry(
        index, 
        DropdownMenuItem<int>(
          value: index,
          child: SizedBox(width: width, child: Text(name, textAlign: TextAlign.center)),
          alignment: Alignment.center,
        ),
      );
    }).values.toList();
  }
  ///
  String? _buildResponseTagName(String? responseTagName, DsPointName? writeTagName) {
    if (responseTagName != null) {
      return responseTagName;
    }
    if (writeTagName != null) {
      return writeTagName.name;
    }
    return null;
  }
  ///
  Widget? _buildSufixIcon() {
    if (_state.isLoading || _state.isSaving) {
      return _buildProgressIndicator(); 
    }
    if (_state.isChanged) {
      return const Icon(Icons.info_outline);
    }
    if (_state.isSaved) {
      return Icon(Icons.check, color: Theme.of(context).primaryColor);
    }
    return null;
  }
  ///
  Widget _buildProgressIndicator() {
    return const SizedBox(
      width: 13, height: 13,
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: CircularProgressIndicator(strokeWidth: 3,),
      ),
    );
  }
  /// Проверяет наличие доступа у текущего пользователя 
  /// на редактирования данного поля
  Future<void> _requestAccess(BuildContext context) async {
    if (_allowedGroups.isEmpty) {
      _accessAllowed = true;
      return;
    }
    final users = _users;
    if (users != null) {
      final user = users.peek;
      if (user.exists()) {
        final userGroups = user.userGroups();
        if(
          _allowedGroups.any(
            (allowedGroup) => userGroups.contains(allowedGroup),
          )
        ) {
          _accessAllowed = true;
          return;
        }
      }
    }
    _accessAllowed = false;
    _onUnauthorizedEdit(context);
  }
}
