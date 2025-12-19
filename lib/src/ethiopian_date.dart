class EthiopianDate {
  final int year;
  final int month;
  final int day;

  EthiopianDate(this.year, this.month, this.day);

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  EthiopianDate copyWith({int? year, int? month, int? day}) {
    return EthiopianDate(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
    );
  }

  // >>>>>>>>>>>>>>> IMPORTANT: ADD THESE TWO METHODS <<<<<<<<<<<<<<<
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } // Optimized for same object reference
    return other is EthiopianDate && // Ensure 'other' is an EthiopianDate
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);
  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  EthiopianDate get previousMonth {
    int newMonth = month - 1;
    int newYear = year;
    if (newMonth < 1) {
      newMonth = 13;
      newYear--;
    }
    return EthiopianDate(newYear, newMonth, 1);
  }

  EthiopianDate get nextMonth {
    int newMonth = month + 1;
    int newYear = year;
    if (newMonth > 13) {
      newMonth = 1;
      newYear++;
    }
    return EthiopianDate(newYear, newMonth, 1);
  }
}
