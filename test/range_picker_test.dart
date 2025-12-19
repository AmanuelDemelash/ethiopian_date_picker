import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopian_date_picker/ethiopian_date_picker.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('showEthiopianDatePickerRange opens dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              showEthiopianDatePickerRange(
                context: context,
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime(2023, 12, 31),
              );
            },
            child: const Text('Pick Range'),
          );
        },
      ),
    ));

    // Initial state: no picker
    expect(find.byType(EthiopianRangeDatePicker), findsNothing);

    // Tap button to open picker
    await tester.tap(find.text('Pick Range'));
    await tester.pumpAndSettle();

    // Verify picker is open
    expect(find.byType(EthiopianRangeDatePicker), findsOneWidget);
    expect(find.text('Select date'), findsOneWidget); // Checks title text
  });

  testWidgets('Selecting an earlier date second swaps dates to form a range',
      (WidgetTester tester) async {
    DateTimeRange? selectedRange;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              selectedRange = await showEthiopianDatePickerRange(
                context: context,
                firstDate: DateTime(2025, 1, 1),
                lastDate: DateTime(2026, 1, 1),
              );
            },
            child: const Text('Pick Range'),
          );
        },
      ),
    ));

    await tester.tap(find.text('Pick Range'));
    await tester.pumpAndSettle();

    // Select day 10 then day 5 in the current month
    await tester.tap(find.text('10'));
    await tester.pump();
    await tester.tap(find.text('5'));
    await tester.pump();

    // Tap OK
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(selectedRange, isNotNull);
    // Jan 5 is before Jan 10
    expect(selectedRange!.start.isBefore(selectedRange!.end), isTrue);
  });
}
