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
  /// Converts a Gregorian [DateTime] to an EthiopianDate.
  static EthiopianDate gregorianToEthiopian(DateTime date) {
    int gy = date.year;
    int gm = date.month;
    int gd = date.day;

    // Rule: Ethiopian Year (EY) = GY - 7 or 8 (accounting for the leap year)
    int ey = gy - (gm >= 9 ? 7 : 8);

    // Rule: Ethiopian Month (EM) = GM + 1 (adjust for Ethiopian month start)
    int em = gm + 1;

    // Rule: Ethiopian Day (ED) = GD
    int ed = gd;

    // Rule: If Gregorian year is a leap year, subtract 1 day from the result
    if (_isGregorianLeapYear(gy)) {
      ed -= 1;
    }

    // Handle em > 13 or ed <= 0 if necessary
    if (em > 13) {
      em = 1;
      ey += 1;
    }

    return EthiopianDate(ey, em, ed);
  }

  /// Converts an Ethiopian date to a Gregorian [DateTime].
  static DateTime ethiopianToGregorian(int year, int month, int day) {
    // Rule: Gregorian Year (GY) = EY + 7 or 8 (accounting for the leap year)
    int gy = year + (month <= 4 ? 7 : 8);

    // Rule: Gregorian Month (GM) = EM - 1 (adjust for Ethiopian month start)
    int gm = month - 1;

    // Rule: Gregorian Day (GD) = ED
    int gd = day;

    // Rule: If Ethiopian year is a leap year, add 1 day to the result
    if (year % 4 == 3) {
      gd += 1;
    }

    // Handle month adjustment if gm becomes 0
    if (gm == 0) {
      gm = 12;
      gy -= 1;
    }

    return DateTime(gy, gm, gd);
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
