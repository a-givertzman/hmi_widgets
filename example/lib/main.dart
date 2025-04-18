import 'package:example/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.initialize(level: LogLevel.all);
  DataSource.initialize({
    'app-user': DataSet<Map<String, String>>(
      params: ApiParams( <String, dynamic>{
        'api-sql': 'select',
        'tableName': 'app_user',
      }),
      apiRequest: const ApiRequest(
        url: '127.0.0.1',
        api: '/get-app-user',
        port: 8080,
      ),
    ),
  });
  await AppSettings.initialize(
    jsonMap: JsonMap<String>.fromTextFile(
      const TextFile.asset('assets/configs/app_ui_settings_config.json'),
    ),
  );
  runApp(const MyApp());
}
///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HMI Widgets Demo',
      theme: appThemes[AppTheme.dark],
      home: const HomePage(),
    );
  }
}