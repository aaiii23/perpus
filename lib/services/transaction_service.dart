import '../models/transaction_model.dart';
import '../models/book_model.dart';
import 'storage_service.dart';

class TransactionService {
  final StorageService _storage = StorageService();

  List<TransactionModel> getAllTransactions() {
    final rawList = _storage.getTransactions();
    final finePerDay = _storage.settings.finePerDay;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return rawList.map((tx) {
      if (tx.status == 'Kembali') {
        return tx;
      }

      // Parse due date
      try {
        final parts = tx.dueDate.split('-');
        final dueYear = int.parse(parts[0]);
        final dueMonth = int.parse(parts[1]);
        final dueDay = int.parse(parts[2]);
        final due = DateTime(dueYear, dueMonth, dueDay);

        final diffDays = today.difference(due).inDays;
        if (diffDays > 0) {
          return tx.copyWith(
            status: 'Terlambat',
            daysLate: diffDays,
            fineAmount: diffDays * finePerDay,
          );
        } else {
          return tx.copyWith(
            status: 'Dipinjam',
            daysLate: 0,
            fineAmount: 0,
          );
        }
      } catch (_) {
        return tx;
      }
    }).toList();
  }

  Future<TransactionModel> borrowBook({
    required String memberId,
    required String bookId,
    int? customDays,
    String? notes,
  }) async {
    final members = _storage.getMembers();
    final books = List<BookModel>.from(_storage.getBooks());
    final transactions = _storage.getTransactions();
    final settings = _storage.settings;

    final member = members.cast<dynamic>().firstWhere(
      (m) => m.id == memberId,
      orElse: () => null,
    );
    if (member == null) {
      throw Exception('Data anggota tidak ditemukan!');
    }
    if (member.status != 'Aktif') {
      throw Exception('Status keanggotaan tidak aktif. Tidak dapat meminjam buku!');
    }

    // Check active loan limit
    final activeLoans = transactions.where(
      (t) =>
          t.memberId == memberId &&
          (t.status == 'Dipinjam' || t.status == 'Terlambat'),
    ).toList();

    final maxLimit = settings.maxBorrowLimit;
    if (activeLoans.length >= maxLimit) {
      throw Exception(
        'Anggota telah mencapai batas maksimal peminjaman ($maxLimit buku aktif)!',
      );
    }

    // Check if member has unreturned overdue books
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final hasOverdue = activeLoans.any((t) {
      try {
        final p = t.dueDate.split('-');
        final d = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
        return today.isAfter(d);
      } catch (_) {
        return false;
      }
    });

    if (hasOverdue) {
      throw Exception(
        'Anggota memiliki buku yang terlambat dikembalikan. Harap kembalikan buku terlebih dahulu!',
      );
    }

    final bookIndex = books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1) {
      throw Exception('Data buku tidak ditemukan!');
    }
    final book = books[bookIndex];
    if (book.availableStock <= 0) {
      throw Exception('Stok buku saat ini sedang habis / tidak tersedia!');
    }

    // Reduce stock and increment borrow count
    books[bookIndex] = book.copyWith(
      availableStock: book.availableStock - 1,
      borrowedCount: book.borrowedCount + 1,
    );

    final loanDays = customDays ?? settings.loanDurationDays;
    final borrowDate = DateTime.now();
    final dueDate = borrowDate.add(Duration(days: loanDays));

    final borrowDateStr =
        "${borrowDate.year.toString().padLeft(4, '0')}-${borrowDate.month.toString().padLeft(2, '0')}-${borrowDate.day.toString().padLeft(2, '0')}";
    final dueDateStr =
        "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";

    final currentUser = _storage.currentUser;
    final txId =
        'TRX-${borrowDate.year}-${(transactions.length + 1).toString().padLeft(3, '0')}';

