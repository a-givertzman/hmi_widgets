import 'package:example/pages/edit_fields/fake_oil_data.dart';
import 'package:flutter/material.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class EditFieldsPage extends StatelessWidget {
  EditFieldsPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Fields'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Text('Date Edit Field'),
                SizedBox(
                  width: 300,
                  child: DateEditField(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Text('Network Edit Field'),
                SizedBox(
                  width: 300,
                  child: NetworkEditField<double>(
                    passwordKey: 'passwordKey',
                    labelText: 'TestField',
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: const [
              Text('Date Dropdown Form Field'),
              SizedBox(
                width: 300,
                child: NetworkDropdownFormField(
                  passwordKey: 'passwordKey',
                  oilData: FakeOilData(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}