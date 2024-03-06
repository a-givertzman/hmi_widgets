import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
class FakeTextFile implements TextFile {
  String contentText;
  FakeTextFile(this.contentText);
  @override
  Future<ResultF<String>> get content => Future.value(Ok(contentText));
  
  @override
  Future<void> write(String text) async {
    contentText = text;
  }

}