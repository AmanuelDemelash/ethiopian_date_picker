// lib/src/calendar_grid.dart

import 'package:ethiopian_date_picker/src/calendar_converter.dart';
import 'package:flutter/material.dart';
import 'ethiopian_date.dart';
import 'localization_data.dart'; // Import localization data

class CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final void Function(EthiopianDate) onDateSelected;
  final EthiopianDate? selectedDate;
  final EthiopianDate? firstDay;
  final EthiopianDate? lastDay;
  final EthiopianDate? startDate;
  final EthiopianDate? endDate;
  final EthiopianDatePickerLocalization localization; // New parameter

  const CalendarGrid({
    super.key,
    required this.year,
    required this.month,
    required this.onDateSelected,
    this.selectedDate,
    this.firstDay,
    this.lastDay,
    this.startDate,
    this.endDate,
    this.localization = EthiopianDatePickerLocalization.us, // Default
  });

  // Helper method to compare EthiopianDates
  // Returns true if date1 is earlier than date2
  bool _isBefore(EthiopianDate date1, EthiopianDate date2) {
    if (date1.year < date2.year) return true;
    if (date1.year == date2.year && date1.month < date2.month) return true;
    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day < date2.day) {
      return true;
    }
    return false;
  }

  // Helper method to compare EthiopianDates
  // Returns true if date1 is later than date2
  bool _isAfter(EthiopianDate date1, EthiopianDate date2) {
    if (date1.year > date2.year) return true;
    if (date1.year == date2.year && date1.month > date2.month) return true;
    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day > date2.day) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        CalendarLocalizations(localization); // Create instance here

    final days = <Widget>[];
    final isPagumen = month == 13;
    final daysInMonth = isPagumen ? (year % 4 == 3 ? 6 : 5) : 30;

    // Add day names header (Sunday to Saturday)
    // Use localized day names
    for (final dayName in appLocalizations.dayNames) {
      days.add(
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          child: Text(
            dayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final gregorian = CalendarConverter.toGregorian(year, month, 1);
    // In Dart's DateTime, Monday is 1 and Sunday is 7. We want Sunday to be 0.
    final startingWeekday = gregorian.weekday % 7;

    // Add leading empty cells for alignment
    for (int i = 0; i < startingWeekday; i++) {
      days.add(Container()); // Invisible placeholder
    }

    // Add date cells
    for (int i = 1; i <= daysInMonth; i++) {
      final currentDate = EthiopianDate(year, month, i);

      final isSelected = selectedDate != null && selectedDate == currentDate;
      final isFirstDay = firstDay != null && firstDay == currentDate;

      // Determine if the date is out of range
      final bool isBeforeFirstDay =
          firstDay != null && _isBefore(currentDate, firstDay!);
      final bool isAfterLastDay =
          lastDay != null && _isAfter(currentDate, lastDay!);
      final bool isDisabled = isBeforeFirstDay || isAfterLastDay;

      // Determine if date is in range
      final bool isStart = startDate != null && startDate == currentDate;
      final bool isEnd = endDate != null && endDate == currentDate;
      final bool isInRange = startDate != null &&
          endDate != null &&
          _isAfter(currentDate, startDate!) &&
          _isBefore(currentDate, endDate!);

      BoxDecoration? decoration;
      Color? textColor;
      Function()? onTapHandler;

      if (isSelected || isStart || isEnd) {
        decoration = const BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        );
        textColor = Colors.white;
        onTapHandler = () => onDateSelected(currentDate);
      } else if (isInRange) {
        decoration = BoxDecoration(
          color: Colors.deepPurple.shade100,
          shape: BoxShape.circle,
        );
        textColor = Colors.black;
        onTapHandler = () => onDateSelected(currentDate);
      } else if (isFirstDay) {
        decoration = const BoxDecoration();
        textColor = Colors.black;
        onTapHandler = () => onDateSelected(currentDate);
      } else if (isDisabled) {
        decoration = null;
        textColor = Colors.grey;
        onTapHandler = null;
      } else {
        decoration = null;
        textColor = null;
        onTapHandler = () => onDateSelected(currentDate);
      }

      days.add(
        GestureDetector(
          onTap: onTapHandler,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4),
            decoration: decoration,
            child: Text(
              '$i',
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      children: days,
    );
  }
}
