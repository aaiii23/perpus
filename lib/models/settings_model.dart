class SettingsModel {
  final String schoolName;
  final String libraryName;
  final String headLibrarian;
  final String librarianNIP;
  final int loanDurationDays;
  final int finePerDay;
  final int maxBorrowLimit;
  final String academicYear;

  SettingsModel({
    this.schoolName = 'SMK Negeri 1 Indonesia',
    this.libraryName = 'Perpustakaan Digital SMK',
    this.headLibrarian = 'Drs. H. Mulyadi, M.Pd.',
    this.librarianNIP = '19750812 200003 1 002',
    this.loanDurationDays = 7,
    this.finePerDay = 1000,
    this.maxBorrowLimit = 3,
    this.academicYear = '2025/2026',
  });

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'libraryName': libraryName,
      'headLibrarian': headLibrarian,
      'librarianNIP': librarianNIP,
      'loanDurationDays': loanDurationDays,
      'finePerDay': finePerDay,
      'maxBorrowLimit': maxBorrowLimit,
      'academicYear': academicYear,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      schoolName: json['schoolName'] as String? ?? 'SMK Negeri 1 Indonesia',
      libraryName: json['libraryName'] as String? ?? 'Perpustakaan Digital SMK',
      headLibrarian: json['headLibrarian'] as String? ?? 'Drs. H. Mulyadi, M.Pd.',
      librarianNIP: json['librarianNIP'] as String? ?? '19750812 200003 1 002',
      loanDurationDays: (json['loanDurationDays'] as num?)?.toInt() ?? 7,
      finePerDay: (json['finePerDay'] as num?)?.toInt() ?? 1000,
      maxBorrowLimit: (json['maxBorrowLimit'] as num?)?.toInt() ?? 3,
      academicYear: json['academicYear'] as String? ?? '2025/2026',
    );
  }
}
