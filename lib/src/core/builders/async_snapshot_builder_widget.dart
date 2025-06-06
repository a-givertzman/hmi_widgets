import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/src/core/error_message_widget.dart';

/// 
/// Default indicator builder for [AsyncSnapshotBuilderWidget] loading state
Widget _defaultCaseLoading(BuildContext _) => const Center(
  child: CupertinoActivityIndicator(),
);
///
/// Default indicator builder for [AsyncSnapshotBuilderWidget] error state
Widget _defaultCaseError(BuildContext _, Object error, void Function() __) => ErrorMessageWidget(
  message: 'Data loading error'.loc,
);
///
/// Default indicator builder for [AsyncSnapshotBuilderWidget] empty-data state
Widget _defaultCaseNothing(BuildContext _, void Function() __) => ErrorMessageWidget(
  message: 'No data'.loc,
);
///
/// A builder to easily display widgets depending on a corresponding state of [AsyncSnapshot].
/// Intended to use under [FutureBuilder], [StreamBuilder] or custom async builder.
class AsyncSnapshotBuilderWidget<T> extends StatelessWidget {
  final void Function() _retry;
  final Widget Function(BuildContext) _caseLoading;
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Widget Function(BuildContext, Object, void Function()) _caseError;
  final Widget Function(BuildContext, void Function()) _caseNothing;
  late final _AsyncSnapshotState<T> _snapshotState;
  ///
  /// A builder to easily display widgets depending on a corresponding state of [AsyncSnapshot].
  /// Intended to use under [FutureBuilder], [StreamBuilder] or custom async builder.
  /// 
  /// - [snapshot] - async snapshot from parent builder;
  /// - [caseData] - widget builder to be used if snapshot has any data;
  /// - [caseLoading] - widget builder to be used if async operation is in progress;
  /// - [caseError] - widget builder to be used if async operation ended with an error;
  /// - [caseNothing] - widget builder to be used if there are no loading, data or error states, e.g. initial state;
  /// - [retry] - a callback to trigger a restart of async operation, e.g. call future again or recreate stream. Will be provided to some builders for button action etc.;
  /// - [validateData] - a callback to be used on data and to optionally traverse to error state if validation case is not satisfied.
  /// 
  /// Only data builder is required, other builders will use default indication of [AsyncSnapshot] state.
  /// 
  /// Minimal usage example (display aquired text, do nothing on retry):
  /// ```dart
  /// FutureBuilder(
  ///   future: Future.delayed(Duration.zero, () => 1),
  ///   builder: (context, snapshot) => AsyncSnapshotBuilderWidget(
  ///     snapshot: snapshot,
  ///     caseData: (context, data, retry) => Text(data.toString()),
  ///     retry: () {},
  ///   ),
  /// );
  /// ```
  AsyncSnapshotBuilderWidget({
    super.key,
    required AsyncSnapshot<ResultF<T>> snapshot,
    required Widget Function(BuildContext context, T data, void Function() retry) caseData,
    Widget Function(BuildContext context)? caseLoading,
    Widget Function(BuildContext context, Object error, void Function() retry)? caseError,
    Widget Function(BuildContext context, void Function() retry)? caseNothing,
    required void Function() retry,
    bool Function(T)? validateData,
  }) :
    _caseData = caseData,
    _caseLoading = caseLoading ?? _defaultCaseLoading,
    _caseError = caseError ?? _defaultCaseError,
    _caseNothing = caseNothing ?? _defaultCaseNothing,
    _retry = retry {
    _snapshotState = _AsyncSnapshotState.fromSnapshot(
      snapshot,
      validateData,
    );
  }
  //
  @override
  Widget build(BuildContext context) {
    return switch(_snapshotState) {
      _LoadingState() => _caseLoading.call(context),
      _NothingState() => _caseNothing.call(context, _retry),
      _DataState<T>(:final data) => _caseData.call(context, data, _retry),
      _ErrorState(:final error) => _caseError.call(context, error, _retry),
    };
  }
}
///
sealed class _AsyncSnapshotState<T> {
  factory _AsyncSnapshotState.fromSnapshot(
    AsyncSnapshot<ResultF<T>> snapshot,
    bool Function(T)? validateData,
  ) {
    return switch(snapshot) {
      AsyncSnapshot(
        connectionState: ConnectionState.waiting,
      ) => const _LoadingState(),
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: true,
        requireData: final result,
      ) => switch(result) {
        Ok(:final value) => switch(validateData?.call(value) ?? true) {
          true => _DataState(value),
          false => _ErrorState(
            Failure(
              message: 'Invalid data',
              stackTrace: StackTrace.current,
            ),
          ) as _AsyncSnapshotState<T>,
        },
        Err(:final error) => _ErrorState(error),
      },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) => _ErrorState(
        Failure(
          message: error?.toString() ?? 'Something went wrong',
          stackTrace: stackTrace ?? StackTrace.current,
        ),
      ),
      _ => const _NothingState(),
    };
  }
}
///
final class _LoadingState implements _AsyncSnapshotState<Never> {
  const _LoadingState();
}
///
final class _NothingState implements _AsyncSnapshotState<Never> {
  const _NothingState();
}
///
final class _DataState<T> implements _AsyncSnapshotState<T> {
  final T data;
  const _DataState(this.data);
}
///
final class _ErrorState implements _AsyncSnapshotState<Never> {
  final Failure error;
  const _ErrorState(this.error);
}