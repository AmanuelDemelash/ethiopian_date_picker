import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopian_date_picker/src/calendar_converter.dart';

void main() {
  test('EC to GC Example', () {
    // Example: Ethiopian date 2015-04-25 converts to Gregorian 2022-03-25
    final ecDate = {'year': 2015, 'month': 4, 'day': 25};
    final gcResult = CalendarConverter.toGregorian(
        ecDate['year']!, ecDate['month']!, ecDate['day']!);

    expect(gcResult.year, 2022);
    expect(gcResult.month, 3);
    expect(gcResult.day, 25);
  });

  test('GC to EC Example', () {
    // Example: Gregorian date 2022-03-25 converts to Ethiopian 2014-04-25
    final gcDate = DateTime(2022, 3, 25);
    final ecResult = CalendarConverter.toEthiopian(gcDate);

    expect(ecResult[0], 2014);
    expect(ecResult[1], 4);
    expect(ecResult[2], 25);
  });
}
