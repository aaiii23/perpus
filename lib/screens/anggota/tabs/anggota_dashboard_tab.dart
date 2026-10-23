import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/user_model.dart';
import '../../../models/book_model.dart';
import '../../../services/member_service.dart';
import '../../../services/book_service.dart';
import '../../../services/stats_service.dart';
import '../../../services/storage_service.dart';
import '../../../widgets/member_card_dialog.dart';

class AnggotaDashboardTab extends StatelessWidget {
  final UserModel currentUser;
  final ValueChanged<int> onNavigateTab;
  final VoidCallback onDataChanged;

  const AnggotaDashboardTab({
    super.key,
    required this.currentUser,
    required this.onNavigateTab,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final memberService = MemberService();
    final bookService = BookService();
    final statsService = StatsService();
    final settings = StorageService().settings;

    final member = memberService.getMemberByNisn(currentUser.nisn ?? '') ??
        memberService.getAllMembers().firstOrNull;

    final memberStats = statsService.getMemberStats(member?.nisn ?? currentUser.nisn ?? '');
    final books = bookService.getAllBooks();
    final recommendedBooks = books.take(4).toList();

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Welcome Card with Gradient
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_rounded, color: Colors.amberAccent, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Siswa Terverifikasi • ${settings.schoolName}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hai, ${member?.name ?? currentUser.name}! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Selamat datang di portal perpustakaan digital sekolah. Cari buku pelajaran, pantau tanggal jatuh tempo pinjaman, dan ajukan peminjaman buku secara mandiri.',
                  style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.menu_book_rounded, size: 18),
                      label: const Text('Buka Katalog Buku'),
                      onPressed: () => onNavigateTab(1),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: Text('Pinjaman Saya (${memberStats.activeLoans.length})'),
                      onPressed: () => onNavigateTab(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Digital Member Card Mockup Preview
          if (member != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(member.avatar),
                      backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  member.name,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'AKTIF',
                                  style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NISN: ${member.nisn} • ${member.kelas}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member.jurusan,
                            style: TextStyle(fontSize: 11, color: isDark ? Colors.indigoAccent : const Color(0xFF4F46E5)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.badge_rounded, color: Color(0xFF4F46E5)),
                      tooltip: 'Lihat Kartu Anggota',
                      onPressed: () => MemberCardDialog.show(context, member),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // KPI Stats Grid (4 Cards)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _buildKpiCard(
                'SEDANG DIPINJAM',
                '${memberStats.activeLoans.length}',
                'Buku Fisik',
                Icons.book_rounded,
                Colors.blue,
                () => onNavigateTab(2),
              ),
              _buildKpiCard(
                'TOTAL PERNAH PINJAM',
                '${memberStats.totalBorrowed}',
                'Riwayat Transaksi',
                Icons.auto_stories_rounded,
                Colors.indigo,
                () => onNavigateTab(2),
              ),
              _buildKpiCard(
                'TANGGUNGAN DENDA',
                currencyFormatter.format(memberStats.totalFine),
                memberStats.overdueCount > 0 ? '${memberStats.overdueCount} Buku Terlambat' : 'Tidak Ada Denda',
                Icons.payments_rounded,
                memberStats.totalFine > 0 ? Colors.red : Colors.green,
                () => onNavigateTab(2),
              ),
              _buildKpiCard(
                'SISA KUOTA PINJAM',
                '${(settings.maxBorrowLimit - memberStats.activeLoans.length).clamp(0, settings.maxBorrowLimit)}',
                'Maksimal ${settings.maxBorrowLimit} Buku',
                Icons.check_circle_rounded,
                const Color(0xFF10B981),
                () => onNavigateTab(1),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Recommended Books Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rekomendasi Koleksi Buku',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              TextButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Lihat Semua'),
                onPressed: () => onNavigateTab(1),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Recommended Books Horizontal Carousel / List
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedBooks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final b = recommendedBooks[index];
                return _buildBookCard(context, b, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String sub,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, BookModel book, bool isDark) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () => onNavigateTab(1),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                book.cover,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.menu_book_rounded, size: 36, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (book.availableStock > 0 ? Colors.green : Colors.red).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.availableStock > 0 ? 'Tersedia (${book.availableStock})' : 'Habis',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: book.availableStock > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
