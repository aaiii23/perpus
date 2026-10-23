import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';

class FormalReportDialog extends StatelessWidget {
  final List<TransactionModel> transactions;

  const FormalReportDialog({super.key, required this.transactions});

  static void show(BuildContext context, List<TransactionModel> transactions) {
    showDialog(
      context: context,
      builder: (ctx) => FormalReportDialog(transactions: transactions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = StorageService().settings;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final totalFines = transactions.fold<int>(0, (sum, t) => sum + t.fineAmount);
    final activeCount = transactions.where((t) => t.status == 'Dipinjam').length;
    final overdueCount = transactions.where((t) => t.status == 'Terlambat').length;
    final returnedCount = transactions.where((t) => t.status == 'Kembali').length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 750),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Format Cetak Laporan Resmi Perpustakaan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Scrollable Printable Area
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Kop Surat Sekolah
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'PEMERINTAH DAERAH PROVINSI JAWA BARAT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Text(
                                'DINAS PENDIDIKAN • CABANG DINAS WILAYAH VII',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                settings.schoolName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                settings.libraryName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Jalan Pendidikan No. 101, Bandung • Website: smk.sch.id • Standar UKK RPL KM25.4.1.1',
                                style: TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(thickness: 2, height: 16),
                        const Divider(thickness: 1, height: 4),
                        const SizedBox(height: 12),

                        // Judul Laporan
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'LAPORAN REKAPITULASI SIRKULASI BUKU & KAS DENDA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                'Tahun Pelajaran ${settings.academicYear} • Per Tanggal: ${DateTime.now().toIso8601String().split('T')[0]}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ringkasan Statistik Grid
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).dividerColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildSummaryItem('Total Transaksi', '${transactions.length}'),
                              _buildSummaryItem('Buku Kembali', '$returnedCount'),
                              _buildSummaryItem('Dipinjam Aktif', '$activeCount'),
                              _buildSummaryItem('Terlambat', '$overdueCount'),
                              _buildSummaryItem('Total Kas Denda', currencyFormatter.format(totalFines)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Table of transactions
                        const Text(
                          'Rincian Transaksi Sirkulasi:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 36,
                            dataRowMinHeight: 36,
                            dataRowMaxHeight: 44,
                            columns: const [
                              DataColumn(label: Text('ID Transaksi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Peminjam (NISN)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Judul Buku', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Tgl Pinjam', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Batas Kembali', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Denda', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                            ],
                            rows: transactions.map((t) {
                              return DataRow(cells: [
                                DataCell(Text(t.id, style: const TextStyle(fontSize: 11, fontFamily: 'monospace'))),
                                DataCell(Text('${t.memberName} (${t.memberNisn})', style: const TextStyle(fontSize: 11))),
                                DataCell(Text(t.bookTitle, style: const TextStyle(fontSize: 11))),
                                DataCell(Text(t.borrowDate, style: const TextStyle(fontSize: 11))),
                                DataCell(Text(t.dueDate, style: const TextStyle(fontSize: 11))),
                                DataCell(
                                  Text(
                                    t.status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: t.status == 'Terlambat'
                                          ? Colors.red
                                          : (t.status == 'Kembali' ? Colors.green : const Color(0xFF4F46E5)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    t.fineAmount > 0 ? currencyFormatter.format(t.fineAmount) : 'Rp 0',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: t.fineAmount > 0 ? Colors.red : null,
                                      fontWeight: t.fineAmount > 0 ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Lembar Pengesahan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text('Mengetahui,', style: TextStyle(fontSize: 11)),
                                const Text('Kepala Perpustakaan Sekolah,', style: TextStyle(fontSize: 11)),
                                const SizedBox(height: 50),
                                Text(
                                  settings.headLibrarian,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                ),
                                Text(
                                  'NIP. ${settings.librarianNIP}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Bandung, ${DateTime.now().toIso8601String().split('T')[0]}', style: const TextStyle(fontSize: 11)),
                                const Text('Petugas Pelaksana Perpustakaan,', style: TextStyle(fontSize: 11)),
                                const SizedBox(height: 50),
                                const Text(
                                  'Siti Rahmawati, S.Kom',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                ),
                                const Text(
                                  'Petugas Sirkulasi Terpadu',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tutup'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Laporan Resmi Perpustakaan siap dicetak / diunduh.'),
                          backgroundColor: Color(0xFF4F46E5),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.print_rounded, size: 16),
                    label: const Text('Cetak Dokumen Resmi'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
