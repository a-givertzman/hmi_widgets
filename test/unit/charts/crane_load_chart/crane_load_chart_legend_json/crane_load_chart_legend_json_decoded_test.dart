import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/crane_load_chart_legend_json.dart';
import 'package:hmi_widgets/src/core/colors/gradient_colors.dart';
import 'fake_json_list.dart';
void main() {
  group('CraneLoadChartLegendJson decoded', () {
    test('returns valid data on valid JsonList', () async {
      final validLegendConfigs = [
        {
          'list': [
              {
                "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшъыьэюя": {"limit": 0.0, "color": "0"},
              },
              {
                "limit-0": {"limit": -1.0, "color": "1"}, 
                "1234567890!\"@#№;\$%^:&?*()_-=+": {"limit": -2.0, "color": "2"}, 
              },
          ],
          'limits': const [
            [0.0],
            [-1.0, -2.0],
          ],
          'colors': const [
            [Colors.white, ],
            [Colors.white, Colors.black],
          ],
          'names': const [
            ['abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшъыьэюя'],
            ['limit-0', '1234567890!\"@#№;\$%^:&?*()_-=+'],
          ],
        },
        {
          'list': [
              {
                "blank": {"limit": 4999.0, "color": "0xFF42A5F5"},
                "5 t": {"limit": 5000.0, "color": "0xffaa5577"}, 
                "20 t": {"limit": 20000.0, "color": "0xff115577"}
              },
              {
                "blank": {"limit": 4999.0, "color": "0xFF42A5F5"}, 
                "5 t": {"limit": 5000.0, "color": "0xffaa5577"}, 
                "7 t": {"limit": 7000.0, "color": "0xffcc5577"}, 
                "23 t": {"limit": 23000.0, "color": "0xffee5577"}
              },
          ],
          'limits': const [
            [4999.0, 5000.0, 20000.0],
            [4999.0, 5000.0, 7000.0, 23000.0],
          ],
          'colors': const [
            [
              Colors.white,
              Color.from(alpha: 1.0, red: 0.5647, green: 0.7941, blue: 0.9765),
              Colors.black,
            ],
            [
              Colors.white,
              Color.from(alpha: 1.0, red: 0.1294, green: 0.5882, blue: 0.9529),
              Colors.white,
              Colors.black,
            ],
            // [Color(0xFF42A5F5), Color(0xffaa5577), Color(0xff115577)],
            // [Color(0xFF42A5F5), Color(0xffaa5577), Color(0xffcc5577), Color(0xffee5577)],
          ],
          'names': const [
            ['blank', '5 t', '20 t'],
            ['blank', '5 t', '7 t', '23 t'],
          ],
        },
      ];
      for (final config in validLegendConfigs) {
        final list = config['list'] as List<Map<String, dynamic>>;
        final linearGradientColors = [Colors.red, Colors.blue, Colors.white, Colors.black];
        final legendJson = CraneLoadChartLegendJson(
          jsonList: FakeJsonList(Ok(list)),
          gradientColors: GradientColors(
            gradient: LinearGradient(
              colors: linearGradientColors,
            ),
          ),
        );
        final decodedLegend = await legendJson.decoded;
        expect(
          decodedLegend['limits'], 
          config['limits'],
          reason: 'Invalid limits conversion',
        );
        expect(
          decodedLegend['colors'],
          config['colors'],
          reason: 'Invalid colors conversion'
        );
        expect(
          decodedLegend['names'], 
          config['names'],
          reason: 'Invalid names conversion'
        );
      }
    });
    test('fails on invalid JsonList', () {
      final invalidJsonConfigs = [
        [
          {
            "a": {"limit": true, "color": "0"},
          },
          {
            "b": {"limit": '-1.0', "color": "1"}, 
            "c": {"limit": -2.0, "color": false}, 
          },
        ],
        [
          {
            "a": {"limit": 0.0, "color": "abcdefghij"},
          },
          {
            "b": {"limit": -1.0, "color": "1"}, 
          },
          {
            "c": {"limit": [-2.0], "color": "2"}, 
          },
        ],
      ];
      for (final invalidConfig in invalidJsonConfigs) {
        final legendData = CraneLoadChartLegendJson(
          gradientColors: GradientColors(
            gradient: LinearGradient(colors: []),
          ),
          jsonList: FakeJsonList(Ok(invalidConfig)),
        );
        expect(
          legendData.decoded,
          throwsA(isA<Failure>()),
          reason: 'Error wasn\'t thrown on invalid json'
        );
      }
    });
  });
}