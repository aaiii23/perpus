import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/user_model.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';
import '../../../services/member_service.dart';
import '../../../widgets/receipt_dialog.dart';

class PeminjamanSayaTab extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback onDataChanged;

  const PeminjamanSayaTab({
    super.key,
    required this.currentUser,
    required this.onDataChanged,
  });

  @override
  State<PeminjamanSayaTab> createState() => _PeminjamanSayaTabState();
}

class _PeminjamanSayaTabState extends State<PeminjamanSayaTab> {
  final _transactionService = TransactionService();
  final _memberService = MemberService();

  String _subTab = 'active'; // 'active' | 'history'

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void _extendLoan(TransactionModel tx) async {
    try {
      final updated = await _transactionService.extendLoan(tx.id, 7);
      setState(() {});
      widget.onDataChanged();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Batas peminjaman buku berhasil diperpanjang hingga ${updated.dueDate} (+7 Hari)'),
            backgroundColor: const Color(0xFF4F46E5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '');
    final studentNisn = member?.nisn ?? widget.currentUser.nisn ?? '';

    final allTransactions = _transactionService.getAllTransactions().where(
          (t) => t.memberNisn == studentNisn || (studentNisn.isEmpty && t.memberName == widget.currentUser.name),
        ).toList();

    final activeLoans = allTransactions.where((t) => t.status == 'Dipinjam' || t.status == 'Terlambat').toList();
    final completedLoans = allTransactions.where((t) => t.status == 'Kembali').toList();

    final currentList = _subTab == 'active' ? activeLoans : completedLoans;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.history_edu_rounded, color: Color(0xFF4F46E5), size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peminjaman & Riwayat Saya',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pantau batas waktu buku yang sedang dipinjam dan riwayat membaca',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Tab switcher buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _subTab == 'active' ? const Color(0xFF4F46E5) : Colors.grey.withValues(alpha: 0.15),
                            foregroundColor: _subTab == 'active' ? Colors.white : Colors.grey.shade700,
                            elevation: _subTab == 'active' ? 2 : 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.book_rounded, size: 16),
                          label: Text('Sedang Dipinjam (${activeLoans.length})'),
                          onPressed: () => setState(() => _subTab = 'active'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _subTab == 'history' ? const Color(0xFF4F46E5) : Colors.grey.withValues(alpha: 0.15),
                            foregroundColor: _subTab == 'history' ? Colors.white : Colors.grey.shade700,
                            elevation: _subTab == 'history' ? 2 : 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                          label: Text('Riwayat Selesai (${completedLoans.length})'),
                          onPressed: () => setState(() => _subTab = 'history'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Content List
          if (currentList.isEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      _subTab == 'active' ? Icons.check_circle_outline_rounded : Icons.history_rounded,
                      size: 52,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _subTab == 'active'
                          ? 'Kamu tidak memiliki tanggungan pinjaman buku'
                          : 'Belum ada riwayat peminjaman yang selesai',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subTab == 'active'
                          ? 'Koleksi buku kamu rapi! Silakan buka katalog untuk meminjam buku favoritmu.'
                          : 'Semua buku yang selesai dikembalikan akan tercatat di sini.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: currentList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tx = currentList[index];
                final isOverdue = tx.status == 'Terlambat';
                final isReturned = tx.status == 'Kembali';

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tx.id,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace'),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isReturned
                                        ? Colors.green
                                        : isOverdue
                                            ? Colors.red
                                            : Colors.blue)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tx.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: isReturned
                                      ? Colors.green
                                      : isOverdue
                                          ? Colors.red
                                          : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 18),

                        // Book Title & ISBN
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.menu_book_rounded, color: Color(0xFF4F46E5), size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.bookTitle,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ISBN: ${tx.bookIsbn}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tgl Pinjam: ${tx.borrowDate}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  Text(
                                    'Jatuh Tempo: ${tx.dueDate}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isOverdue ? Colors.red : Colors.indigo,
                                    ),
                                  ),
                                  if (tx.returnDate != null)
                                    Text(
                                      'Dikembalikan Pada: ${tx.returnDate}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Overdue fine banner
                        if (isOverdue)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Terlambat ${tx.daysLate} hari! Harap lunasi denda ${currencyFormatter.format(tx.fineAmount)} saat mengembalikan buku ke petugas.',
                                      style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 12),
                        // Actions
                        Row(
                          children: [
                            if (!isReturned) ...[
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                icon: const Icon(Icons.update_rounded, size: 14),
                                label: const Text('Perpanjang (+7 Hari)', style: TextStyle(fontSize: 11)),
                                onPressed: () => _extendLoan(tx),
                              ),
                              const SizedBox(width: 8),
                            ],
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.receipt_long_rounded, size: 14),
                              label: Text(
                                isReturned ? 'Struk Pengembalian' : 'Struk Pinjam',
                                style: const TextStyle(fontSize: 11),
                              ),
                              onPressed: () => ReceiptDialog.show(
                                context,
                                tx,
                                type: isReturned ? 'return' : 'loan',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
