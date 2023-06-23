import 'package:example/pages/buttons/buttons_page.dart';
import 'package:example/pages/charts/charts_page.dart';
import 'package:example/pages/edit_fields/edit_fields_page.dart';
import 'package:example/pages/flushbar/flush_bar_page.dart';
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
          MenuButton(
            text: 'Buttons',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ButtonsPage(),
              ),
            ),
          ),
          MenuButton(
            text: 'Charts',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ChartsPage(),
              ),
            ),
          ),
          const MenuButton(
            text: 'Status Indicators',
          ),
          const MenuButton(
            text: 'Value Indicators',
          ),
          MenuButton(
            text: 'Process Widgets',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProccessPage(),
              ),
            ),
          ),
          MenuButton(
            text: 'Edit fields',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const EditFieldsPage(),
              ),
            ),
          ),
          MenuButton(
            text: 'FlushBar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FlushBarPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}