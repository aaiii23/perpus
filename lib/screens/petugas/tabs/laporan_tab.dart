import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../services/transaction_service.dart';
import '../../../widgets/formal_report_dialog.dart';

class LaporanTab extends StatefulWidget {
  final VoidCallback onDataChanged;

  const LaporanTab({super.key, required this.onDataChanged});

  @override
  State<LaporanTab> createState() => _LaporanTabState();
}

class _LaporanTabState extends State<LaporanTab> {
  final _transactionService = TransactionService();

  String _filterStatus = 'Semua';
  DateTime? _startDate;
  DateTime? _endDate;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String _formatDate(DateTime d) {
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  void _exportCSV(List<TransactionModel> transactions) {
    final buffer = StringBuffer();
    buffer.writeln('ID_Transaksi,Nama_Anggota,NISN,Judul_Buku,ISBN,Tgl_Pinjam,Batas_Kembali,Tgl_Kembali,Status,Denda_Rp,Petugas');

    for (final t in transactions) {
      buffer.writeln(
        '"${t.id}","${t.memberName}","${t.memberNisn}","${t.bookTitle}","${t.bookIsbn}","${t.borrowDate}","${t.dueDate}","${t.returnDate ?? '-'}","${t.status}",${t.fineAmount},"${t.officerName}"',
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Laporan ${transactions.length} transaksi berhasil digenerate dalam format CSV/Excel!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Isi Laporan CSV / Excel'),
                content: SizedBox(
                  width: 500,
                  height: 300,
                  child: SingleChildScrollView(
                    child: SelectableText(
                      buffer.toString(),
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTransactions = _transactionService.getAllTransactions();

    final filtered = allTransactions.where((tx) {
      final matchesStatus = _filterStatus == 'Semua' || tx.status == _filterStatus;
      bool matchesDate = true;
      if (_startDate != null) {
        final startStr = _formatDate(_startDate!);
        if (tx.borrowDate.compareTo(startStr) < 0) matchesDate = false;
      }
      if (_endDate != null) {
        final endStr = _formatDate(_endDate!);
        if (tx.borrowDate.compareTo(endStr) > 0) matchesDate = false;
      }
      return matchesStatus && matchesDate;
    }).toList();

    final totalDendaFiltered = filtered.fold<int>(0, (sum, t) => sum + t.fineAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
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
                        child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF4F46E5), size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Laporan Rekapitulasi & Statistik',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Rekapitulasi sirkulasi, data keterlambatan, kas denda & cetak format resmi UKK',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        icon: const Icon(Icons.print_rounded, size: 18),
                        label: const Text('Cetak Laporan Resmi'),
                        onPressed: () => FormalReportDialog.show(context, filtered),
                      ),
                      OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        icon: const Icon(Icons.table_view_rounded, size: 18),
                        label: const Text('Ekspor Excel / CSV'),
                        onPressed: () => _exportCSV(filtered),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filters Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FILTER REKAPITULASI',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Status dropdown
                      SizedBox(
                        width: 170,
                        child: DropdownButtonFormField<String>(
                          initialValue: _filterStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Semua', child: Text('Semua Status')),
                            DropdownMenuItem(value: 'Dipinjam', child: Text('Sedang Dipinjam')),
                            DropdownMenuItem(value: 'Terlambat', child: Text('Terlambat')),
                            DropdownMenuItem(value: 'Kembali', child: Text('Sudah Kembali')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _filterStatus = val);
                          },
                        ),
                      ),

                      // Start date
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        icon: const Icon(Icons.calendar_today_rounded, size: 16),
                        label: Text(
                          _startDate != null ? 'Dari: ${_formatDate(_startDate!)}' : 'Dari Tanggal',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setState(() => _startDate = picked);
                        },
                      ),

                      // End date
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        icon: const Icon(Icons.event_rounded, size: 16),
                        label: Text(
                          _endDate != null ? 'Sampai: ${_formatDate(_endDate!)}' : 'Sampai Tanggal',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) setState(() => _endDate = picked);
                        },
                      ),

                      if (_startDate != null || _endDate != null || _filterStatus != 'Semua')
                        TextButton.icon(
                          icon: const Icon(Icons.restart_alt_rounded, size: 16),
                          label: const Text('Reset Filter'),
                          onPressed: () {
                            setState(() {
                              _filterStatus = 'Semua';
                              _startDate = null;
                              _endDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mini KPI Summary
          Row(
            children: [
              Expanded(
                child: _buildMiniKpi(
                  'TOTAL TRANSAKSI',
                  '${filtered.length}',
                  'Data Sesuai Filter',
                  Icons.receipt_long_rounded,
                  Colors.indigo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniKpi(
                  'TOTAL DENDA',
                  currencyFormatter.format(totalDendaFiltered),
                  'Kas Denda Filter',
                  Icons.payments_rounded,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data Table / Cards
          if (filtered.isEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.folder_off_rounded, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Tidak ada data transaksi pada rentang filter ini',
                      style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
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
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = filtered[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tx.id,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, fontFamily: 'monospace'),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (tx.status == 'Kembali'
                                        ? Colors.green
                                        : tx.status == 'Terlambat'
                                            ? Colors.red
                                            : Colors.blue)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tx.status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: tx.status == 'Kembali'
                                      ? Colors.green
                                      : tx.status == 'Terlambat'
                                          ? Colors.red
                                          : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tx.bookTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Peminjam: ${tx.memberName} (${tx.memberNisn})',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pinjam: ${tx.borrowDate} • Tempo: ${tx.dueDate}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            if (tx.fineAmount > 0)
                              Text(
                                'Denda: ${currencyFormatter.format(tx.fineAmount)}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
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

  Widget _buildMiniKpi(String label, String value, String sub, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey)),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
