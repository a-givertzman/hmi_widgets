import 'package:example/core/get_random_stream.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ProccessPage extends StatelessWidget {
  const ProccessPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Widgets')),
      body: ListView(  
        padding: const EdgeInsets.all(4.0),      
        children: [
          Column(
            children: [
              const Text('AC Drive'),
              AcDriveWidget(
                stream: getRandomDataPointStream(
                  (random) => random.nextInt(4),
                ).asBroadcastStream(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}