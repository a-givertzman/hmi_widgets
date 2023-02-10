import 'package:example/core/get_random_stream.dart';
import 'package:example/pages/charts/fake_swl_data.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class ChartsPage extends StatelessWidget {
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
            FutureBuilder(
              future: CraneLoadChartLegendJson(
                JsonList.fromTextFile(
                  const TextFile.asset('assets/configs/legend.json'),
                ),
              ).decoded,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CraneLoadChart(
                    swlIndexStream: getRandomDataPointStream(
                      (random) => random.nextInt(2),
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
                        legendData: snapshot.data!,
                        swlData: FakeSwlData(
                          rawWidth: _rawWidth, 
                          rawHeight: _rawHeight,
                          maxSwlValue: 20000.0,
                          swlIndexesCount: 2, 
                          pointsCount: 500,
                        ),
                      ),
                    ),
                    pointSize: 5.0,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}