    final newTx = TransactionModel(
      id: txId,
      memberId: member.id,
      memberName: member.name,
      memberNisn: member.nisn,
      bookId: book.id,
      bookTitle: book.title,
      bookIsbn: book.isbn,
      borrowDate: borrowDateStr,
      dueDate: dueDateStr,
      returnDate: null,
      status: 'Dipinjam',
      fineAmount: 0,
      officerName: currentUser?.name ?? 'Petugas Perpustakaan',
      notes: notes?.isNotEmpty == true ? notes! : 'Peminjaman Reguler Perpustakaan',
    );

    await _storage.setBooks(books);
    await _storage.setTransactions([newTx, ...transactions]);

    await _storage.logActivity(
      'BORROW_BOOK',
      'Peminjaman buku "${book.title}" oleh ${member.name} (Tempo: $dueDateStr)',
    );

    return newTx;
  }

  Future<TransactionModel> returnBook(String transactionId, String? notes) async {
    final transactions = List<TransactionModel>.from(_storage.getTransactions());
    final books = List<BookModel>.from(_storage.getBooks());
    final finePerDay = _storage.settings.finePerDay;

    final txIndex = transactions.indexWhere((t) => t.id == transactionId);
    if (txIndex == -1) {
      throw Exception('Transaksi peminjaman tidak ditemukan!');
    }

    final tx = transactions[txIndex];
    if (tx.status == 'Kembali') {
      throw Exception('Buku ini sudah dikembalikan sebelumnya!');
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final returnDateStr =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    int fine = 0;
    int daysLate = 0;

    try {
      final p = tx.dueDate.split('-');
      final due = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
      final diff = today.difference(due).inDays;
      if (diff > 0) {
        daysLate = diff;
        fine = daysLate * finePerDay;
      }
    } catch (_) {}

    // Restore book stock
    final bookIndex = books.indexWhere((b) => b.id == tx.bookId);
    if (bookIndex != -1) {
      final b = books[bookIndex];
      books[bookIndex] = b.copyWith(
        availableStock: (b.availableStock + 1).clamp(0, b.stock),
      );
      await _storage.setBooks(books);
    }

    final currentUser = _storage.currentUser;
    final updatedTx = tx.copyWith(
      returnDate: returnDateStr,
      status: 'Kembali',
      fineAmount: fine,
      daysLate: daysLate,
      returnOfficer: currentUser?.name ?? 'Petugas',
      notes: notes != null && notes.isNotEmpty
          ? '${tx.notes} | Ket. Kembali: $notes'
          : tx.notes,
    );

    transactions[txIndex] = updatedTx;
    await _storage.setTransactions(transactions);

    await _storage.logActivity(
      'RETURN_BOOK',
      'Pengembalian buku "${tx.bookTitle}" oleh ${tx.memberName}. Denda: Rp $fine',
    );

    return updatedTx;
  }

  Future<TransactionModel> extendLoan(String transactionId, [int extraDays = 7]) async {
    final transactions = List<TransactionModel>.from(_storage.getTransactions());
    final txIndex = transactions.indexWhere((t) => t.id == transactionId);
    if (txIndex == -1) {
      throw Exception('Transaksi peminjaman tidak ditemukan!');
    }

    final tx = transactions[txIndex];
    if (tx.status == 'Kembali') {
      throw Exception('Peminjaman sudah selesai, tidak bisa diperpanjang!');
    }

    final parts = tx.dueDate.split('-');
    final currentDue = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final newDue = currentDue.add(Duration(days: extraDays));
    final newDueDateStr =
        "${newDue.year.toString().padLeft(4, '0')}-${newDue.month.toString().padLeft(2, '0')}-${newDue.day.toString().padLeft(2, '0')}";

    final updatedTx = tx.copyWith(
      dueDate: newDueDateStr,
      notes: '${tx.notes} (Diperpanjang +$extraDays hari)',
    );

    transactions[txIndex] = updatedTx;
    await _storage.setTransactions(transactions);

    await _storage.logActivity(
      'EXTEND_LOAN',
      'Perpanjangan pinjam "${tx.bookTitle}" sampai $newDueDateStr',
    );

    return updatedTx;
  }
}
