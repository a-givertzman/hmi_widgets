import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';

class CraneLoadChartLegendWidget extends StatelessWidget {
  final SwlDataCache _swlDataCache;
  final int _swlIndex;
  ///
  const CraneLoadChartLegendWidget({
    Key? key,
    required SwlDataCache swlDataCache,
    required int swlIndex,
  }) : 
    _swlDataCache = swlDataCache, 
    _swlIndex = swlIndex, 
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _swlDataCache.legendData.limits,
        _swlDataCache.legendData.colors,
        _swlDataCache.legendData.names,
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final limits = (snapshot.data![0] as Iterable<Iterable<double>>)
            .elementAt(_swlIndex);
          final colors = (snapshot.data![1] as Iterable<Iterable<Color>>)
            .elementAt(_swlIndex);
          final names = (snapshot.data![2] as Iterable<Iterable<String>>)
            .elementAt(_swlIndex);
          
          return SizedBox(
            width: 68,
            height: names.length * 28,
            child: Column(
              children: [
                for (int i = 0; i < limits.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: 24,
                      width: 64,
                      color: colors.elementAt(i),
                      child: Center(
                        child: Text(
                          '${names.elementAt(i)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        else {
          return const SizedBox(
            width: 64,
            height: 64,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Center(
                child: CircularProgressIndicator()
              ),
            ),
          );
        }
      },
    );
  }
}