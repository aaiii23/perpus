import '../models/book_model.dart';
import '../models/transaction_model.dart';
import 'book_service.dart';
import 'member_service.dart';
import 'transaction_service.dart';

class DashboardStats {
  final int totalTitles;
  final int totalBooks;
  final int totalMembers;
  final int activeMembers;
  final int activeLoansCount;
  final int overdueLoansCount;
  final int totalTransactionsCount;
  final int totalFinesCollected;
  final int potentialOverdueFines;
  final List<BookModel> topBooks;
  final List<TransactionModel> recentTransactions;

  DashboardStats({
    required this.totalTitles,
    required this.totalBooks,
    required this.totalMembers,
    required this.activeMembers,
    required this.activeLoansCount,
    required this.overdueLoansCount,
    required this.totalTransactionsCount,
    required this.totalFinesCollected,
    required this.potentialOverdueFines,
    required this.topBooks,
    required this.recentTransactions,
  });
}

class MemberStats {
  final int totalBorrowed;
  final List<TransactionModel> activeLoans;
  final List<TransactionModel> overdueLoans;
  final List<TransactionModel> completedLoans;
  final int totalFines;
  final List<TransactionModel> recentActivity;

  MemberStats({
    required this.totalBorrowed,
    required this.activeLoans,
    required this.overdueLoans,
    required this.completedLoans,
    required this.totalFines,
    required this.recentActivity,
  });

  int get overdueCount => overdueLoans.length;
  int get returnedCount => completedLoans.length;
  int get totalFine => totalFines;
}

class StatsService {
  final BookService _bookService = BookService();
  final MemberService _memberService = MemberService();
  final TransactionService _transactionService = TransactionService();

  DashboardStats getDashboardStats() {
    final books = _bookService.getAllBooks();
    final members = _memberService.getAllMembers();
    final transactions = _transactionService.getAllTransactions();

    final totalBooks = books.fold<int>(0, (sum, b) => sum + b.stock);
    final totalTitles = books.length;
    final totalMembers = members.length;
    final activeMembers = members.where((m) => m.status == 'Aktif').length;

    final activeLoans = transactions.where((t) => t.status == 'Dipinjam').toList();
    final overdueLoans = transactions.where((t) => t.status == 'Terlambat').toList();
    final returnedLoans = transactions.where((t) => t.status == 'Kembali').toList();

    final totalFinesCollected =
        returnedLoans.fold<int>(0, (sum, t) => sum + t.fineAmount);
    final potentialOverdueFines =
        overdueLoans.fold<int>(0, (sum, t) => sum + t.fineAmount);

    final sortedBooks = List<BookModel>.from(books)
      ..sort((a, b) => b.borrowedCount.compareTo(a.borrowedCount));
    final topBooks = sortedBooks.take(5).toList();

    return DashboardStats(
      totalTitles: totalTitles,
      totalBooks: totalBooks,
      totalMembers: totalMembers,
      activeMembers: activeMembers,
      activeLoansCount: activeLoans.length,
      overdueLoansCount: overdueLoans.length,
      totalTransactionsCount: transactions.length,
      totalFinesCollected: totalFinesCollected,
      potentialOverdueFines: potentialOverdueFines,
      topBooks: topBooks,
      recentTransactions: transactions.take(6).toList(),
    );
  }

  MemberStats getMemberStats(String memberNisn) {
    final transactions = _transactionService
        .getAllTransactions()
        .where((t) => t.memberNisn == memberNisn.trim())
        .toList();

    final activeLoans = transactions.where((t) => t.status == 'Dipinjam').toList();
    final overdueLoans = transactions.where((t) => t.status == 'Terlambat').toList();
    final completedLoans = transactions.where((t) => t.status == 'Kembali').toList();

    final totalFines = transactions.fold<int>(0, (sum, t) => sum + t.fineAmount);

    return MemberStats(
      totalBorrowed: transactions.length,
      activeLoans: activeLoans,
      overdueLoans: overdueLoans,
      completedLoans: completedLoans,
      totalFines: totalFines,
      recentActivity: transactions.take(5).toList(),
    );
  }

  String generateCSV(List<TransactionModel> transactions) {
    final buffer = StringBuffer();
    buffer.writeln(
      'ID Transaksi,Nama Anggota,NISN,Judul Buku,ISBN,Tgl Pinjam,Batas Kembali,Tgl Kembali,Status,Denda (Rp),Petugas',
    );
    for (final t in transactions) {
      buffer.writeln(
        '"${t.id}","${t.memberName}","${t.memberNisn}","${t.bookTitle}","${t.bookIsbn}","${t.borrowDate}","${t.dueDate}","${t.returnDate ?? '-'}","${t.status}",${t.fineAmount},"${t.officerName}"',
      );
    }
    return buffer.toString();
  }
}
