import 'package:flutter/material.dart';
import 'ethiopian_date.dart';
import 'calendar_converter.dart';
import 'calendar_grid.dart';
import 'header.dart';
import 'localization_data.dart';

class EthiopianRangeDatePicker extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final EthiopianDate? firstDay;
  final EthiopianDate? lastDay;
  final Function(EthiopianDate? start, EthiopianDate? end)? onRangeChanged;
  final EthiopianDatePickerLocalization localization;

  const EthiopianRangeDatePicker({
    super.key,
    this.initialDateRange,
    this.onRangeChanged,
    this.firstDay,
    this.lastDay,
    this.localization = EthiopianDatePickerLocalization.us,
  });

  @override
  State<EthiopianRangeDatePicker> createState() =>
      _EthiopianRangeDatePickerState();
}

Future<DateTimeRange?> showEthiopianDatePickerRange({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  EthiopianDatePickerLocalization localization =
      EthiopianDatePickerLocalization.us,
}) {
  final pickerKey = GlobalKey<_EthiopianRangeDatePickerState>();

  EthiopianDate? ethFirstDay;
  if (firstDate != null) {
    final eth = CalendarConverter.toEthiopian(firstDate);
    ethFirstDay = EthiopianDate(eth[0], eth[1], eth[2]);
  }

  EthiopianDate? ethLastDay;
  if (lastDate != null) {
    final eth = CalendarConverter.toEthiopian(lastDate);
    ethLastDay = EthiopianDate(eth[0], eth[1], eth[2]);
  }

  final ValueNotifier<EthiopianDate?> startDateNotifier = ValueNotifier(null);
  final ValueNotifier<EthiopianDate?> endDateNotifier = ValueNotifier(null);

  if (initialDateRange != null) {
    final startEth = CalendarConverter.toEthiopian(initialDateRange.start);
    final endEth = CalendarConverter.toEthiopian(initialDateRange.end);
    startDateNotifier.value =
        EthiopianDate(startEth[0], startEth[1], startEth[2]);
    endDateNotifier.value = EthiopianDate(endEth[0], endEth[1], endEth[2]);
  }

  final appLocalizations = CalendarLocalizations(localization);

  return showDialog<DateTimeRange>(
    useSafeArea: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(left: 5, right: 5),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appLocalizations.getText('selectDate'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<EthiopianDate?>(
              valueListenable: startDateNotifier,
              builder: (context, startDate, child) {
                return ValueListenableBuilder<EthiopianDate?>(
                  valueListenable: endDateNotifier,
                  builder: (context, endDate, child) {
                    String dateToDisplay;
                    if (startDate != null) {
                      String startStr =
                          "${appLocalizations.months[startDate.month - 1]} ${startDate.day}, ${startDate.year}";
                      if (endDate != null) {
                        String endStr =
                            "${appLocalizations.months[endDate.month - 1]} ${endDate.day}, ${endDate.year}";
                        dateToDisplay = "$startStr - $endStr";
                      } else {
                        dateToDisplay = startStr;
                      }
                    } else {
                      // Attempt to resolve initial if not yet set in notifier (though we set it above)
                      // Or just show "No date selected"
                      if (initialDateRange != null &&
                          startDateNotifier.value == null) {
                        // This case shouldn't happen given initialization logic
                        dateToDisplay =
                            appLocalizations.getText('noDateSelected');
                      } else {
                        dateToDisplay =
                            appLocalizations.getText('noDateSelected');
                      }
                    }
                    return Text(
                      dateToDisplay,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    );
                  },
                );
              },
            ),
            const Divider(height: 18, thickness: 1, color: Colors.black)
          ],
        ),
        content: EthiopianRangeDatePicker(
          key: pickerKey,
          initialDateRange: initialDateRange,
          firstDay: ethFirstDay,
          lastDay: ethLastDay,
          localization: localization,
          onRangeChanged: (start, end) {
            startDateNotifier.value = start;
            endDateNotifier.value = end;
          },
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge),
            child: Text(
              appLocalizations.getText('cancel'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge),
            child: Text(
              appLocalizations.getText('ok'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              final state = pickerKey.currentState;
              if (state != null &&
                  state._startDate != null &&
                  state._endDate != null) {
                final startGreg = CalendarConverter.toGregorian(
                  state._startDate!.year,
                  state._startDate!.month,
                  state._startDate!.day,
                );
                final endGreg = CalendarConverter.toGregorian(
                  state._endDate!.year,
                  state._endDate!.month,
                  state._endDate!.day,
                );
                Navigator.of(dialogContext)
                    .pop(DateTimeRange(start: startGreg, end: endGreg));
              } else {
                Navigator.of(dialogContext).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class _EthiopianRangeDatePickerState extends State<EthiopianRangeDatePicker> {
  late EthiopianDate _displayedDate;
  EthiopianDate? _startDate;
  EthiopianDate? _endDate;
  final GlobalKey calendarGridKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _displayedDate = _resolveInitialDate();
    if (widget.initialDateRange != null) {
      final start = widget.initialDateRange!.start;
      final ethStart = CalendarConverter.toEthiopian(start);
      _startDate = EthiopianDate(ethStart[0], ethStart[1], ethStart[2]);

      final end = widget.initialDateRange!.end;
      final ethEnd = CalendarConverter.toEthiopian(end);
      _endDate = EthiopianDate(ethEnd[0], ethEnd[1], ethEnd[2]);
    }

    // Notify initial state if needed, though usually strict user interaction starts it
  }

  EthiopianDate _resolveInitialDate() {
    if (widget.initialDateRange != null) {
      final date = widget.initialDateRange!.start;
      final eth = CalendarConverter.toEthiopian(date);
      return EthiopianDate(eth[0], eth[1], eth[2]);
    }
    final now = DateTime.now();
    final eth = CalendarConverter.toEthiopian(now);
    return EthiopianDate(eth[0], eth[1], eth[2]);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedDate = _displayedDate.previousMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedDate = _displayedDate.nextMonth;
    });
  }

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

  void _handleDateSelection(EthiopianDate date) {
    setState(() {
      if (_startDate == null) {
        _startDate = date;
        _endDate = null;
      } else if (_endDate == null) {
        if (_isBefore(date, _startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
      } else {
        _startDate = date;
        _endDate = null;
      }
    });
    widget.onRangeChanged?.call(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 370,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PickerHeader(
            calendarGridKey: calendarGridKey,
            year: _displayedDate.year,
            month: _displayedDate.month,
            onPrevious: _goToPreviousMonth,
            onNext: _goToNextMonth,
            onYearChanged: (newYear) {
              setState(() {
                _displayedDate =
                    EthiopianDate(newYear, _displayedDate.month, 1);
              });
            },
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            localization: widget.localization,
          ),
          CalendarGrid(
            key: calendarGridKey,
            year: _displayedDate.year,
            month: _displayedDate.month,
            onDateSelected: _handleDateSelection,
            startDate: _startDate,
            endDate: _endDate,
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            localization: widget.localization,
          )
        ],
      ),
    );
  }
}
