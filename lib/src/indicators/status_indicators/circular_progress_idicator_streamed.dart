import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';

class CircularProgressIndicatorStreamed extends StatelessWidget {
  final Stream<int>? _stream;
  ///
  const CircularProgressIndicatorStreamed({
    super.key,
    required Stream<int>? stream,
  }) :
    _stream = stream;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null) {
            if (data == stateIsLoading) {
              return const FittedBox(child: CupertinoActivityIndicator());
            }
            if (data == stateIsLoaded) {
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
