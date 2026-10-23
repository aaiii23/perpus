class TransactionModel {
  final String id;
  final String memberId;
  final String memberName;
  final String memberNisn;
  final String bookId;
  final String bookTitle;
  final String bookIsbn;
  final String borrowDate;
  final String dueDate;
  final String? returnDate;
  final String status; // 'Dipinjam' | 'Terlambat' | 'Kembali'
  final int fineAmount;
  final String officerName;
  final String? returnOfficer;
  final String notes;
  final int daysLate;

  TransactionModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.memberNisn,
    required this.bookId,
    required this.bookTitle,
    required this.bookIsbn,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    this.fineAmount = 0,
    required this.officerName,
    this.returnOfficer,
    this.notes = '',
    this.daysLate = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'memberName': memberName,
      'memberNisn': memberNisn,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookIsbn': bookIsbn,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
      'fineAmount': fineAmount,
      'officerName': officerName,
      'returnOfficer': returnOfficer,
      'notes': notes,
      'daysLate': daysLate,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      memberId: json['memberId'] as String? ?? '',
      memberName: json['memberName'] as String? ?? '',
      memberNisn: json['memberNisn'] as String? ?? '',
      bookId: json['bookId'] as String? ?? '',
      bookTitle: json['bookTitle'] as String? ?? '',
      bookIsbn: json['bookIsbn'] as String? ?? '',
      borrowDate: json['borrowDate'] as String? ?? '',
      dueDate: json['dueDate'] as String? ?? '',
      returnDate: json['returnDate'] as String?,
      status: json['status'] as String? ?? 'Dipinjam',
      fineAmount: (json['fineAmount'] as num?)?.toInt() ?? 0,
      officerName: json['officerName'] as String? ?? 'Petugas Perpustakaan',
      returnOfficer: json['returnOfficer'] as String?,
      notes: json['notes'] as String? ?? '',
      daysLate: (json['daysLate'] as num?)?.toInt() ?? 0,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? memberNisn,
    String? bookId,
    String? bookTitle,
    String? bookIsbn,
    String? borrowDate,
    String? dueDate,
    String? returnDate,
    String? status,
    int? fineAmount,
    String? officerName,
    String? returnOfficer,
    String? notes,
    int? daysLate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      memberNisn: memberNisn ?? this.memberNisn,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      bookIsbn: bookIsbn ?? this.bookIsbn,
      borrowDate: borrowDate ?? this.borrowDate,
      dueDate: dueDate ?? this.dueDate,
      returnDate: returnDate ?? this.returnDate,
      status: status ?? this.status,
      fineAmount: fineAmount ?? this.fineAmount,
      officerName: officerName ?? this.officerName,
      returnOfficer: returnOfficer ?? this.returnOfficer,
      notes: notes ?? this.notes,
      daysLate: daysLate ?? this.daysLate,
    );
  }
}
