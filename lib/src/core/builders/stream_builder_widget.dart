import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/core/builders/async_snapshot_builder_widget.dart';
///
/// A builder to easily display widgets depending on a corresponding state of [AsyncSnapshot] from [StreamBuilder].
class StreamBuilderWidget<T> extends StatefulWidget {
  final ResultF<T>? _initialData;
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Stream<ResultF<T>> Function() _onStream;
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, Object, void Function())? _caseError;
  final Widget Function(BuildContext, void Function())? _caseNothing;
  final bool Function(T)? _validateData;
  ///
  /// A builder to easily display widgets depending on a corresponding state of [AsyncSnapshot] from [StreamBuilder].
  /// 
  /// - [onStream] - a callback to create stream, e.g. start loading of data;
  /// - [caseData] - widget builder to be used if stream has event with data;
  /// - [caseLoading] - widget builder to be used if stream is in progress (stream started, but there are no data events yet);
  /// - [caseError] - widget builder to be used if stream completed with error;
  /// - [caseNothing] - widget builder to be used if there are no loading, data or error states, e.g. initial state;
  /// - [validateData] - a callback to be used on data and to optionally traverse to error state if validation case is not satisfied;
  /// - [initialData] - optional first event of the stream.
  /// 
  /// Only data builder is required, other builders will use default indication of [AsyncSnapshot] state.
  /// 
  /// Minimal usage example (displays aquired data as text):
  /// ```dart
  /// StreamBuilderWidget(
  ///   onStream: () => Stream.periodic(Duration.zero, (i) => i),
  ///   caseData: (context, data, retry) => Text(data.toString()),
  /// );
  /// ```
  const StreamBuilderWidget({
    super.key,
    required Stream<ResultF<T>> Function() onStream,
    required Widget Function(BuildContext context, T data, void Function() retry) caseData,
    Widget Function(BuildContext context)? caseLoading,
    Widget Function(BuildContext context, Object error, void Function() retry)? caseError,
    Widget Function(BuildContext context, void Function() retry)? caseNothing,
    ResultF<T>? initialData,
    bool Function(T data)? validateData,
  }) : 
    _validateData = validateData, 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onStream = onStream,
    _initialData = initialData;
  //
  @override
  State<StreamBuilderWidget<T>> createState() => _StreamBuilderWidgetState<T>();
}
///
class _StreamBuilderWidgetState<T> extends State<StreamBuilderWidget<T>> {
  late Stream<ResultF<T>> _stream;
  //
  @override
  void initState() {
    _stream = widget._onStream();
    super.initState();
  }
  ///
  void _retry() {
    setState(() {
      _stream = widget._onStream();
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: widget._initialData,
      stream: _stream, 
      builder: (context, snapshot) {
        return AsyncSnapshotBuilderWidget(
          snapshot: snapshot,
          caseData: widget._caseData,
          caseLoading: widget._caseLoading,
          caseError: widget._caseError,
          caseNothing: widget._caseNothing,
          retry: _retry,
          validateData: widget._validateData,
        );
      },
    );
  }
}
