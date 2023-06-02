import 'package:example/pages/edit_fields/fake_oil_data.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class EditFieldsPage extends StatelessWidget {
  ///
  const EditFieldsPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Fields'),
      ),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Date Edit Field'),
                SizedBox(
                  width: 300,
                  child: DateEditField(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Network Edit Field'),
                SizedBox(
                  width: 300,
                  child: NetworkEditField<double>(
                    labelText: 'TestField',
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text('Network Dropdown Form Field'),
              SizedBox(
                width: 300,
                child: NetworkDropdownFormField(
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