import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';

class ReceiptDialog extends StatelessWidget {
  final TransactionModel transaction;
  final bool isReturn;

  const ReceiptDialog({
    super.key,
    required this.transaction,
    this.isReturn = false,
  });

  static void show(
    BuildContext context,
    TransactionModel transaction, {
    bool isReturn = false,
    String? type,
  }) {
    final effectiveIsReturn = type != null ? (type == 'return') : isReturn;
    showDialog(
      context: context,
      builder: (ctx) => ReceiptDialog(transaction: transaction, isReturn: effectiveIsReturn),
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dialog Title & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isReturn ? 'Bukti Pengembalian Buku' : 'Bukti Peminjaman Buku',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // The Printable Paper Receipt Container
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.4),
                    style: BorderStyle.solid,
                  ),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Perpustakaan
                    Column(
                      children: [
                        const Icon(Icons.menu_book_rounded, color: Color(0xFF4F46E5), size: 26),
                        const SizedBox(height: 4),
                        Text(
                          settings.libraryName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          settings.schoolName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Tahun Ajaran ${settings.academicYear} • Standar UKK RPL KM25.4.1.1',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Key-Value rows
                    _buildRow(context, 'No. Transaksi', transaction.id, isBoldValue: true),
                    _buildRow(context, 'Nama Anggota', '${transaction.memberName} (${transaction.memberNisn})'),
                    _buildRow(context, 'Judul Buku', transaction.bookTitle, isBoldValue: true),
                    _buildRow(context, 'ISBN', transaction.bookIsbn),
                    _buildRow(context, 'Tgl. Pinjam', transaction.borrowDate),
                    _buildRow(
                      context,
                      'Batas Kembali',
                      transaction.dueDate,
                      valueColor: const Color(0xFF4F46E5),
                      isBoldValue: true,
                    ),

                    if (isReturn || transaction.returnDate != null) ...[
                      _buildRow(
                        context,
                        'Tgl. Kembali',
                        transaction.returnDate ?? '-',
                        valueColor: Colors.green,
                        isBoldValue: true,
                      ),
                      _buildRow(
                        context,
                        'Denda Terlambat',
                        currencyFormatter.format(transaction.fineAmount),
                        valueColor: transaction.fineAmount > 0 ? Colors.red : Colors.green,
                        isBoldValue: true,
                      ),
                    ],

                    if (transaction.notes.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Catatan: ${transaction.notes}',
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    // Signatures
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text('Peminjam / Anggota,', style: TextStyle(fontSize: 11)),
                            const SizedBox(height: 38),
                            Text(
                              '( ${transaction.memberName} )',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Petugas Perpustakaan,', style: TextStyle(fontSize: 11)),
                            const SizedBox(height: 38),
                            Text(
                              '( ${transaction.officerName} )',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
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
                          content: Text('Dokumen struk bukti transaksi siap dicetak / diunduh.'),
                          backgroundColor: Color(0xFF4F46E5),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.print_rounded, size: 16),
                    label: const Text('Cetak Dokumen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
