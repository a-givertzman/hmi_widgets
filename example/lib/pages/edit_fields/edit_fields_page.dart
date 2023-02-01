import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class EditFieldsPage extends StatelessWidget {
  const EditFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Fields'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: [
          Column(
            children: const [
              Text('Date Edit Field'),
              SizedBox(
                width: 300,
                child: DateEditField(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}