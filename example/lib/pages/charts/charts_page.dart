import 'package:example/core/get_random_stream.dart';
import 'package:example/pages/charts/fake_swl_data.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ChartsPage extends StatelessWidget {
  final _swlLimitSet = const [0.3, 0.5, 0.7, 1.1];
  final _swlColorSet = const [Colors.grey, Colors.green, Colors.blue, Colors.red];
  final _swlNameSet = const ['Limit1', 'Limit2', 'Limit3', 'Limits4'];
  final _width = 450.0; 
  final _height = 450.0;
  final _rawWidth = 20.0;
  final _rawHeight = 27.0;
  const ChartsPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CraneLoadChart(
              swlIndexStream: getRandomDataPointStream(
                (random) => random.nextInt(4),
              ),
              xAxisValue: 5.0, 
              yAxisValue: 5.0,
              backgroundColor: Theme.of(context).colorScheme.background, 
              swlDataCache: SwlDataCache(
                swlDataConverter: SwlDataConverter(
                  height: _height, 
                  width: _width,
                  rawWidth: _rawWidth, 
                  rawHeight: _rawHeight, 
                  legendData: CraneLoadChartLegendData(
                    limits: _swlLimitSet, 
                    colors: _swlColorSet, 
                    names: _swlNameSet,
                  ),
                  swlData: FakeSwlData(
                    rawWidth: _rawWidth, 
                    rawHeight: _rawHeight,
                    swlIndexesCount: 5, 
                    pointsCount: 500,
                  ),
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