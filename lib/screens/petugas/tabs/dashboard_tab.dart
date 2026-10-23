import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/stats_service.dart';

class DashboardTab extends StatelessWidget {
  final ValueChanged<int> onNavigateTab;

  const DashboardTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final statsService = StatsService();
    final stats = statsService.getDashboardStats();
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Banner
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4338CA), Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: Colors.greenAccent, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'PANEL PETUGAS • UKK RPL KM25.4.1.1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Selamat Datang di SIMPERPUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola katalog buku, sirkulasi peminjaman, anggota, serta denda keterlambatan secara otomatis.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => onNavigateTab(3), // Sirkulasi tab
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                      label: const Text('Proses Sirkulasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => onNavigateTab(4), // Laporan tab
                      icon: const Icon(Icons.bar_chart_rounded, size: 16),
                      label: const Text('Rekap Laporan', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Overdue Warning Banner
          if (stats.overdueLoansCount > 0) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peringatan: ${stats.overdueLoansCount} Peminjaman Melewati Batas Jatuh Tempo!',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Estimasi akumulasi denda berjalan: ${currencyFormatter.format(stats.potentialOverdueFines)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab(3),
                    child: const Text('Tinjau', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // KPI Metrics Grid
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              _buildKpiCard(
                context,
                title: 'KATALOG BUKU',
                mainValue: '${stats.totalBooks}',
                unit: 'Eks',
                subText: '${stats.totalTitles} Judul Buku',
                icon: Icons.book_rounded,
                color: const Color(0xFF4F46E5),
                onTap: () => onNavigateTab(1),
              ),
              _buildKpiCard(
                context,
                title: 'ANGGOTA SISWA',
                mainValue: '${stats.totalMembers}',
                unit: 'Siswa',
                subText: '${stats.activeMembers} Status Aktif',
                icon: Icons.people_rounded,
                color: const Color(0xFF0EA5E9),
                onTap: () => onNavigateTab(2),
              ),
              _buildKpiCard(
                context,
                title: 'PINJAM AKTIF',
                mainValue: '${stats.activeLoansCount}',
                unit: 'Buku',
                subText: '${stats.overdueLoansCount} Terlambat',
                icon: Icons.repeat_rounded,
                color: Colors.amber.shade800,
                onTap: () => onNavigateTab(3),
              ),
              _buildKpiCard(
                context,
                title: 'KAS DENDA',
                mainValue: currencyFormatter.format(stats.totalFinesCollected),
                unit: '',
                subText: 'Denda Terkumpul',
                icon: Icons.payments_rounded,
                color: const Color(0xFF10B981),
                onTap: () => onNavigateTab(4),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Top Most Borrowed Books
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Koleksi Terfavorit (Sering Dipinjam)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () => onNavigateTab(1),
                        child: const Text('Katalog Lengkap', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.topBooks.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (ctx, index) {
                      final book = stats.topBooks[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '#${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4F46E5),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          book.title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${book.author} • ${book.category}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${book.borrowedCount}x Pinjam',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Circulation Transactions
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Aktivitas Sirkulasi Terakhir',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      TextButton(
                        onPressed: () => onNavigateTab(3),
                        child: const Text('Semua Transaksi', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.recentTransactions.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (ctx, index) {
                      final tx = stats.recentTransactions[index];
                      final isOverdue = tx.status == 'Terlambat';
                      final isReturned = tx.status == 'Kembali';

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? Colors.red.withOpacity(0.12)
                                : (isReturned ? Colors.green.withOpacity(0.12) : const Color(0xFF4F46E5).withOpacity(0.12)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isOverdue
                                ? Icons.warning_amber_rounded
                                : (isReturned ? Icons.check_circle_outline_rounded : Icons.sync_rounded),
                            color: isOverdue ? Colors.red : (isReturned ? Colors.green : const Color(0xFF4F46E5)),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          tx.bookTitle,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Peminjam: ${tx.memberName} • Batas: ${tx.dueDate}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? Colors.red.withOpacity(0.1)
                                : (isReturned ? Colors.green.withOpacity(0.1) : const Color(0xFF4F46E5).withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tx.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isOverdue ? Colors.red : (isReturned ? Colors.green : const Color(0xFF4F46E5)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String mainValue,
    required String unit,
    required String subText,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          mainValue,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unit.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subText,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
