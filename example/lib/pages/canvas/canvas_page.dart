import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canvas')),
      body: CustomPaint(
        painter: PaintItems(
          items: [
            const PaintTrapezium(
              color: Colors.blueAccent,
              startWidth: 300,
              endWidth: 100,
              height: 600,
            )
            .translate(const Offset(0, 600))
            .flip(PaintFlipDirection.vertical)
          ],
        ),
      ),
    );
  }
}