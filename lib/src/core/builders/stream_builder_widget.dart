import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/core/builders/async_snapshot_builder_widget.dart';
///
class StreamBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Stream<ResultF<T>> Function() _onStream;
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, Object, void Function())? _caseError;
  final Widget Function(BuildContext, void Function())? _caseNothing;
  final bool Function(T)? _validateData;
  ///
  const StreamBuilderWidget({
    super.key, 
    required Stream<ResultF<T>> Function() onStream,
    required Widget Function(BuildContext context, T data, void Function() retry) caseData,
    Widget Function(BuildContext context)? caseLoading,
    Widget Function(BuildContext context, Object error, void Function() retry)? caseError,
    Widget Function(BuildContext context, void Function() retry)? caseNothing, 
    bool Function(T data)? validateData,
  }) : 
    _validateData = validateData, 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onStream = onStream;
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
