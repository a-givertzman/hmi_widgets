import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/lazy_loadable.dart';

void main() {
  test('LazyLoadable value', () async {
    final time = LazyLoadable(
      load: () => Future.value(
        DateTime.now().microsecondsSinceEpoch,
      ),
    );
    final originalValue = await time.value;
    await Future.delayed(const Duration(microseconds: 100));
    expect(originalValue, await time.value);
  });
}