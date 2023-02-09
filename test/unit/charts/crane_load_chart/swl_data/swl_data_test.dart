import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/src/charts/crane_load_chart/swl_data.dart';
import 'fake_text_file.dart';
void main() {
  Log.initialize(level: LogLevel.off);
  group('SwlData', () {
    test('creates normally with valid files', () async {
      final swlTestData = [
        {
          'text_x': '1,1;2,7;3,2;4;5\n\n6,1;7,2;8,3;9,4;10,5',
          'text_y': '6,1;7,2;8,3;9,4;10,5\n\n\n1,1;2,7;3,2;4;5',
          'text_swl': [
            '1,1;2,7;3,2;4;5\n\n6,1;7,2;8,3;9,4;10,5',
            '\n6,1;7,2;8,3;9,4;10,5\n1,1;2,7;3,2;4;5\n',
            '1,1;2,7;3,2;4;5\n\n\n6,1;7,2;8,3;9,4;10,5',
          ],
          'x': [1.1, 2.7, 3.2, 4.0, 5.0, 6.1, 7.2, 8.3, 9.4, 10.5],
          'y': [6.1, 7.2, 8.3, 9.4, 10.5, 1.1, 2.7, 3.2, 4.0, 5.0],
          'swl': [
            [1.1, 2.7, 3.2, 4.0, 5.0, 6.1, 7.2, 8.3, 9.4, 10.5],
            [6.1, 7.2, 8.3, 9.4, 10.5, 1.1, 2.7, 3.2, 4.0, 5.0],
            [1.1, 2.7, 3.2, 4.0, 5.0, 6.1, 7.2, 8.3, 9.4, 10.5],
          ],
        },
        {
          'text_x': '143,214;124.0;-1,235;239,000\n937845,23;39804.345;54654.35;456,34;789,231\n',
          'text_y': '\n937845,23;39804.345;54654.35;456,34;789,231\n143,214;124.0;-1,235;239,000\n',
          'text_swl': [
            '937845,23;39804.345;54654.35;456,34;789,231\n143,214;124.0;-1,235;239,000\n',
            '\n143,214;124.0;-1,235;239,000\n937845,23;39804.345;54654.35;456,34;789,231\n',
            '143,214;124.0;-1,235;239,000\n937845,23;39804.345;54654.35;456,34;789,231\n',
          ],
          'x': [143.214, 124.0, -1.235, 239.0, 937845.23, 39804.345, 54654.35, 456.34, 789.231],
          'y': [937845.23, 39804.345, 54654.35, 456.34, 789.231, 143.214, 124.0, -1.235, 239.0],
          'swl': [
            [937845.23, 39804.345, 54654.35, 456.34, 789.231, 143.214, 124.0, -1.235, 239.0],
            [143.214, 124.0, -1.235, 239.0, 937845.23, 39804.345, 54654.35, 456.34, 789.231],
            [143.214, 124.0, -1.235, 239.0, 937845.23, 39804.345, 54654.35, 456.34, 789.231],
          ],
        },
      ];
      for (final entry in swlTestData) {
        final textX = entry['text_x'] as String;
        final textY = entry['text_y'] as String;
        final textSwls = entry['text_swl'] as List<String>;
        final x = entry['x'] as List<double>;
        final y = entry['y'] as List<double>;
        final swl = entry['swl'] as List<List<double>>;
        final swlData = SwlData(
          xCsvFile: FakeTextFile(textX), 
          yCsvFile: FakeTextFile(textY), 
          swlCsvFiles: textSwls.map((textSwl) => FakeTextFile(textSwl)).toList(),
        );
        expect(await swlData.x, x);
        expect(await swlData.y, y);
        expect(await swlData.swl, swl);
      }
    });
  });
}