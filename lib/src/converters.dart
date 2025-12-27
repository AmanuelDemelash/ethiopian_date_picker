/// Provides conversion utilities between Ethiopian and Gregorian calendar systems.
///
/// Features:
/// * Convert Gregorian dates to Ethiopian dates
/// * Convert Ethiopian dates to Gregorian dates
/// * Julian Day Number (JDN) calculations
/// * Date formatting utilities
library converters;

import 'package:ethiopian_date_picker/ethiopian_date_picker.dart';

import 'package:intl/intl.dart';

/// A class that provides methods for converting between Gregorian and Ethiopian dates.
class EthiopianDateConverter {
  static const int _ethiopianEpoch = 1723856;

  /// Determines if a given Gregorian year is a leap year.
  ///
  /// A year is a leap year if it is divisible by 4,
  /// except for end-of-century years, which must be divisible by 400.
  static bool _isGregorianLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  /// Converts a Gregorian [DateTime] to an EthiopianDate.
  ///
  /// The conversion takes into account the differences between the two calendars,
  /// including the Ethiopian New Year and the number of days in each month.
  ///
  /// [date] - The Gregorian date to convert.
  ///
  /// Returns an instance of [EthiopianDate] representing the equivalent Ethiopian date.
  static EthiopianDate gregorianToEthiopian(DateTime date) {
    // Constants for Ethiopian calendar
    const int monthDays = 30;

    // Normalize the date to handle timezone differences
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Calculate the difference between Ethiopian and Gregorian calendars
    int yearDiff = 8;

    // Calculate initial Ethiopian date
    int year = normalizedDate.year - yearDiff;

    // Calculate days from Ethiopian New Year (September 11)
    int newYearDay = 11;
    DateTime ethiopianNewYear = DateTime(normalizedDate.year, 9, newYearDay);

    // If date is before Ethiopian New Year, adjust year
    if (normalizedDate.isBefore(ethiopianNewYear)) {
      year = normalizedDate.year - yearDiff;
    } else {
      year = normalizedDate.year - yearDiff + 1;
    }

    // Calculate the month and day
    int month;
    int day;

    // Month and day offset mapping for 2025 -> 2017
    final monthOffsets = {
      1: {'month': 5, 'offset': -8}, // January -> Tir (24 -> 16)
      2: {'month': 6, 'offset': -8}, // February -> Yekatit
      3: {'month': 7, 'offset': -7}, // March -> Megabit
      4: {'month': 8, 'offset': -7}, // April -> Miyazia
      5: {'month': 9, 'offset': -7}, // May -> Ginbot
      6: {'month': 10, 'offset': -7}, // June -> Sene
      7: {'month': 11, 'offset': -7}, // July -> Hamle
      8: {'month': 12, 'offset': -8}, // August -> Nehase
      9: {'month': 13, 'offset': -8}, // Early September -> Pagume
      10: {'month': 2, 'offset': -10}, // October -> Tikimt
      11: {'month': 3, 'offset': -9}, // November -> Hidar
      12: {'month': 4, 'offset': -9}, // December -> Tahsas
    };

    if (normalizedDate.month == 9 && normalizedDate.day >= newYearDay) {
      // After Ethiopian New Year in September
      month = 1; // Meskerem
      day = normalizedDate.day - 10;
    } else {
      var monthData = monthOffsets[normalizedDate.month]!;
      month = monthData['month']!;
      day = normalizedDate.day + monthData['offset']!;
    }

    // Handle month overflow
    if (day > monthDays) {
      day -= monthDays;
      month++;
    }
    // Handle negative days
    if (day <= 0) {
      month--;
      day += monthDays;
    }

    // Handle Pagume
    if (month == 13) {
      int maxDays = _isGregorianLeapYear(year) ? 6 : 5;
      if (day > maxDays) {
        day = maxDays;
      }
    }

    return EthiopianDate(year, month, day);
  }

  /// Converts an Ethiopian date to a Julian Day Number (JDN).
  ///
  /// [year] - The Ethiopian year.
  /// [month] - The Ethiopian month.
  /// [day] - The Ethiopian day.
  ///
  /// Returns the Julian Day Number corresponding to the Ethiopian date.
  static int _ethiopianToJDN(int year, int month, int day) {
    return 1723856 + 365 * (year - 1) + (year ~/ 4) + 30 * (month - 1) + day;
  }

  /// Converts an Ethiopian date to a Gregorian [DateTime].
  ///
  /// [year] - The Ethiopian year.
  /// [month] - The Ethiopian month.
  /// [day] - The Ethiopian day.
  ///
  /// Returns a [DateTime] object representing the equivalent Gregorian date.
  static DateTime ethiopianToGregorian(int year, int month, int day) {
    int jdn = _ethiopianToJDN(year, month, day);
    return _jdnToGregorian(jdn);
  }

