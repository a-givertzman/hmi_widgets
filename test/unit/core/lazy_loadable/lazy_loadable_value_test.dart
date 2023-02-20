import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_widgets/src/core/lazy_loadable.dart';
void main() {
  late int startValue;
  int increment() => ++startValue;
  setUp(() {
    startValue = 1;
  });
  test('LazyLoadable value', () async {
    final time = LazyLoadable(
      load: () => Future.value(
        increment(),
      ),
    );
    // final originalValue = await time.value;
    expect(await time.value, 2);
    expect(await time.value, 2);
  });
  test('LazyLoadable delayed value', () async {
    final time = LazyLoadable(
      load: () => Future.delayed(
        const Duration(milliseconds: 100),
        () => increment(),
      ),
    );
    expect(await time.value, 2);
    expect(await time.value, 2);
  });
}