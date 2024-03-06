import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/src/edit_field/network_dropdown_field/oil_data.dart';
import 'fake_json_map.dart';
void main() {
  Log.initialize(level: LogLevel.off);
  group('OilData', () {
    test('creates normally with valid file', () async {
      const oilTestData = [
        {
          'json_map': {
            'oil1': {
              'din': 'DIN 12345-6',
              'tempMax': 2,
              'tempMin': 1,
            },
          },
          'names': ['oil1'],
        },
        {
          'json_map': {
            'someOil1': {
              'din': 'DIN 78910-1',
              'tempMax': 135,
              'tempMin': 13,
            },
            'fakeOil': {
              'din': 'DIN 23456-7',
              'tempMax': 364,
              'tempMin': 253,
            },
          },
          'names': ['someOil1', 'fakeOil'],
        },
        {
          'json_map': {
            'testOil': {
              'din': 'DIN 89101-2',
              'tempMax': 2764,
              'tempMin': 364,
            },
            'unexistingOil': {
              'din': 'DIN 34567-8',
              'tempMax': 587,
              'tempMin': 43,
            },
            'mythicalOil': {
              'din': 'DIN 91012-3',
              'tempMax': 235,
              'tempMin': 123,
            },
          },
          'names': ['testOil', 'unexistingOil', 'mythicalOil'],
        },
      ];
      for (final entry in oilTestData) {
        final oilJsonMap = entry['json_map'] as Map<String, Map<String, dynamic>>;
        final names = entry['names'] as List<String>;
        final oilData = OilData(
          jsonMap: FakeJsonMap(Ok(oilJsonMap)),
        );
        expect(await oilData.names(), names);
      }
    });
  });
}