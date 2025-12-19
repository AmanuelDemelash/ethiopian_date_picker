// lib/src/header.dart

import 'dart:math'; // Add this import for min and max functions
import 'package:flutter/material.dart';
import 'ethiopian_date.dart';
import 'localization_data.dart'; // Import localization data

class PickerHeader extends StatefulWidget {
  final GlobalKey calendarGridKey;
  final int year;
  final int month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final void Function(int) onYearChanged;
  final EthiopianDate? firstDay;
  final EthiopianDate? lastDay;
  final EthiopianDatePickerLocalization localization; // New parameter

  const PickerHeader({
    super.key,
    required this.calendarGridKey,
    required this.year,
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onYearChanged,
    this.firstDay,
    this.lastDay,
    this.localization = EthiopianDatePickerLocalization.us, // Default
  });

  @override
  State<PickerHeader> createState() => _PickerHeaderState();
}

class _PickerHeaderState extends State<PickerHeader> {
  late int selectedYear;
  late CalendarLocalizations _calendarLocalizations; // Instance for the state

  @override
  void initState() {
    super.initState();
    selectedYear = widget.year;
    _calendarLocalizations =
        CalendarLocalizations(widget.localization); // Initialize localization
  }

  @override
  void didUpdateWidget(covariant PickerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.year != oldWidget.year) {
      selectedYear = widget.year;
    }
    if (widget.localization != oldWidget.localization) {
      _calendarLocalizations =
          CalendarLocalizations(widget.localization); // Update localization
    }
  }

  List<int> _generateYearRange() {
    int minYear = widget.firstDay?.year ?? 1900;
    int maxYear = widget.lastDay?.year ?? 2100;

    int displayStartYear = selectedYear - 25;
    int displayEndYear = selectedYear + 25;

    if (displayStartYear < minYear) {
      displayStartYear = minYear;
    }
    if (displayEndYear > maxYear) {
      displayEndYear = maxYear;
    }

    if (displayEndYear - displayStartYear < 50) {
      if (displayStartYear == minYear && displayEndYear < maxYear) {
        displayEndYear = min(maxYear, displayStartYear + 50);
      } else if (displayEndYear == maxYear && displayStartYear > minYear) {
        displayStartYear = max(minYear, displayEndYear - 50);
      }
    }
    displayStartYear = max(displayStartYear, minYear);
    displayEndYear = min(displayEndYear, maxYear);

    List<int> years = [];
    for (int year = displayStartYear; year <= displayEndYear; year++) {
      years.add(year);
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              final RenderBox? gridBox = widget.calendarGridKey.currentContext
                  ?.findRenderObject() as RenderBox?;

              if (gridBox == null) return;

              final Offset gridPosition = gridBox.localToGlobal(Offset.zero);
              final Size gridSize = gridBox.size;

              final int? selected = await showMenu<int>(
                color: Colors.white,
                context: context,
                position: RelativeRect.fromLTRB(
                  gridPosition.dx,
                  gridPosition.dy,
                  gridPosition.dx + gridSize.width,
                  gridPosition.dy + gridSize.height,
                ),
                items: [
                  PopupMenuItem<int>(
                    enabled: false,
                    padding: EdgeInsets.zero,
                    child: SizedBox(
                      width: gridSize.width,
                      height: gridSize.height,
                      child: Container(
                        color: Colors.white,
                        child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 2.2,
                          children: _generateYearRange().map((year) {
                            final bool isYearSelectable =
                                (widget.firstDay == null ||
                                        year >= widget.firstDay!.year) &&
                                    (widget.lastDay == null ||
                                        year <= widget.lastDay!.year);

                            return InkWell(
                              onTap: isYearSelectable
                                  ? () {
                                      Navigator.pop(context, year);
                                    }
                                  : null,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: year == selectedYear
                                        ? const Color(0xFF228D4D)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$year',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isYearSelectable
                                          ? (year == selectedYear
                                              ? Colors.white
                                              : const Color(0xFF707070))
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );

              if (selected != null) {
                setState(() => selectedYear = selected);
                widget.onYearChanged(selected);
              }
            },
            child: Row(
              children: [
                Text(
                  _calendarLocalizations
                      .months[widget.month - 1], // Use localized month name
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF707070),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$selectedYear',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF707070),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF707070)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: (widget.firstDay == null ||
                        widget.year > widget.firstDay!.year ||
                        (widget.year == widget.firstDay!.year &&
                            widget.month >
                                widget.firstDay!.month)) // Added month check
                    ? widget.onPrevious
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: (widget.lastDay == null ||
                        widget.year < widget.lastDay!.year ||
                        (widget.year == widget.lastDay!.year &&
                            widget.month <
                                widget.lastDay!.month)) // Added month check
                    ? widget.onNext
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
