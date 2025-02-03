import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_stream.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
enum LoadingUntil {
  writeTagResponded,
  responseTagResponded,
}
///
/// Кнопка посылает значение bool / int / real в DsClient
class DropDownControlButton extends StatefulWidget {
  final BufferedStream<bool>? _disabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final LoadingUntil _loadingUntil;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  ///
  const DropDownControlButton({
    Key? key,
    BufferedStream<bool>? disabledStream,
    Map<int, Stream<bool>>? itemsDisabledStreams,
    double? width,
    double? height,
    DsClient? dsClient,
    DsPointName? writeTagName,
    String? responseTagName,
    required Map<int, String> items,
    String? tooltip,
    String? label,
    LoadingUntil loadingUntil = LoadingUntil.responseTagResponded,
  }) : 
    _disabledStream = disabledStream,
    _itemsDisabledStreams = itemsDisabledStreams,
    _width = width,
    _height = height,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _items = items,
    _tooltip = tooltip,
    _label = label,
    _loadingUntil = loadingUntil,
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<DropDownControlButton> createState() => _DropDownControlButtonState(
    isDisabledStream: _disabledStream,
    itemsDisabledStreams: _itemsDisabledStreams,
    width: _width,
    height: _height,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    responseStream: _buildResponseSTream(_dsClient, _responseTagName ?? _writeTagName?.name),
    items: _items,
    tooltip: _tooltip,
    label: _label,
    loadingUntil: _loadingUntil,
  );
  ///
  BufferedStream<DsDataPoint<int>>? _buildResponseSTream(DsClient? dsClient, String? tagName) {
    if (dsClient != null){
      if (tagName != null) {
        return BufferedStream<DsDataPoint<int>>(
          dsClient.streamInt(tagName),
          initValue: DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/test/test/test'), value: -1, status: DsStatus.ok, cot: DsCot.inf, timestamp: DsTimeStamp.now().toString()),
        );
      }
    }
    return null;
  }
}

