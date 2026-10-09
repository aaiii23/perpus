import React, { useState } from 'react';
import {
  Search,
  BookOpen,
  Bookmark,
  CheckCircle2,
  XCircle,
  PlusCircle,
  Layers,
  Sparkles,
  Info
} from 'lucide-react';
import { bookService } from '../../services/bookService';
import { memberService } from '../../services/memberService';
import { transactionService } from '../../services/transactionService';
import { Modal } from '../../components/Modal';

export const KatalogBuku = ({ currentUser, showToast, onLoanSuccess }) => {
  const [books, setBooks] = useState(bookService.getAllBooks());
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Semua');
  const [onlyAvailable, setOnlyAvailable] = useState(false);

  // Detail Modal State
  const [selectedBook, setSelectedBook] = useState(null);

  const categories = bookService.getCategories();
  const member = memberService.getMemberByNisn(currentUser?.nisn || '');

  const filteredBooks = books.filter((book) => {
    const matchesSearch =
      book.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      book.author.toLowerCase().includes(searchQuery.toLowerCase()) ||
      book.isbn.includes(searchQuery);
    const matchesCategory = selectedCategory === 'Semua' || book.category === selectedCategory;
    const matchesAvailable = !onlyAvailable || book.availableStock > 0;
    return matchesSearch && matchesCategory && matchesAvailable;
  });

  const handleBorrowRequest = (book) => {
    if (!member) {
      showToast({ type: 'error', message: 'Data profil keanggotaan Anda tidak ditemukan!' });
      return;
    }

    try {
      const newTx = transactionService.borrowBook({
        memberId: member.id,
        bookId: book.id,
        notes: 'Pengajuan mandiri oleh siswa via portal digital'
      });

      showToast({
        type: 'success',
        message: `Berhasil mengajukan peminjaman buku "${book.title}"! Jatuh tempo: ${newTx.dueDate}`
      });

      setBooks(bookService.getAllBooks());
      setSelectedBook(null);

      if (onLoanSuccess) {
        onLoanSuccess(newTx);
      }
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Katalog Buku Perpustakaan
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Jelajahi dan ajukan peminjaman koleksi buku fisik perpustakaan sekolah
          </p>
        </div>

        {/* Search */}
        <div className="relative md:w-80">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Cari judul, pengarang, ISBN..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 text-slate-900 dark:text-white"
          />
        </div>
      </div>

      {/* Category Pills & Availability Filter */}
      <div className="flex flex-wrap items-center justify-between gap-3">
        {/* Category Pills */}
        <div className="flex flex-wrap items-center gap-2">
          {categories.map((cat) => (
            <button
              key={cat}
              type="button"
              onClick={() => setSelectedCategory(cat)}
              className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold transition ${
                selectedCategory === cat
                  ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20'
                  : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-800 hover:bg-slate-50'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        {/* Availability Toggle */}
        <label className="inline-flex items-center gap-2 text-xs font-semibold text-slate-600 dark:text-slate-300 cursor-pointer select-none">
          <input
            type="checkbox"
            checked={onlyAvailable}
            onChange={(e) => setOnlyAvailable(e.target.checked)}
            className="w-4 h-4 text-indigo-600 rounded border-slate-300 focus:ring-indigo-500"
          />
          Hanya tampilkan buku yang siap dipinjam
        </label>
      </div>

      {/* Books Catalog Grid */}
      {filteredBooks.length === 0 ? (
        <div className="p-12 text-center bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800">
          <Layers className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <h4 className="text-base font-bold text-slate-700 dark:text-slate-200">Tidak ada buku ditemukan</h4>
          <p className="text-xs text-slate-400 mt-1">Coba sesuaikan kata kunci pencarian atau kategori.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {filteredBooks.map((book) => {
            const isAvailable = book.availableStock > 0;
            return (
              <div
                key={book.id}
                className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200/80 dark:border-slate-800 overflow-hidden shadow-sm hover:shadow-xl transition card-hover-effect flex flex-col"
              >
                {/* Book Cover Image */}
                <div
                  className="relative h-52 overflow-hidden bg-slate-100 dark:bg-slate-800 cursor-pointer"
                  onClick={() => setSelectedBook(book)}
                >
                  <img
                    src={book.cover}
                    alt={book.title}
                    className="w-full h-full object-cover object-center group-hover:scale-105 transition duration-300"
                  />
                  <div className="absolute top-3 left-3">
                    <span className="px-2.5 py-1 rounded-full text-[10px] font-extrabold uppercase tracking-wider bg-slate-900/80 backdrop-blur-md text-white">
                      {book.category}
                    </span>
                  </div>
                  <div className="absolute top-3 right-3">
                    <span
                      className={`px-2.5 py-1 rounded-full text-xs font-bold shadow-md ${
                        isAvailable ? 'bg-emerald-500 text-white' : 'bg-rose-500 text-white'
                      }`}
                    >
                      {isAvailable ? `${book.availableStock} Tersedia` : 'Stok Habis'}
                    </span>
                  </div>
                </div>

                {/* Body Content */}
                <div className="p-4 flex-1 flex flex-col justify-between">
                  <div>
                    <h3
                      onClick={() => setSelectedBook(book)}
                      className="font-bold text-slate-900 dark:text-white text-sm line-clamp-2 hover:text-indigo-600 cursor-pointer transition"
                    >
                      {book.title}
                    </h3>
                    <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
                      {book.author} ({book.year})
                    </p>
                    <div className="mt-2 flex items-center gap-1.5 text-xs text-slate-600 dark:text-slate-400">
                      <Bookmark className="w-3.5 h-3.5 text-indigo-500" />
                      <span className="truncate">{book.shelf}</span>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between gap-2">
                    <button
                      type="button"
                      onClick={() => setSelectedBook(book)}
                      className="text-xs font-semibold text-slate-500 hover:text-slate-800 dark:hover:text-slate-200"
                    >
                      Detail
                    </button>
                    <button
                      type="button"
                      disabled={!isAvailable}
                      onClick={() => handleBorrowRequest(book)}
                      className={`inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-xs font-bold transition shadow-sm ${
                        isAvailable
                          ? 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-indigo-600/20'
                          : 'bg-slate-100 dark:bg-slate-800 text-slate-400 cursor-not-allowed'
                      }`}
                    >
                      <PlusCircle className="w-3.5 h-3.5" />
                      {isAvailable ? 'Ajukan Pinjam' : 'Habis'}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Book Detail & Direct Borrow Modal */}
      {selectedBook && (
        <Modal
          isOpen={!!selectedBook}
          onClose={() => setSelectedBook(null)}
          title="Detail Informasi Buku"
          maxWidth="max-w-xl"
        >
          <div className="flex flex-col sm:flex-row gap-6">
            <img
              src={selectedBook.cover}
              alt={selectedBook.title}
              className="w-40 h-56 object-cover rounded-2xl shadow-lg border border-slate-200 dark:border-slate-700 self-center sm:self-start"
            />
            <div className="space-y-3 flex-1 text-xs sm:text-sm">
              <div>
                <span className="px-2.5 py-0.5 bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300 rounded-full font-bold text-[10px]">
                  {selectedBook.category}
                </span>
                <h3 className="text-base font-black text-slate-900 dark:text-white mt-1">
                  {selectedBook.title}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Penulis: <span className="font-semibold text-slate-800 dark:text-slate-200">{selectedBook.author}</span> ({selectedBook.year})
                </p>
              </div>

              <div className="p-3 bg-slate-50 dark:bg-slate-800/60 rounded-xl space-y-1.5 border border-slate-100 dark:border-slate-800 text-xs">
                <div className="flex justify-between">
                  <span className="text-slate-400">Penerbit:</span>
                  <span className="font-medium text-slate-800 dark:text-slate-200">{selectedBook.publisher}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">ISBN:</span>
                  <span className="font-mono text-slate-800 dark:text-slate-200">{selectedBook.isbn}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Lokasi Rak Fisik:</span>
                  <span className="font-bold text-indigo-600 dark:text-indigo-400">{selectedBook.shelf}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Ketersediaan:</span>
                  <span className={`font-bold ${selectedBook.availableStock > 0 ? 'text-emerald-600' : 'text-rose-600'}`}>
                    {selectedBook.availableStock} dari {selectedBook.stock} Eksemplar
                  </span>
                </div>
              </div>

              <div>
                <h5 className="font-bold text-slate-900 dark:text-white text-xs mb-1">Sinopsis Buku:</h5>
                <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed max-h-28 overflow-y-auto">
                  {selectedBook.description}
                </p>
              </div>

              <div className="pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setSelectedBook(null)}
                  className="px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
                >
                  Tutup
                </button>
                <button
                  type="button"
                  disabled={selectedBook.availableStock <= 0}
                  onClick={() => handleBorrowRequest(selectedBook)}
                  className={`px-5 py-2.5 rounded-xl text-xs font-bold transition shadow-md ${
                    selectedBook.availableStock > 0
                      ? 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-indigo-600/20'
                      : 'bg-slate-100 text-slate-400 cursor-not-allowed'
                  }`}
                >
                  {selectedBook.availableStock > 0 ? 'Ajukan Pinjam Sekarang' : 'Stok Buku Habis'}
                </button>
              </div>
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};