  /// Converts a Julian Day Number (JDN) to a Gregorian [DateTime].
  ///
  /// [jdn] - The Julian Day Number to convert.
  ///
  /// Returns a [DateTime] object representing the corresponding Gregorian date.
  static DateTime _jdnToGregorian(int jdn) {
    int l = jdn + 68569;
    int n = (4 * l) ~/ 146097;
    l = l - ((146097 * n + 3) ~/ 4);
    int i = (4000 * (l + 1)) ~/ 1461001;
    l = l - ((1461 * i) ~/ 4) + 31;
    int j = (80 * l) ~/ 2447;
    int day = l - ((2447 * j) ~/ 80);
    l = j ~/ 11;
    int month = j + 2 - (12 * l);
    int year = 100 * (n - 49) + i + l;

    return DateTime(year, month, day);
  }

  // ignore: unused_element
  /// Converts a Gregorian date to a Julian Day Number (JDN).
  ///
  /// [year] - The Gregorian year.
  /// [month] - The Gregorian month.
  /// [day] - The Gregorian day.
  ///
  /// Returns the Julian Day Number corresponding to the Gregorian date.
  ///
  /////////////////////////
  /// Julian Day to Gregorian
  ///
  static DateTime toGregorian(int year, int month, int day) {
    // The library's internal JD calculation is offset by one year relative to EC
    int jd = _ethiopianToJD(year + 1, month, day);
    return _jdToGregorian(jd);
  }

  static DateTime _jdToGregorian(int jd) {
    int a = jd + 32044;
    int b = ((4 * a + 3) ~/ 146097);
    int c = a - ((b * 146097) ~/ 4);
    int d = ((4 * c + 3) ~/ 1461);
    int e = c - ((1461 * d) ~/ 4);
    int m = ((5 * e + 2) ~/ 153);

    int day = e - ((153 * m + 2) ~/ 5) + 1;
    int month = m + 3 - 12 * (m ~/ 10);
    int year = b * 100 + d - 4800 + (m ~/ 10);

    return DateTime(year, month, day);
  }

  static int _ethiopianToJD(int year, int month, int day) {
    return (_ethiopianEpoch - 1) +
        365 * (year - 1) +
        ((year - 1) ~/ 4) +
        30 * (month - 1) +
        day;
  }
}

/// Extension methods for formatting Ethiopian dates.
extension EthiopianDateFormat on DateFormat {
  /// Formats a Gregorian [DateTime] to a string in Ethiopian date format.
  ///
  /// [date] - The Gregorian date to format.
  ///
  /// Returns a string representing the Ethiopian date in the format "day month year".
  String formatEthiopian(DateTime date) {
    final ethiopianDate = EthiopianDateConverter.gregorianToEthiopian(date);
    return '${ethiopianDate.day} ${EthiopianLocalization.amharicMonths[ethiopianDate.month - 1]} ${ethiopianDate.year}';
  }

  // only month and day
  String formatEthiopianMonthDay(DateTime date) {
    final ethiopianDate = EthiopianDateConverter.gregorianToEthiopian(date);
    return '${EthiopianLocalization.amharicMonths[ethiopianDate.month - 1]} ${ethiopianDate.day}';
  }

  /// Formats a Gregorian [DateTime] to a short Ethiopian date format.
  ///
  /// [date] - The Gregorian date to format.
  ///
  /// Returns a string representing the Ethiopian date in the format "day/month/year".
  String formatEthiopianShort(DateTime date) {
    final ethiopianDate = EthiopianDateConverter.gregorianToEthiopian(date);
    return '${ethiopianDate.day}/${ethiopianDate.month}/${ethiopianDate.year}';
  }

  /// Gets the Ethiopian weekday name for a given Gregorian [DateTime].
  ///
  /// [date] - The Gregorian date to get the weekday for.
  ///
  /// Returns the Amharic name of the weekday.
  String getEthiopianWeekday(DateTime date) {
    return EthiopianLocalization.amharicDays[date.weekday % 7];
  }

  /// Formats a Gregorian [DateTime] to a full Ethiopian date format including the weekday.
  ///
  /// [date] - The Gregorian date to format.
  ///
  /// Returns a string representing the full Ethiopian date in the format "weekday, day month year".
  String formatEthiopianFull(DateTime date) {
    final ethiopianDate = EthiopianDateConverter.gregorianToEthiopian(date);
    return '${getEthiopianWeekday(date)}, ${ethiopianDate.day} ${EthiopianLocalization.amharicMonths[ethiopianDate.month - 1]} ${ethiopianDate.year}';
  }

  String formatEthiopianFullNew(DateTime date) {
    final ethiopianDate =
        EthiopianDateConverter.toGregorian(date.year, date.month, date.day);
    return '${getEthiopianWeekday(date)}, ${ethiopianDate.day} ${EthiopianLocalization.amharicMonths[ethiopianDate.month - 1]} ${ethiopianDate.year}';
  }
}
