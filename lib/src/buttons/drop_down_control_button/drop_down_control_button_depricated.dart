import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/src/core/color_filters.dart';
import 'package:hmi_widgets/src/popups/popup_menu_button/popup_menu_button_custom.dart';
///
/// Кнопка посылает значение bool / int / real в DsClient
class DropDownControlButtonDepricated extends StatefulWidget {
  final Stream<bool>? _disabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  ///
  const DropDownControlButtonDepricated({
    Key? key,
    Stream<bool>? disabledStream,
    Map<int, Stream<bool>>? itemsDisabledStreams,
    double? width,
    double? height,
    DsClient? dsClient,
    DsPointName? writeTagName,
    String? responseTagName,
    required Map<int, String> items,
    String? tooltip,
    String? label,
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
    super(key: key);
  //
  @override
  // ignore: no_logic_in_create_state
  State<DropDownControlButtonDepricated> createState() => _DropDownControlButtonState(
    isDisabledStream: _disabledStream,
    itemsDisabledStreams: _itemsDisabledStreams,
    width: _width,
    height: _height,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    items: _items,
    tooltip: _tooltip,
    label: _label,
  );
}

///
class _DropDownControlButtonState extends State<DropDownControlButtonDepricated> with TickerProviderStateMixin {
  static const _log = Log('_DropDownControlButtonState');
  final _state = NetworkOperationState(isLoading: true);
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointName? _writeTagName;
  final String? _responseTagName;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  final Stream<bool>? _isDisabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final List<StreamSubscription> _itemDisabledSuscriptions = [];
  final Map<int, bool> _itemsDisabled = {};
  late AnimationController _animationController;
  int _lastSelectedValue = -1;
  bool _isDisabled = false;
  final StreamController<DoubleContainer<DsDataPoint<int>, bool>> _streamController = StreamController<DoubleContainer<DsDataPoint<int>, bool>>();
  ///
  _DropDownControlButtonState({
    required Stream<bool>? isDisabledStream,
    required Map<int, Stream<bool>>? itemsDisabledStreams,
    required double? width,
    required double? height,
    required DsClient? dsClient,
    required DsPointName? writeTagName,
    required String? responseTagName,
    required Map<int, String> items,
    required String? tooltip,
    required String? label,
  }) :
    _isDisabledStream = isDisabledStream,
    _itemsDisabledStreams = itemsDisabledStreams,
    _width = width,
    _height = height,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _items = items,
    _tooltip = tooltip,
    _label = label,
    super();
  //
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    );    
    final itemsDisabledStreams = _itemsDisabledStreams;
    if (itemsDisabledStreams != null) {
      itemsDisabledStreams.forEach((index, itemDisabledStream) {
        final itemDisabledSuscription = itemDisabledStream.listen((event) {
          _log.debug('[.initState] index: $index\tevent: $event');
          _itemsDisabled[index] = event;
        });
        _itemDisabledSuscriptions.add(itemDisabledSuscription);
      });
    }
    final dsClient = _dsClient;
    final responseTagName = _buildResponseTagName(_responseTagName,  _writeTagName);
    if (dsClient != null && responseTagName != null) {
      dsClient.streamInt(responseTagName).listen((pointExtracted) {
        if (_state.isLoading) {
          _state.setLoaded();
        }
        _streamController.add(
          DoubleContainer<DsDataPoint<int>, bool>(value1: pointExtracted),
        );
      });
    }
    final isDisabledStream = _isDisabledStream ?? const Stream.empty();
    isDisabledStream.listen((event) {
      _streamController.add(
        DoubleContainer<DsDataPoint<int>, bool>(value2: event),
      );      
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    final width = _width;
    final height = _height;
    final backgroundColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    return StreamBuilder<DoubleContainer<DsDataPoint<int>, bool>>(
      stream: _streamController.stream,
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          final point = snapshots.data?.value1;
          _lastSelectedValue = point?.value ?? _lastSelectedValue;
          _isDisabled = snapshots.data?.value2 ?? _isDisabled;
        }
        _log.debug('.build isDisabled: $_isDisabled');
        return PopupMenuButtonCustom<int>(
          // color: backgroundColor,
          offset: Offset(width != null ? width * 0.7 : 100, height ?? 0),
          enabled: !_isDisabled,
          tooltip: _tooltip,
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilters.disabled(context, _isDisabled),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  width: _width,
                  height: _height,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return _buildButtonIcon(_lastSelectedValue, textColor, _animationController.value);
                    },
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
          ),
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
            _log.debug('[$_DropDownControlButtonState] onCanceled');
          },
          onSelected: (value) {
            _log.debug('[$_DropDownControlButtonState] onSelected: $value');
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
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.apply(
                    color: color.withValues(alpha: 1 - 0.2 * animationValue),
                  ),
                ),
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
        // return Text(
        //   '${_items[value]}',
        //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
        //     color: color,
        //   ),
        // );
      // }
    // }
    // return Text(
    //   '$_label',
    //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //     color: color,
    //   ),
    // );
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
  void _sendValue(DsClient? dsClient, DsPointName? writeTagName, String? responseTagName, int? newValue) {
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      if (mounted) setState(() => _state.setSaving());
      DsSend<int>(
        dsClient: dsClient, 
        pointName: writeTagName, 
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr, DsCot.inf],
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
