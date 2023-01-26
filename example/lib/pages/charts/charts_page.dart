import 'package:example/core/get_random_stream.dart';
import 'package:example/pages/charts/fake_swl_data.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class ChartsPage extends StatelessWidget {
  final _swlLimitSet = const [0.3, 0.5, 0.7];
  final _swlColorSet = const [Colors.green, Colors.blue, Colors.red];
  final _width = 450.0; 
  final _height = 450.0;
  final _rawWidth = 20.0;
  final _rawHeight = 27.0;
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CraneLoadChart(
              swlIndexStream: getRandomDataPointStream(
                (random) => random.nextInt(4),
              ),
              width: _width, 
              height: _height, 
              rawWidth: _rawWidth, 
              rawHeight: _rawHeight, 
              xAxisValue: 5.0, 
              yAxisValue: 5.0,
              swlLimitSet: _swlLimitSet, 
              swlColorSet: _swlColorSet, 
              backgroundColor: Theme.of(context).colorScheme.background, 
              swlDataCache: SwlDataCache(
                width: _width, 
                height: _height, 
                rawWidth: _rawWidth, 
                rawHeight: _rawHeight, 
                swlLimitSet: _swlLimitSet, 
                swlColorSet:_swlColorSet,
                swlData: FakeSwlData(
                  rawWidth: _rawWidth, 
                  rawHeight: _rawHeight,
                  swlIndexesCount: 5, 
                  pointsCount: 500,
                ),
              ),
              pointSize: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}