import 'package:example/core/get_random_stream.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ButtonsPage extends StatelessWidget {
  ///
  const ButtonsPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Buttons'),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ControlButton(
                    stream: getRandomDataPointStream((random) => random.nextInt(4)),
                    stateValues: const ['State 1', 'State 2', 'State 3', 'State 4'],
                    onPressed: () {},
                    caption: 'States',
                    width: 250,
                    height: 56,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropDownControlButton(
                    disabledStream: BufferedStream(
                      getRandomStream(
                        (random) => random.nextBool(),
                        duration: const Duration(seconds: 3),
                      ),
                    ),
                    items: const {
                      1: 'Item 1',
                      2: 'Item 2',
                      3: 'Item 3',
                      4: 'Item 4',
                    },
                    label: 'Items',
                    width: 250,
                    height: 56,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}