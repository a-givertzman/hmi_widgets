import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class CraneLoadChartLegendWidget extends StatelessWidget {
  final SwlDataCache _swlDataCache;
  final double _width;
  final int _swlIndex;
  final Setting _padding;
  final Setting _margin;
  final double _colorMarkSize;
  ///
  const CraneLoadChartLegendWidget({
    Key? key,
    required SwlDataCache swlDataCache,
    required int swlIndex,
    required double width,
    double colorMarkSize = 10,
    Setting padding = const Setting('padding', factor: 0.5),
    Setting margin = const Setting('padding', factor: 0.5),
  }) : 
    _swlDataCache = swlDataCache,
    _width = width,
    _padding = padding,
    _margin = margin,
    _swlIndex = swlIndex, 
    _colorMarkSize = colorMarkSize,
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
              itemBuilder: (context, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: _colorMarkSize,
                    height: _colorMarkSize,
                    decoration: BoxDecoration(
                      color: colors.elementAt(i),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${names.elementAt(i)}',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: DefaultTextStyle.of(context).style.copyWith(
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              separatorBuilder: (_, __) => SizedBox(height: padding), 
              itemCount: names.length,
            );
          }
          else {
            return SizedBox(
              height: _width,
              child: CupertinoActivityIndicator(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          }
        },
      ),
    );
  }
}