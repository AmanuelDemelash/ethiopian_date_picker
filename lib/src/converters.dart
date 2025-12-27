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
  /// Converts a Gregorian date to a Julian Day Number (JDN).
  static int _gregorianToJDN(int year, int month, int day) {
    int a = (14 - month) ~/ 12;
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;
    return day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        (y ~/ 4) -
        (y ~/ 100) +
        (y ~/ 400) -
        32045;
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
    int jdn = _gregorianToJDN(date.year, date.month, date.day);

    // Tafari epoch (Ethiopian calendar offset)
    const int ethiopianEpoch = 1723856;

    int r = (jdn - ethiopianEpoch) % 1461;
    int n = (jdn - ethiopianEpoch) % 365 + 365 * (r ~/ 1460);

    int year = 4 * ((jdn - ethiopianEpoch) ~/ 1461) + (r ~/ 365) - (r ~/ 1460);
    int month = (n ~/ 30) + 1;
    int day = (n % 30) + 1;

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
}
