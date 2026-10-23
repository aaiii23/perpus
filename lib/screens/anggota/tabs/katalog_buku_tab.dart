import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../models/book_model.dart';
import '../../../services/book_service.dart';
import '../../../services/member_service.dart';
import '../../../services/transaction_service.dart';
import '../../../widgets/receipt_dialog.dart';

class KatalogBukuTab extends StatefulWidget {
  final UserModel currentUser;
  final ValueChanged<int> onNavigateTab;
  final VoidCallback onDataChanged;

  const KatalogBukuTab({
    super.key,
    required this.currentUser,
    required this.onNavigateTab,
    required this.onDataChanged,
  });

  @override
  State<KatalogBukuTab> createState() => _KatalogBukuTabState();
}

class _KatalogBukuTabState extends State<KatalogBukuTab> {
  final _bookService = BookService();
  final _memberService = MemberService();
  final _transactionService = TransactionService();

  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _onlyAvailable = false;

  void _openBookDetail(BookModel book) {
    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '');
    final isAvailable = book.availableStock > 0;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 650),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cover & Basic Info Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                book.cover,
                                width: 100,
                                height: 145,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 145,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.menu_book_rounded, size: 36, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Penulis: ${book.author}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    'Penerbit: ${book.publisher} (${book.year})',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ISBN: ${book.isbn}',
                                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (isAvailable ? Colors.green : Colors.red).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isAvailable
                                          ? 'Tersedia: ${book.availableStock} dari ${book.stock} eks'
                                          : 'Stok Habis Dipinjam',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isAvailable ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Shelf Location
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shelves, color: Colors.amber, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('LOKASI RAK PERPUSTAKAAN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    Text(book.shelf, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Sinopsis / Deskripsi
                        const Text('Sinopsis & Deskripsi Buku', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(
                          book.description,
                          style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.grey),
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
                        child: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.bookmark_add_rounded, size: 18),
                        label: const Text('Ajukan Pinjam'),
                        onPressed: !isAvailable
                            ? null
                            : () async {
                                if (member == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profil anggota Anda tidak ditemukan!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  final newTx = await _transactionService.borrowBook(
                                    memberId: member.id,
                                    bookId: book.id,
                                    notes: 'Pengajuan mandiri oleh siswa via portal digital',
                                  );

                                  if (ctx.mounted) {
                                    Navigator.of(ctx).pop();
                                  }

                                  setState(() {});
                                  widget.onDataChanged();

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Peminjaman "${book.title}" berhasil diajukan! Batas: ${newTx.dueDate}'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = _bookService.getAllBooks();
    final categories = _bookService.getCategories();

    final filtered = books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.isbn.contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'Semua' || book.category == _selectedCategory;
      final matchesStock = !_onlyAvailable || book.availableStock > 0;
      return matchesSearch && matchesCategory && matchesStock;
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
                        child: const Icon(Icons.local_library_rounded, color: Color(0xFF4F46E5), size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Katalog Koleksi Buku',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Telusuri dan ajukan peminjaman buku fisik perpustakaan sekolah secara mandiri',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Search Box
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari judul buku, penulis, atau nomor ISBN...',
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Categories Horizontal List & Stock Toggle
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF4F46E5),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : null,
                          ),
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilterChip(
                avatar: Icon(
                  _onlyAvailable ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  size: 16,
                  color: _onlyAvailable ? Colors.white : Colors.grey,
                ),
                label: const Text('Hanya Tersedia', style: TextStyle(fontSize: 11)),
                selected: _onlyAvailable,
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _onlyAvailable ? Colors.white : null,
                ),
                onSelected: (val) => setState(() => _onlyAvailable = val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Book Grid
          if (filtered.isEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Tidak ada buku yang cocok dengan pencarian Anda',
                      style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final b = filtered[index];
                return _buildGridBookCard(b);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGridBookCard(BookModel book) {
    final isAvailable = book.availableStock > 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openBookDetail(book),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with Badge Overlay
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    book.cover,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.menu_book_rounded, size: 36, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isAvailable ? Colors.green : Colors.red).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAvailable ? 'Sisa ${book.availableStock}' : 'Habis',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAvailable ? const Color(0xFF4F46E5) : Colors.grey,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(32),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _openBookDetail(book),
                      child: Text(
                        isAvailable ? 'Pinjam Buku' : 'Lihat Detail',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