///
class _DropDownControlButtonState extends State<DropDownControlButton> with TickerProviderStateMixin {
  final _log = Log('$_DropDownControlButtonState')..level = LogLevel.debug;
  final _state = NetworkOperationState(isLoading: true);
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final BufferedStream<DsDataPoint<int>>? _responseStream;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  final BufferedStream<bool>? _isDisabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final List<StreamSubscription> _itemDisabledSuscriptions = [];
  final Map<int, bool> _itemsDisabled = {};
  late AnimationController _animationController;
  final StreamController<Null> _streamController = StreamController<Null>();
  final LoadingUntil _loadingUntil;
  ///
  _DropDownControlButtonState({
    required BufferedStream<bool>? isDisabledStream,
    required Map<int, Stream<bool>>? itemsDisabledStreams,
    required double? width,
    required double? height,
    required DsClient? dsClient,
    required DsPointName? writeTagName,
    required String? responseTagName,
    required BufferedStream<DsDataPoint<int>>? responseStream,
    required Map<int, String> items,
    required String? tooltip,
    required String? label,
    required LoadingUntil loadingUntil,
  }) :
    _isDisabledStream = isDisabledStream,
    _itemsDisabledStreams = itemsDisabledStreams,
    _width = width,
    _height = height,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _responseStream = responseStream,
    _items = items,
    _tooltip = tooltip,
    _label = label,
    _loadingUntil = loadingUntil,
    super();
  //
  @override
  void initState() {
    _log.info('[.initState] before super.initState');
    super.initState();
    _log.info('[.initState] after super.initState');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    );    
    final itemsDisabledStreams = _itemsDisabledStreams;
    itemsDisabledStreams?.forEach((index, itemDisabledStream) {
      final itemDisabledSuscription = itemDisabledStream.listen((event) {
        _log.debug('[.initState] index: $index\tevent: $event');
        _itemsDisabled[index] = event;
      });
      _itemDisabledSuscriptions.add(itemDisabledSuscription);
    });
    final responseStream = _responseStream;
    responseStream?.stream.listen((event) {
      if (_state.isLoading) {
        _state.setLoaded();
      }
      _streamController.add(null);
    });
    final isDisabledStream = _isDisabledStream;
    isDisabledStream?.stream.listen((event) {
      _streamController.add(null);      
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    final width = _width;
    final height = _height;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    return StreamBuilder<Null>(
      stream: _streamController.stream,
      builder: (context, snapshots) {
        int? _lastSelectedValue = _responseStream?.value?.value ?? _responseStream?.initialValue?.value;
        bool _isDisabled = _isDisabledStream?.value ?? _isDisabledStream?.initialValue ?? false;
        _log.debug('[.build] _lastSelectedValue: $_lastSelectedValue');
        _log.debug('[.build] isDisabled: $_isDisabled');
        return PopupMenuButtonCustom<int>(
          offset: Offset(width != null ? width * 0.7 : 100, height ?? 0),
          enabled: !_isDisabled,
          tooltip: _tooltip,
          customButtonBuilder: (onTap) {
            return Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilters.disabled(context, _isDisabled),
                  child: SizedBox(
                    width: _width,
                    height: _height,
                    child: ElevatedButton(
                      onPressed: onTap, 
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return _buildButtonIcon(_lastSelectedValue, textColor, _animationController.value);
                        },
                      ),
                    ),
                  ),
                ),
                if (_state.isLoading || _state.isSaving) Positioned.fill(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            );
          },
          itemBuilder: (context) {
            return _items.map((index , item) {
              return MapEntry(
                index, 
                PopupMenuItem<int>(
                  key: UniqueKey(),
                  value: index,
                  enabled: !_itemIsDisabled(index),
                  onTap: () {
                    // TODO onTap action to be implemented
                  },
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _itemIsDisabled(index)
                        ? textColor.withValues(alpha: 0.3)
                        : textColor,
                    ),
                  ),
                ),
              );
            }).values.toList();
          },
          onCanceled: () {
            _log.debug('[.build] onCanceled');
          },
          onSelected: (value) {
            _log.debug('[.build] onSelected: value: $value');
            if (_items.containsKey(value)) {
              final sendValue = value;
              if (sendValue != _lastSelectedValue) {
                _sendValue(_dsClient, _writeTagName, _responseTagName, sendValue);
              }
            }
          },
        );
      },
    );
  }
  ///
  bool _itemIsDisabled(int index) {
    return _itemsDisabled.containsKey(index) ? _itemsDisabled[index] ?? false : false;
  }
  ///
  Widget _buildButtonIcon(int? value, Color color, double animationValue) {
    final label = _label;
    final selectedItem = _items[value];
    if (selectedItem == null) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    return Stack(
      children: [
        if (label != null) Transform.scale(
              scale: 1 - 0.2 * animationValue,
              child: Transform.translate(
                offset: Offset(0.0, - (Theme.of(context).textTheme.titleMedium?.fontSize ?? 18) * 0.07 * animationValue),
                child: Text(label),
              ),
            ),
        if (selectedItem != null) Center(
          child: Text(
            selectedItem,
            style: Theme.of(context).textTheme.titleMedium!.apply(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  ///
  void _sendValue(DsClient? dsClient, DsPointName? writeTagName, String? responseTagName, int? newValue) {
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      if (mounted) setState(() => _state.setSaving());
      DsSend<int>(
        dsClient: dsClient, 
        pointName: writeTagName,
        response: switch(_loadingUntil) {
          LoadingUntil.writeTagResponded => null,
          LoadingUntil.responseTagResponded => _responseTagName,
        },
        cot: DsCot.act,
        responseCots: switch(_loadingUntil) {
          LoadingUntil.writeTagResponded => [DsCot.actCon, DsCot.actErr],
          LoadingUntil.responseTagResponded => [DsCot.inf],
        },
      )
      .exec(value)
      .then((responseValue) {
        if (mounted) setState(() => _state.setSaved());
      });
    }
  }  
  //
  @override
  void dispose() {
    for (var suscription in _itemDisabledSuscriptions) {
      suscription.cancel();
    }
    super.dispose();
  }
}
