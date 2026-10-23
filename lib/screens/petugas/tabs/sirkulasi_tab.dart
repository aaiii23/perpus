import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';
import '../../../services/member_service.dart';
import '../../../services/book_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/receipt_dialog.dart';

class SirkulasiTab extends StatefulWidget {
  final VoidCallback onDataChanged;

  const SirkulasiTab({super.key, required this.onDataChanged});

  @override
  State<SirkulasiTab> createState() => _SirkulasiTabState();
}

class _SirkulasiTabState extends State<SirkulasiTab> {
  final _transactionService = TransactionService();
  final _memberService = MemberService();
  final _bookService = BookService();

  String _subTab = 'all'; // 'all' | 'active' | 'overdue' | 'returned'
  String _searchQuery = '';

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void _refresh() {
    setState(() {});
    widget.onDataChanged();
  }

  void _openNewLoanDialog() {
    final members = _memberService.getAllMembers().where((m) => m.status == 'Aktif').toList();
    final books = _bookService.getAllBooks();

    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada anggota berstatus Aktif untuk meminjam buku!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String selectedMemberId = members.first.id;
    final availableBook = books.where((b) => b.availableStock > 0).firstOrNull;
    String selectedBookId = availableBook?.id ?? (books.isNotEmpty ? books.first.id : '');
    int durationDays = 7;
    final notesController = TextEditingController(text: 'Peminjaman UKK Perpustakaan');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final curBook = books.where((b) => b.id == selectedBookId).firstOrNull;
          final isStockAvailable = curBook != null && curBook.availableStock > 0;

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Catat Peminjaman Baru',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Pilih anggota dan buku yang akan dipinjam',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Member Dropdown
                            const Text(
                              'PILIH ANGGOTA (SISWA) *',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: selectedMemberId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_rounded, size: 20),
                              ),
                              items: members.map((m) {
                                return DropdownMenuItem(
                                  value: m.id,
                                  child: Text(
                                    '${m.name} (${m.kelas} - ${m.nisn})',
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() => selectedMemberId = val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Book Dropdown
                            const Text(
                              'PILIH BUKU *',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: selectedBookId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                              ),
                              items: books.map((b) {
                                return DropdownMenuItem(
                                  value: b.id,
                                  child: Text(
                                    '${b.title} (Sisa: ${b.availableStock})',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: b.availableStock <= 0 ? Colors.red : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() => selectedBookId = val);
                                }
                              },
                            ),
                            if (!isStockAvailable)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Peringatan: Stok buku ini habis (0)!',
                                  style: TextStyle(fontSize: 11, color: Colors.red.shade600, fontWeight: FontWeight.bold),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Duration Days
                            const Text(
                              'DURASI PINJAM *',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<int>(
                              initialValue: durationDays,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.calendar_month_rounded, size: 20),
                              ),
                              items: const [
                                DropdownMenuItem(value: 3, child: Text('3 Hari')),
                                DropdownMenuItem(value: 7, child: Text('7 Hari (Standar Perpustakaan)')),
                                DropdownMenuItem(value: 14, child: Text('14 Hari (2 Minggu)')),
                                DropdownMenuItem(value: 30, child: Text('30 Hari (1 Bulan)')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setDialogState(() => durationDays = val);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Notes
                            const Text(
                              'CATATAN PEMINJAMAN',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: notesController,
                              decoration: const InputDecoration(
                                hintText: 'Contoh: Untuk tugas praktikum RPL...',
                                prefixIcon: Icon(Icons.notes_rounded, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.check_circle_rounded, size: 18),
                            label: const Text('Simpan Pinjam'),
                            onPressed: !isStockAvailable
                                ? null
                                : () async {
                                    try {
                                      final newTx = await _transactionService.borrowBook(
                                        memberId: selectedMemberId,
                                        bookId: selectedBookId,
                                        customDays: durationDays,
                                        notes: notesController.text.trim(),
                                      );

                                      if (ctx.mounted) {
                                        Navigator.of(ctx).pop();
                                      }

                                      _refresh();

                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Peminjaman berhasil dicatat! ID: ${newTx.id}'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // Show receipt dialog
                                        ReceiptDialog.show(context, newTx, type: 'loan');
                                      }
                                    } catch (e) {
                                      if (ctx.mounted) {
                                        ScaffoldMessenger.of(ctx).showSnackBar(
                                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
                                        );
                                      }
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openReturnDialog(TransactionModel tx) {
    final finePerDay = StorageService().settings.finePerDay;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int fine = 0;
    int lateDays = 0;

    try {
      final p = tx.dueDate.split('-');
      final due = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
      final diff = today.difference(due).inDays;
      if (diff > 0) {
        lateDays = diff;
        fine = lateDays * finePerDay;
      }
    } catch (_) {}

    final notesController = TextEditingController(text: lateDays > 0 ? 'Denda dilunasi di meja sirkulasi' : 'Buku kembali lengkap');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (lateDays > 0 ? Colors.red : Colors.green).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        lateDays > 0 ? Icons.warning_amber_rounded : Icons.assignment_turned_in_rounded,
                        color: lateDays > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Konfirmasi Pengembalian Buku',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            tx.id,
                            style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Nama Anggota:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(tx.memberName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Judul Buku:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Expanded(
                            child: Text(
                              tx.bookTitle,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Batas Tempo:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(tx.dueDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Denda Info
                if (lateDays > 0)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Terlambat $lateDays Hari!',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tarif Denda: ${currencyFormatter.format(finePerDay)} / hari',
                          style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                        ),
                        const Divider(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Denda yang Harus Dibayar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(
                              currencyFormatter.format(fine),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Tepat Waktu! Tidak ada tanggungan denda.',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),

                const Text('CATATAN PENGEMBALIAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
                const SizedBox(height: 6),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    hintText: 'Kondisi buku baik / denda lunas...',
                    prefixIcon: Icon(Icons.edit_note_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Proses Kembali'),
                        onPressed: () async {
                          try {
                            final updated = await _transactionService.returnBook(tx.id, notesController.text.trim());
                            if (ctx.mounted) {
                              Navigator.of(ctx).pop();
                            }
                            _refresh();

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Buku "${updated.bookTitle}" telah berhasil dikembalikan!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              ReceiptDialog.show(context, updated, type: 'return');
                            }
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _extendLoan(TransactionModel tx) async {
    try {
      final updated = await _transactionService.extendLoan(tx.id, 7);
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Batas pinjam berhasil diperpanjang hingga ${updated.dueDate} (+7 Hari)'),
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

    final allTransactions = _transactionService.getAllTransactions();

    final activeCount = allTransactions.where((t) => t.status == 'Dipinjam').length;
    final overdueCount = allTransactions.where((t) => t.status == 'Terlambat').length;
    final returnedCount = allTransactions.where((t) => t.status == 'Kembali').length;

    final filtered = allTransactions.where((tx) {
      final matchesSearch = tx.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.memberName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.memberNisn.contains(_searchQuery) ||
          tx.bookTitle.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_subTab == 'active') return tx.status == 'Dipinjam';
      if (_subTab == 'overdue') return tx.status == 'Terlambat';
      if (_subTab == 'returned') return tx.status == 'Kembali';
      return true;
    }).toList();

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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.sync_alt_rounded, color: Color(0xFF4F46E5), size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sirkulasi Peminjaman & Denda',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pencatatan pinjam baru, pengembalian, perpanjangan, serta cetak struk bukti transaksi',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _openNewLoanDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('Pinjam Baru'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sub-Tab Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabButton('all', 'Semua Transaksi', allTransactions.length, Colors.indigo),
                const SizedBox(width: 8),
                _buildTabButton('active', 'Dipinjam', activeCount, Colors.blue),
                const SizedBox(width: 8),
                _buildTabButton('overdue', 'Terlambat (Denda)', overdueCount, Colors.red),
                const SizedBox(width: 8),
                _buildTabButton('returned', 'Selesai Kembali', returnedCount, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari berdasarkan ID Transaksi, Nama Siswa, NISN, atau Judul Buku...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 16),

          // List of Transactions
          if (filtered.isEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Tidak ada transaksi yang sesuai kriteria filter',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tx = filtered[index];
                return _buildTransactionCard(context, tx, isDark);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String key, String label, int count, Color color) {
    final isSelected = _subTab == key;
    return InkWell(
      onTap: () => setState(() => _subTab = key),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4F46E5) : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : null,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, TransactionModel tx, bool isDark) {
    Color statusColor;
    IconData statusIcon;
    if (tx.status == 'Kembali') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
    } else if (tx.status == 'Terlambat') {
      statusColor = Colors.red;
      statusIcon = Icons.error_rounded;
    } else {
      statusColor = Colors.blue;
      statusIcon = Icons.schedule_rounded;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: ID + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tx.id,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tgl: ${tx.borrowDate}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 13, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        tx.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 18),

            // Book & Member info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: Color(0xFF4F46E5), size: 24),
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
                        'Peminjam: ${tx.memberName} (${tx.memberNisn})',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.event_rounded, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Jatuh Tempo: ${tx.dueDate}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: tx.status == 'Terlambat' ? Colors.red : Colors.grey.shade600,
                            ),
                          ),
                          if (tx.returnDate != null) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.event_available_rounded, size: 13, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Kembali: ${tx.returnDate}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Overdue fine warning banner
            if (tx.status == 'Terlambat')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Terlambat ${tx.daysLate} hari • Akumulasi Denda: ${currencyFormatter.format(tx.fineAmount)}',
                          style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (tx.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Catatan: ${tx.notes}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 12),

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (tx.status != 'Kembali') ...[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(Icons.assignment_returned_rounded, size: 15),
                    label: const Text('Kembalikan Buku'),
                    onPressed: () => _openReturnDialog(tx),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.update_rounded, size: 15),
                    label: const Text('Perpanjang (+7 Hari)'),
                    onPressed: () => _extendLoan(tx),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.receipt_long_rounded, size: 15),
                    label: const Text('Struk Pinjam'),
                    onPressed: () => ReceiptDialog.show(context, tx, type: 'loan'),
                  ),
                ] else ...[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.receipt_rounded, size: 15),
                    label: const Text('Cetak Bukti Pengembalian'),
                    onPressed: () => ReceiptDialog.show(context, tx, type: 'return'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
