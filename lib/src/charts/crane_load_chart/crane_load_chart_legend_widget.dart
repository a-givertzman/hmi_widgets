import 'package:flutter/material.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data_cache.dart';
import 'package:hmi_core/hmi_core.dart';
///
class CraneLoadChartLegendWidget extends StatelessWidget {
  final SwlDataCache _swlDataCache;
  final double? _width;
  final TextAlign? _textAlign;
  final int _swlIndex;
  ///
  const CraneLoadChartLegendWidget({
    Key? key,
    required SwlDataCache swlDataCache,
    required int swlIndex,
    double? width,
    TextAlign? textAlign
  }) : 
    _swlDataCache = swlDataCache,
    _width = width,
    _textAlign = textAlign,
    _swlIndex = swlIndex, 
    super(key: key);
  //
  @override
  Widget build(BuildContext context) {
    final hMargin = AppUiSettingsNum.getSetting('padding') * 0.5;
    final padding = AppUiSettingsNum.getSetting('padding') * 0.5;
    return FutureBuilder(
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
          return SizedBox(
            width: _computeWidth(
              DefaultTextStyle.of(context).style.fontSize ?? 100, 
              names, 
              _width,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding:  EdgeInsets.symmetric(vertical: padding, horizontal: hMargin),
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
            ),
          );
        }
        else {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
  ///
  double _computeWidth(double fontSize, Iterable<String> names, double? width) {
    if (width == null) {
      final maxLength = names.fold(
        0, 
        (value, element) => element.length > value ? element.length : value,
      );
      return maxLength * fontSize;
    }
    return width;
  }
}