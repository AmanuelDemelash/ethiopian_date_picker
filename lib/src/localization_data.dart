// lib/src/localization_data.dart

enum EthiopianDatePickerLocalization {
  us, // English
  am, // Amharic
  or, // Oromiffa (Changed from ZA as ZA is South Africa)
  ti, // Tigrinya (Changed from IN as IN is India)
  si, // Sidama (Changed from AU as AU is Australia)
  so, // Somali (Changed from GB as GB is Great Britain)
}

class CalendarLocalizations {
  final EthiopianDatePickerLocalization localization;

  CalendarLocalizations(this.localization);

  static const Map<EthiopianDatePickerLocalization, List<String>> _months = {
    EthiopianDatePickerLocalization.us: [
      'Meskerem',
      'Tikimt',
      'Hidar',
      'Tahsas',
      'Tir',
      'Yekatit',
      'Megabit',
      'Miyazya',
      'Ginbot',
      'Sene',
      'Hamle',
      'Nehase',
      'Pagumen'
    ],
    EthiopianDatePickerLocalization.am: [
      'መስከረም',
      'ጥቅምት',
      'ህዳር',
      'ታህሳስ',
      'ጥር',
      'የካቲት',
      'መጋቢት',
      'ሚያዝያ',
      'ግንቦት',
      'ሰኔ',
      'ሐምሌ',
      'ነሐሴ',
      'ጳጉሜን'
    ],
    EthiopianDatePickerLocalization.or: [
      'Fulbaana',
      'Onkoloolessa',
      'Sadaasa',
      'Muddee',
      'Amajjii',
      'Guraandhala',
      'Bitootessa',
      'Ebla',
      'Caamsaa',
      'Waxabajjii',
      'Adoolessa',
      'Hagayya',
      'Qaammee'
    ],
    EthiopianDatePickerLocalization.ti: [
      'መስከረም',
      'ጥቅምቲ',
      'ሕዳር',
      'ታሕሳስ',
      'ጥሪ',
      'የካቲት',
      'መጋቢት',
      'ሚያዝያ',
      'ግንቦት',
      'ሰኔ',
      'ሓምለ',
      'ነሓሰ',
      'ጳጉሜን'
    ],
    EthiopianDatePickerLocalization.si: [
      'Meskerem',
      'Tikimt',
      'Hidar',
      'Tahsas',
      'Tir',
      'Yekatit',
      'Megabit',
      'Miyazya',
      'Ginbot',
      'Sene',
      'Hamle',
      'Nehase',
      'Pagumen'
    ], // Placeholder, please provide actual Sidama month names
    EthiopianDatePickerLocalization.so: [
      'Meskerem',
      'Tikimt',
      'Hidar',
      'Tahsas',
      'Tir',
      'Yekatit',
      'Megabit',
      'Miyazya',
      'Ginbot',
      'Sene',
      'Hamle',
      'Nehase',
      'Pagumen'
    ], // Placeholder, please provide actual Somali month names
  };

  static const Map<EthiopianDatePickerLocalization, List<String>> _dayNames = {
    EthiopianDatePickerLocalization.us: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
    EthiopianDatePickerLocalization.am: [
      'እ',
      'ሰ',
      'ማ',
      'ረ',
      'ሐ',
      'ዓ',
      'ቅ'
    ], // እሁድ, ሰኞ, ማክሰኞ, ረቡዕ, ሐሙስ, ዓርብ, ቅዳሜ
    EthiopianDatePickerLocalization.or: [
      'Dil',
      'San',
      'Wal',
      'Rab',
      'Kam',
      'Jim',
      'Sanb'
    ], // Dilbata, Sanbata, Waldeeya, Roobii, Kamisa, Jimaata, Sanbata Xiqqaa (approx)
    EthiopianDatePickerLocalization.ti: [
      'ሰ',
      'ሰ',
      'ማ',
      'ረ',
      'ሓ',
      'ዓ',
      'ቀ'
    ], // ሰንበተ, ሰኑይ, ሰሉስ, ረቡዕ, ሓሙስ, ዓርቢ, ቀዳም (approx)
    EthiopianDatePickerLocalization.si: [
      'S',
      'M',
      'T',
      'W',
      'T',
      'F',
      'S'
    ], // Placeholder, please provide actual Sidama day names
    EthiopianDatePickerLocalization.so: [
      'A',
      'Is',
      'Sl',
      'Ar',
      'Kha',
      'Jum',
      'Sab'
    ], // Axad, Isniin, Talaado, Arbaco, Khamiis, Jimco, Sabti (approx)
  };

  static const Map<EthiopianDatePickerLocalization, Map<String, String>>
      _texts = {
    EthiopianDatePickerLocalization.us: {
      'selectDate': 'Select date',
      'ok': 'Ok',
      'cancel': 'Cancel',
      'noDateSelected': 'No date selected',
    },
    EthiopianDatePickerLocalization.am: {
      'selectDate': 'ቀን ይምረጡ',
      'ok': 'እሺ',
      'cancel': 'ይቅር',
      'noDateSelected': 'ቀን አልተመረጠም',
    },
    EthiopianDatePickerLocalization.or: {
      'selectDate': 'Guyyaa Filadhu',
      'ok': 'Tole',
      'cancel': 'Haa Gufatu',
      'noDateSelected': 'Guyyaa hin filatamne',
    },
    EthiopianDatePickerLocalization.ti: {
      'selectDate': 'ዕለት ምረፅ',
      'ok': 'ሕራይ',
      'cancel': 'ኣይፋሉ',
      'noDateSelected': 'ዕለት ኣይተመረፀን',
    },
    EthiopianDatePickerLocalization.si: {
      'selectDate': 'Saahimaano',
      'ok': 'Ayyo',
      'cancel': 'Hinna',
      'noDateSelected': 'Saahimano Miti',
    }, // Placeholder
    EthiopianDatePickerLocalization.so: {
      'selectDate': 'Dooro Taariikhda',
      'ok': 'Haa',
      'cancel': 'Jooji',
      'noDateSelected': 'Ma jirto taariikh la doortay',
    }, // Placeholder
  };

  List<String> get months {
    return _months[localization] ??
        _months[EthiopianDatePickerLocalization.us]!;
  }

  List<String> get dayNames {
    return _dayNames[localization] ??
        _dayNames[EthiopianDatePickerLocalization.us]!;
  }

  String getText(String key) {
    return _texts[localization]?[key] ??
        _texts[EthiopianDatePickerLocalization.us]![key]!;
  }
}

/// A class that provides localization support for the Ethiopian calendar,
/// including the names of months and days in Amharic.
class EthiopianLocalization {
  /// A list of Amharic month names in the Ethiopian calendar.
  static const List<String> amharicMonths = [
    'መስከረም',
    'ጥቅምት',
    'ህዳር',
    'ታህሳስ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዚያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ',
  ];

  /// A list of Amharic day names in the Ethiopian calendar.
  static const List<String> amharicDays = [
    'እሁድ',
    'ሰኞ',
    'ማክሰኞ',
    'ረቡዕ',
    'ሐሙስ',
    'አርብ',
    'ቅዳሜ'
  ];
}
