import 'package:flutter/material.dart';
import '../../../models/book_model.dart';
import '../../../services/book_service.dart';
import '../../../widgets/confirm_dialog.dart';

class KelolaBukuTab extends StatefulWidget {
  final VoidCallback onDataChanged;

  const KelolaBukuTab({super.key, required this.onDataChanged});

  @override
  State<KelolaBukuTab> createState() => _KelolaBukuTabState();
}

class _KelolaBukuTabState extends State<KelolaBukuTab> {
  final _bookService = BookService();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _isGridView = false;

  void _refresh() {
    setState(() {});
    widget.onDataChanged();
  }

  void _openAddEditDialog({BookModel? book}) {
    final isEdit = book != null;
    final isbnController = TextEditingController(text: book?.isbn ?? '');
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final publisherController = TextEditingController(text: book?.publisher ?? '');
    final yearController = TextEditingController(text: (book?.year ?? DateTime.now().year).toString());
    final stockController = TextEditingController(text: (book?.stock ?? 5).toString());
    final shelfController = TextEditingController(text: book?.shelf ?? 'Rak A-01 (Komputer)');
    final descController = TextEditingController(text: book?.description ?? '');
    final coverController = TextEditingController(text: book?.cover ?? '');

    String selectedCategory = book?.category ?? 'Teknologi & RPL';
    final categories = ['Teknologi & RPL', 'Fiksi & Novel', 'Sains', 'Pengembangan Diri', 'Umum'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 680),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Data Buku' : 'Tambah Buku Baru',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: isbnController,
                            decoration: const InputDecoration(
                              labelText: 'Nomor ISBN *',
                              hintText: '978-623-...',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Judul Lengkap Buku *',
                              hintText: 'Judul buku...',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: authorController,
                                  decoration: const InputDecoration(
                                    labelText: 'Pengarang / Penulis *',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: publisherController,
                                  decoration: const InputDecoration(
                                    labelText: 'Penerbit *',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: yearController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Tahun Terbit',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: stockController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Jumlah Stok *',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: const InputDecoration(labelText: 'Kategori Buku'),
                            items: categories.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => selectedCategory = val);
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: shelfController,
                            decoration: const InputDecoration(
                              labelText: 'Lokasi Rak Penyimpanan',
                              hintText: 'Rak A-01 (Komputer)',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: coverController,
                            decoration: const InputDecoration(
                              labelText: 'URL Gambar Sampul (Opsional)',
                              hintText: 'https://...',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: descController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Sinopsis / Deskripsi Buku',
                              hintText: 'Ringkasan cerita atau materi buku...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final isbn = isbnController.text.trim();
                          final title = titleController.text.trim();
                          final author = authorController.text.trim();
                          final publisher = publisherController.text.trim();
                          final stock = int.tryParse(stockController.text.trim()) ?? 1;
                          final year = int.tryParse(yearController.text.trim()) ?? DateTime.now().year;

                          if (isbn.isEmpty || title.isEmpty || author.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ISBN, Judul, dan Pengarang wajib diisi!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            if (isEdit) {
                              final updated = book.copyWith(
                                isbn: isbn,
                                title: title,
                                author: author,
                                publisher: publisher,
                                year: year,
                                stock: stock,
                                category: selectedCategory,
                                shelf: shelfController.text.trim(),
                                description: descController.text.trim(),
                                cover: coverController.text.trim(),
                              );
                              await _bookService.updateBook(book.id, updated);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Buku "${updated.title}" berhasil diperbarui!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } else {
                              final newBook = BookModel(
                                id: '',
                                isbn: isbn,
                                title: title,
                                author: author,
                                publisher: publisher,
                                year: year,
                                stock: stock,
                                availableStock: stock,
                                category: selectedCategory,
                                shelf: shelfController.text.trim().isNotEmpty ? shelfController.text.trim() : 'Rak A-01',
                                description: descController.text.trim(),
                                cover: coverController.text.trim().isNotEmpty
                                    ? coverController.text.trim()
                                    : 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
                              );
                              await _bookService.createBook(newBook);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Buku baru "${newBook.title}" berhasil ditambahkan!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                            if (ctx.mounted) Navigator.of(ctx).pop();
                            _refresh();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Buku'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetailDialog(BookModel book) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Detail Informasi Buku', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: book.cover.isNotEmpty
                        ? Image.network(
                            book.cover,
                            height: 140,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 140,
                              width: 100,
                              color: const Color(0xFF4F46E5).withOpacity(0.1),
                              child: const Icon(Icons.book, size: 40, color: Color(0xFF4F46E5)),
                            ),
                          )
                        : Container(
                            height: 140,
                            width: 100,
                            color: const Color(0xFF4F46E5).withOpacity(0.1),
                            child: const Icon(Icons.book, size: 40, color: Color(0xFF4F46E5)),
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  book.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${book.author} • ${book.publisher} (${book.year})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 10),
                _detailRow('ISBN', book.isbn),
                _detailRow('Kategori', book.category),
                _detailRow('Lokasi Rak', book.shelf),
                _detailRow('Total Stok', '${book.stock} Eksemplar'),
                _detailRow('Stok Tersedia', '${book.availableStock} Eksemplar', isAvailable: book.availableStock > 0),
                _detailRow('Total Dipinjam', '${book.borrowedCount} Kali'),
                const SizedBox(height: 8),
                const Text('Sinopsis:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  book.description.isNotEmpty ? book.description : 'Tidak ada sinopsis buku.',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool? isAvailable}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isAvailable != null ? (isAvailable ? Colors.green : Colors.red) : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteBook(BookModel book) async {
    if (book.availableStock < book.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buku sedang dalam status dipinjam oleh anggota dan tidak dapat dihapus!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Hapus Data Buku',
      message: 'Apakah Anda yakin ingin menghapus buku "${book.title}" (ISBN: ${book.isbn}) dari katalog perpustakaan?',
      confirmText: 'Ya, Hapus Buku',
      isDanger: true,
    );

    if (confirmed == true) {
      try {
        await _bookService.deleteBook(book.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Buku "${book.title}" berhasil dihapus!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allBooks = _bookService.getAllBooks();
    final categories = _bookService.getCategories();

    final filteredBooks = allBooks.where((b) {
      final matchesSearch = b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.isbn.contains(_searchQuery);
      final matchesCat = _selectedCategory == 'Semua' || b.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Column(
      children: [
        // Top Action Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelola Data Buku',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Katalog buku fisik dan kontrol stok',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _openAddEditDialog(),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tambah Buku', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar & View Toggle
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari judul, pengarang, ISBN...',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
                    icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Categories Horizontal Scroll
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (ctx, index) {
                    final cat = categories[index];
                    final isSelected = cat == _selectedCategory;
                    return ChoiceChip(
                      label: Text(cat, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Book List / Grid
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada buku yang sesuai dengan pencarian.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              : _isGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (ctx, index) => _buildGridCard(filteredBooks[index]),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredBooks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, index) => _buildListCard(filteredBooks[index]),
                    ),
        ),
      ],
    );
  }

  Widget _buildListCard(BookModel book) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: book.cover.isNotEmpty
                  ? Image.network(
                      book.cover,
                      width: 55,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 55,
                        height: 75,
                        color: const Color(0xFF4F46E5).withOpacity(0.1),
                        child: const Icon(Icons.book, size: 28, color: Color(0xFF4F46E5)),
                      ),
                    )
                  : Container(
                      width: 55,
                      height: 75,
                      color: const Color(0xFF4F46E5).withOpacity(0.1),
                      child: const Icon(Icons.book, size: 28, color: Color(0xFF4F46E5)),
                    ),
            ),
            const SizedBox(width: 12),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${book.author} • ${book.publisher} (${book.year})',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.category,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.shelf,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Stok: ${book.availableStock} / ${book.stock} Tersedia',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: book.availableStock > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  tooltip: 'Lihat Detail',
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  onPressed: () => _openDetailDialog(book),
                ),
                IconButton(
                  tooltip: 'Edit Buku',
                  icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF4F46E5)),
                  onPressed: () => _openAddEditDialog(book: book),
                ),
                IconButton(
                  tooltip: 'Hapus Buku',
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  onPressed: () => _handleDeleteBook(book),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(BookModel book) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: book.cover.isNotEmpty
                      ? Image.network(
                          book.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF4F46E5).withOpacity(0.1),
                            child: const Center(child: Icon(Icons.book, size: 36, color: Color(0xFF4F46E5))),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF4F46E5).withOpacity(0.1),
                          child: const Center(child: Icon(Icons.book, size: 36, color: Color(0xFF4F46E5))),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              book.author,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stok: ${book.availableStock}/${book.stock}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: book.availableStock > 0 ? Colors.green : Colors.red,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _openDetailDialog(book),
                      child: const Icon(Icons.visibility_outlined, size: 16),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _openAddEditDialog(book: book),
                      child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _handleDeleteBook(book),
                      child: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
