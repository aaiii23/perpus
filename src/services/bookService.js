import { STORAGE_KEYS, getStorageData, setStorageData, logActivity } from './storage';
import { authService } from './authService';

export const bookService = {
  getAllBooks: () => {
    return getStorageData(STORAGE_KEYS.BOOKS) || [];
  },

  getBookById: (id) => {
    const books = bookService.getAllBooks();
    return books.find((b) => b.id === id) || null;
  },

  createBook: (bookData) => {
    const books = bookService.getAllBooks();
    
    // Check duplicate ISBN
    if (books.some((b) => b.isbn.trim() === bookData.isbn.trim())) {
      throw new Error(`Buku dengan ISBN ${bookData.isbn} sudah ada dalam katalog!`);
    }

    const newId = `BK-${String(books.length + 1).padStart(3, '0')}`;
    const totalStock = parseInt(bookData.stock, 10) || 1;

    const newBook = {
      id: newId,
      isbn: bookData.isbn.trim(),
      title: bookData.title.trim(),
      author: bookData.author.trim(),
      publisher: bookData.publisher.trim(),
      year: parseInt(bookData.year, 10) || new Date().getFullYear(),
      category: bookData.category || 'Umum',
      shelf: bookData.shelf || 'Rak A-01',
      stock: totalStock,
      availableStock: totalStock,
      borrowedCount: 0,
      description: bookData.description || 'Tidak ada deskripsi sinopsis buku.',
      cover: bookData.cover || 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&auto=format&fit=crop&q=80'
    };

    const updated = [newBook, ...books];
    setStorageData(STORAGE_KEYS.BOOKS, updated);
    logActivity(authService.getCurrentUser(), 'CREATE_BOOK', `Menambahkan buku baru: "${newBook.title}" (ISBN: ${newBook.isbn})`);
    return newBook;
  },

  updateBook: (id, bookData) => {
    const books = bookService.getAllBooks();
    const index = books.findIndex((b) => b.id === id);
    if (index === -1) {
      throw new Error('Buku tidak ditemukan!');
    }

    const currentBook = books[index];
    const totalStock = parseInt(bookData.stock, 10) || currentBook.stock;
    const diffStock = totalStock - currentBook.stock;
    const newAvailable = Math.max(0, currentBook.availableStock + diffStock);

    const updatedBook = {
      ...currentBook,
      ...bookData,
      id: currentBook.id,
      stock: totalStock,
      availableStock: newAvailable
    };

    books[index] = updatedBook;
    setStorageData(STORAGE_KEYS.BOOKS, books);
    logActivity(authService.getCurrentUser(), 'UPDATE_BOOK', `Memperbarui data buku: "${updatedBook.title}"`);
    return updatedBook;
  },

  deleteBook: (id) => {
    const books = bookService.getAllBooks();
    const targetBook = books.find((b) => b.id === id);
    if (!targetBook) {
      throw new Error('Buku tidak ditemukan!');
    }

    // Check if book is currently borrowed
    if (targetBook.availableStock < targetBook.stock) {
      throw new Error('Buku sedang dalam status dipinjam oleh anggota dan tidak dapat dihapus!');
    }

    const filtered = books.filter((b) => b.id !== id);
    setStorageData(STORAGE_KEYS.BOOKS, filtered);
    logActivity(authService.getCurrentUser(), 'DELETE_BOOK', `Menghapus buku: "${targetBook.title}"`);
    return true;
  },

  getCategories: () => {
    const books = bookService.getAllBooks();
    const categories = ['Semua', ...new Set(books.map((b) => b.category))];
    return categories;
  },

  getShelves: () => {
    const books = bookService.getAllBooks();
    const shelves = ['Semua', ...new Set(books.map((b) => b.shelf))];
    return shelves;
  }
};
