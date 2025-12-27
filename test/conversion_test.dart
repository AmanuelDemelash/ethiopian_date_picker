import 'package:flutter_test/flutter_test.dart';
import 'package:ethiopian_date_picker/ethiopian_date_picker.dart';

void main() {
  group('EthiopianDateConverter.gregorianToEthiopian', () {
    test('Reported bug case: 2018-05-28 GC -> Ginbot 20, 2010 EC', () {
      final gcDate = DateTime(2018, 5, 28);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2010);
      expect(ecDate.month, 9); // Ginbot
      expect(ecDate.day, 20);
    });

    test('New Year: 2023-09-11 GC -> Meskerem 1, 2016 EC', () {
      final gcDate = DateTime(2023, 9, 11);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2016);
      expect(ecDate.month, 1); // Meskerem
      expect(ecDate.day, 1);
    });

    test('Leap Year New Year: 2024-09-12 GC -> Meskerem 1, 2017 EC', () {
      final gcDate = DateTime(2024, 9, 12);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2017);
      expect(ecDate.month, 1); // Meskerem
      expect(ecDate.day, 1);
    });

    test('January case: 2025-01-28 GC -> Tir 20, 2017 EC', () {
      final gcDate = DateTime(2025, 1, 28);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2017);
      expect(ecDate.month, 5); // Tir
      expect(ecDate.day, 20);
    });

    test('Pagume 5: 2023-09-10 GC -> Pagume 5, 2015 EC', () {
      final gcDate = DateTime(2023, 9, 10);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2015);
      expect(ecDate.month, 13); // Pagume
      expect(ecDate.day, 5);
    });

    test('Pagume 6 (Leap Year): 2024-09-11 GC -> Pagume 6, 2016 EC', () {
      final gcDate = DateTime(2024, 9, 11);
      final ecDate = EthiopianDateConverter.gregorianToEthiopian(gcDate);
      expect(ecDate.year, 2016);
      expect(ecDate.month, 13); // Pagume
      expect(ecDate.day, 6);
    });
  });
}
