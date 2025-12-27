class CalendarConverter {
  /// Converts a Gregorian [DateTime] to Ethiopian [year, month, day]
  static List<int> toEthiopian(DateTime gDate) {
    int gy = gDate.year;
    int gm = gDate.month;
    int gd = gDate.day;

    // Rule: Ethiopian Year (EY) = GY - 7 or 8 (accounting for the leap year)
    // Simplified rule: Jan-Aug: -8, Sep-Dec: -7
    int ey = gy - (gm >= 9 ? 7 : 8);

    // Rule: Ethiopian Month (EM) = GM + 1 (adjust for Ethiopian month start)
    int em = gm + 1;

    // Rule: Ethiopian Day (ED) = GD
    int ed = gd;

    // Rule: If Gregorian year is a leap year, subtract 1 day from the result
    if (_isGregorianLeapYear(gy)) {
      ed -= 1;
    }

    return [ey, em, ed];
  }

  static bool _isGregorianLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Converts an Ethiopian date to a Gregorian [DateTime]
  static DateTime toGregorian(int year, int month, int day) {
    // Rule: Gregorian Year (GY) = EY + 7 or 8 (accounting for the leap year)
    // Applying inverse logic: month 1-4 (+7), month 5-13 (+8)
    int gy = year + (month <= 4 ? 7 : 8);

    // Rule: Gregorian Month (GM) = EM - 1 (adjust for Ethiopian month start)
    int gm = month - 1;

    // Rule: Gregorian Day (GD) = ED
    int gd = day;

    // Rule: If Ethiopian year is a leap year, add 1 day to the result
    // Assuming Ethiopian leap year is year % 4 == 3
    if (year % 4 == 3) {
      gd += 1;
    }

    // Handle month adjustment if gm becomes 0 (Dec of previous year)
    if (gm == 0) {
      gm = 12;
      gy -= 1;
    }

    return DateTime(gy, gm, gd);
  }
}
