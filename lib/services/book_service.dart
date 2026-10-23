import '../models/book_model.dart';
import 'storage_service.dart';

class BookService {
  final StorageService _storage = StorageService();

  List<BookModel> getAllBooks() {
    return _storage.getBooks();
  }

  BookModel? getBookById(String id) {
    return _storage.getBooks().cast<BookModel?>().firstWhere(
      (b) => b?.id == id,
      orElse: () => null,
    );
  }

  Future<BookModel> createBook(BookModel bookData) async {
    final books = _storage.getBooks();

    // Check duplicate ISBN
    if (books.any((b) => b.isbn.trim() == bookData.isbn.trim())) {
      throw Exception('Buku dengan ISBN ${bookData.isbn} sudah ada dalam katalog!');
    }

    final newId = 'BK-${(books.length + 1).toString().padLeft(3, '0')}';
    final totalStock = bookData.stock > 0 ? bookData.stock : 1;

    final newBook = bookData.copyWith(
      id: newId,
      stock: totalStock,
      availableStock: totalStock,
      borrowedCount: 0,
    );

    final updated = [newBook, ...books];
    await _storage.setBooks(updated);
    await _storage.logActivity(
      'CREATE_BOOK',
      'Menambahkan buku baru: "${newBook.title}" (ISBN: ${newBook.isbn})',
    );

    return newBook;
  }

  Future<BookModel> updateBook(String id, BookModel updatedData) async {
    final books = List<BookModel>.from(_storage.getBooks());
    final index = books.indexWhere((b) => b.id == id);
    if (index == -1) {
      throw Exception('Buku tidak ditemukan!');
    }

    final currentBook = books[index];
    final totalStock = updatedData.stock > 0 ? updatedData.stock : currentBook.stock;
    final diffStock = totalStock - currentBook.stock;
    final newAvailable = (currentBook.availableStock + diffStock).clamp(0, totalStock);

    final updatedBook = updatedData.copyWith(
      id: currentBook.id,
      stock: totalStock,
      availableStock: newAvailable,
    );

    books[index] = updatedBook;
    await _storage.setBooks(books);
    await _storage.logActivity(
      'UPDATE_BOOK',
      'Memperbarui data buku: "${updatedBook.title}"',
    );

    return updatedBook;
  }

  Future<bool> deleteBook(String id) async {
    final books = List<BookModel>.from(_storage.getBooks());
    final target = books.cast<BookModel?>().firstWhere(
      (b) => b?.id == id,
      orElse: () => null,
    );

    if (target == null) {
      throw Exception('Buku tidak ditemukan!');
    }

    // Check if book is currently borrowed
    if (target.availableStock < target.stock) {
      throw Exception(
        'Buku sedang dalam status dipinjam oleh anggota dan tidak dapat dihapus!',
      );
    }

    books.removeWhere((b) => b.id == id);
    await _storage.setBooks(books);
    await _storage.logActivity(
      'DELETE_BOOK',
      'Menghapus buku: "${target.title}"',
    );

    return true;
  }

  List<String> getCategories() {
    final books = _storage.getBooks();
    final setCats = {'Semua', ...books.map((b) => b.category)};
    return setCats.toList();
  }

  List<String> getShelves() {
    final books = _storage.getBooks();
    final setShelves = {'Semua', ...books.map((b) => b.shelf)};
    return setShelves.toList();
  }
}
