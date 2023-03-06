import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';

class CircularProgressIndicatorStreamed extends StatelessWidget {
  final Stream<OperationState>? _stream;
  ///
  const CircularProgressIndicatorStreamed({
    super.key,
    required Stream<OperationState>? stream,
  }) :
    _stream = stream;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OperationState>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            if (data == OperationState.inProgress) {
              return const FittedBox(child: CupertinoActivityIndicator());
            }
            if (data == OperationState.success || data == OperationState.failure || data == OperationState.undefined) {
              return const Icon(null);
              // return Icon(Icons.account_tree_sharp, color: Theme.of(context).stateColors.on);
            }
          }
        }
        return const FittedBox(child: CupertinoActivityIndicator());
      },
    );
  }
}
