import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class CraneLoadChartLegendWidget extends StatelessWidget {
  final SwlDataCache _swlDataCache;
  final double _width;
  final TextAlign? _textAlign;
  final int _swlIndex;
  final Setting _padding;
  final Setting _margin;
  ///
  const CraneLoadChartLegendWidget({
    Key? key,
    required SwlDataCache swlDataCache,
    required int swlIndex,
    required double width,
    Setting padding = const Setting('padding', factor: 0.5),
    Setting margin = const Setting('padding', factor: 0.5),
    TextAlign? textAlign
  }) : 
    _swlDataCache = swlDataCache,
    _width = width,
    _padding = padding,
    _margin = margin,
    _textAlign = textAlign,
    _swlIndex = swlIndex, 
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    final padding = _padding.toDouble;
    return SizedBox(
      width: _width,
      child: FutureBuilder(
        future: Future.wait([
          _swlDataCache.legendData.colors,
          _swlDataCache.legendData.names,
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final colors = (snapshot.data![0] as Iterable<Iterable<Color>>)
              .elementAt(_swlIndex);
            final names = (snapshot.data![1] as Iterable<Iterable<String>>)
              .elementAt(_swlIndex);
            return ListView.separated(
              shrinkWrap: true,
              padding:  EdgeInsets.symmetric(
                vertical: padding, 
                horizontal: _margin.toDouble,
              ),
              itemBuilder: (_, i) => Container(
                padding:  EdgeInsets.all(padding),
                color: colors.elementAt(i),
                child: Text(
                  '${names.elementAt(i)}',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  textAlign: _textAlign,
                ),
              ), 
              separatorBuilder: (_, __) => SizedBox(height: padding), 
              itemCount: names.length,
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}