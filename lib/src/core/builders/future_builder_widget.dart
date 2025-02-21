import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/core/builders/async_snapshot_builder_widget.dart';
///
class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Future<ResultF<T>> Function() _onFuture;
  final Widget Function(BuildContext)? _caseLoading;
  final Widget Function(BuildContext, Object, void Function())? _caseError;
  final Widget Function(BuildContext, void Function())? _caseNothing;
  final bool Function(T)? _validateData;
  ///
  const FutureBuilderWidget({
    super.key, 
    required Future<ResultF<T>> Function() onFuture,
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
    _onFuture = onFuture;
  //
  @override
  State<FutureBuilderWidget<T>> createState() => _FutureBuilderWidgetState<T>();
}
///
class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  late Future<ResultF<T>> _future;
  //
  @override
  void initState() {
    _future = widget._onFuture();
    super.initState();
  }
  ///
  void _retry() {
    setState(() {
      _future = widget._onFuture();
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, 
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
