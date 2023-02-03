import 'package:example/pages/buttons/buttons_page.dart';
import 'package:example/pages/charts/charts_page.dart';
import 'package:example/pages/edit_fields/edit_fields_page.dart';
import 'package:example/pages/process/process_page.dart';
import 'package:flutter/material.dart';
import 'home_menu_button.dart';
///
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HMI Widgets Example'),
      ),
      body: ListView(
        children: [
          HomeMenuButton(
            text: 'Buttons',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ButtonsPage(),
              ),
            ),
          ),
          HomeMenuButton(
            text: 'Charts',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ChartsPage(),
              ),
            ),
          ),
          const HomeMenuButton(
            text: 'Status Indicators',
          ),
          const HomeMenuButton(
            text: 'Value Indicators',
          ),
          HomeMenuButton(
            text: 'Process Widgets',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProccessPage(),
              ),
            ),
          ),
          HomeMenuButton(
            text: 'Edit fields',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EditFieldsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}