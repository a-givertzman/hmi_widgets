import 'package:hmi_core/hmi_core.dart';
///
class FakeTextFile implements TextFile {
  final String _content;
  const FakeTextFile(this._content);
  @override
  Future<String> get content => Future.value(_content);

}