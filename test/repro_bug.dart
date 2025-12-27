import 'package:ethiopian_date_picker/ethiopian_date_picker.dart';
import 'package:ethiopian_date_picker/src/converters.dart';

void main() {
  // Test case provided by user (assuming GC 2018-05-28)
  final date1 = DateTime(2018, 5, 28);
  final ethiopian1 = EthiopianDateConverter.gregorianToEthiopian(date1);
  print(
      'GC: 2018-05-28 -> EC: ${ethiopian1.day}/${ethiopian1.month}/${ethiopian1.year}');

  // Known correct: May 28, 2018 GC = Ginbot 20, 2010 EC
  // Current code: monthOffsets[5] = offset -7 -> 28 - 7 = 21. Result: 21/9/2010

  // Another test case: January 28, 2026 GC
  final date2 = DateTime(2026, 1, 28);
  final ethiopian2 = EthiopianDateConverter.gregorianToEthiopian(date2);
  print(
      'GC: 2026-01-28 -> EC: ${ethiopian2.day}/${ethiopian2.month}/${ethiopian2.year}');
  // Known correct: Jan 28, 2026 GC = Tir 19, 2018 EC
}
