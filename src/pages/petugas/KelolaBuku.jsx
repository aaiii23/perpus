import React, { useState } from 'react';
import {
  BookPlus,
  Search,
  Filter,
  Edit2,
  Trash2,
  Eye,
  Layers,
  CheckCircle2,
  Bookmark,
  Sparkles,
  LayoutGrid,
  Table as TableIcon
} from 'lucide-react';
import { bookService } from '../../services/bookService';
import { Modal } from '../../components/Modal';
import { ConfirmDialog } from '../../components/ConfirmDialog';

export const KelolaBuku = ({ showToast }) => {
  const [books, setBooks] = useState(bookService.getAllBooks());
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Semua');
  const [selectedShelf, setSelectedShelf] = useState('Semua');
  const [viewMode, setViewMode] = useState('table'); // 'table' | 'grid'

  // Modal States
  const [isAddEditOpen, setIsAddEditOpen] = useState(false);
  const [editingBook, setEditingBook] = useState(null);
  const [viewingBook, setViewingBook] = useState(null);
  const [deleteTargetId, setDeleteTargetId] = useState(null);

  // Form State
  const initialForm = {
    isbn: '',
    title: '',
    author: '',
    publisher: '',
    year: new Date().getFullYear(),
    category: 'Teknologi & RPL',
    shelf: 'Rak A-01 (Komputer)',
    stock: 5,
    description: '',
    cover: ''
  };
  const [formData, setFormData] = useState(initialForm);

  const categories = bookService.getCategories();
  const shelves = bookService.getShelves();

  const refreshBooks = () => {
    setBooks(bookService.getAllBooks());
  };

  const filteredBooks = books.filter((book) => {
    const matchesSearch =
      book.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      book.author.toLowerCase().includes(searchQuery.toLowerCase()) ||
      book.isbn.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'Semua' || book.category === selectedCategory;
    const matchesShelf = selectedShelf === 'Semua' || book.shelf === selectedShelf;
    return matchesSearch && matchesCategory && matchesShelf;
  });

  const handleOpenAdd = () => {
    setEditingBook(null);
    setFormData(initialForm);
    setIsAddEditOpen(true);
  };

  const handleOpenEdit = (book) => {
    setEditingBook(book);
    setFormData({
      isbn: book.isbn,
      title: book.title,
      author: book.author,
      publisher: book.publisher,
      year: book.year,
      category: book.category,
      shelf: book.shelf,
      stock: book.stock,
      description: book.description,
      cover: book.cover
    });
    setIsAddEditOpen(true);
  };

  const handleFormSubmit = (e) => {
    e.preventDefault();
    try {
      if (editingBook) {
        bookService.updateBook(editingBook.id, formData);
        showToast({ type: 'success', message: `Buku "${formData.title}" berhasil diperbarui!` });
      } else {
        bookService.createBook(formData);
        showToast({ type: 'success', message: `Buku baru "${formData.title}" berhasil ditambahkan!` });
      }
      setIsAddEditOpen(false);
      refreshBooks();
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  const handleDeleteConfirm = () => {
    if (!deleteTargetId) return;
    try {
      bookService.deleteBook(deleteTargetId);
      showToast({ type: 'success', message: 'Data buku berhasil dihapus dari katalog!' });
      refreshBooks();
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    } finally {
      setDeleteTargetId(null);
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header & Action */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Kelola Data Buku & Katalog
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Manajemen CRUD data koleksi buku perpustakaan (Judul, Pengarang, Penerbit, Kategori, Stok, Rak)
          </p>
        </div>
        <button
          type="button"
          onClick={handleOpenAdd}
          className="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs sm:text-sm rounded-xl shadow-md shadow-indigo-600/20 transition"
        >
          <BookPlus className="w-4 h-4" /> Tambah Buku Baru
        </button>
      </div>

      {/* Filter & Search Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3">
        {/* Search */}
        <div className="relative flex-1">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Cari judul buku, pengarang, atau ISBN..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 text-slate-900 dark:text-white"
          />
        </div>

        {/* Filter Category & Shelf */}
        <div className="flex flex-wrap items-center gap-2">
          <select
            value={selectedCategory}
            onChange={(e) => setSelectedCategory(e.target.value)}
            className="px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-medium text-slate-700 dark:text-slate-300 focus:outline-none"
          >
            {categories.map((cat) => (
              <option key={cat} value={cat}>
                Kategori: {cat}
              </option>
            ))}
          </select>

          <select
            value={selectedShelf}
            onChange={(e) => setSelectedShelf(e.target.value)}
            className="px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-medium text-slate-700 dark:text-slate-300 focus:outline-none"
          >
            {shelves.map((sh) => (
              <option key={sh} value={sh}>
                Rak: {sh}
              </option>
            ))}
          </select>

          {/* View Mode Toggle */}
          <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-xl border border-slate-200 dark:border-slate-700">
            <button
              type="button"
              onClick={() => setViewMode('table')}
              className={`p-1.5 rounded-lg transition ${
                viewMode === 'table' ? 'bg-white dark:bg-slate-700 text-indigo-600 shadow-sm' : 'text-slate-400'
              }`}
              title="Tampilan Tabel"
            >
              <TableIcon className="w-4 h-4" />
            </button>
            <button
              type="button"
              onClick={() => setViewMode('grid')}
              className={`p-1.5 rounded-lg transition ${
                viewMode === 'grid' ? 'bg-white dark:bg-slate-700 text-indigo-600 shadow-sm' : 'text-slate-400'
              }`}
              title="Tampilan Grid Kartu"
            >
              <LayoutGrid className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Book List Content */}
      {filteredBooks.length === 0 ? (
        <div className="p-12 text-center bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800">
          <Layers className="w-12 h-12 text-slate-300 mx-auto mb-3" />
          <h4 className="text-base font-bold text-slate-700 dark:text-slate-200">Tidak ada buku ditemukan</h4>
          <p className="text-xs text-slate-400 mt-1">Coba sesuaikan kata kunci pencarian atau filter Anda.</p>
        </div>
      ) : viewMode === 'table' ? (
        /* Table View */
        <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs sm:text-sm">
              <thead className="bg-slate-50 dark:bg-slate-800/60 border-b border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3.5 px-4 font-semibold">Buku & ISBN</th>
                  <th className="py-3.5 px-4 font-semibold">Pengarang / Penerbit</th>
                  <th className="py-3.5 px-4 font-semibold">Kategori & Rak</th>
                  <th className="py-3.5 px-4 font-semibold text-center">Stok</th>
                  <th className="py-3.5 px-4 font-semibold text-right">Aksi</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/60">
                {filteredBooks.map((book) => (
                  <tr key={book.id} className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition">
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-3">
                        <img
                          src={book.cover}
                          alt={book.title}
                          className="w-10 h-14 object-cover rounded-md shadow-sm flex-shrink-0"
                        />
                        <div>
                          <div className="font-bold text-slate-900 dark:text-white line-clamp-1">{book.title}</div>
                          <div className="font-mono text-[11px] text-slate-400">ISBN: {book.isbn}</div>
                          <div className="text-[10px] text-indigo-600 dark:text-indigo-400 font-semibold">
                            Tahun: {book.year}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-medium text-slate-800 dark:text-slate-200">{book.author}</div>
                      <div className="text-slate-400 text-xs">{book.publisher}</div>
                    </td>
                    <td className="py-3 px-4">
                      <span className="inline-block px-2.5 py-0.5 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-700 dark:text-indigo-300 rounded-full text-[11px] font-semibold mb-1">
                        {book.category}
                      </span>
                      <div className="text-xs text-slate-500 dark:text-slate-400">{book.shelf}</div>
                    </td>
                    <td className="py-3 px-4 text-center">
                      <div className="font-bold text-slate-900 dark:text-white">
                        <span
                          className={`px-2 py-0.5 rounded-lg text-xs ${
                            book.availableStock > 0
                              ? 'bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300'
                              : 'bg-rose-50 text-rose-700 dark:bg-rose-950 dark:text-rose-300'
                          }`}
                        >
                          {book.availableStock} / {book.stock}
                        </span>
                      </div>
                      <div className="text-[10px] text-slate-400 mt-0.5">
                        {book.availableStock > 0 ? 'Tersedia' : 'Habis'}
                      </div>
                    </td>
                    <td className="py-3 px-4 text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        <button
                          type="button"
                          onClick={() => setViewingBook(book)}
                          className="p-1.5 text-slate-500 hover:text-indigo-600 hover:bg-indigo-50 dark:hover:bg-slate-800 rounded-lg transition"
                          title="Lihat Detail"
                        >
                          <Eye className="w-4 h-4" />
                        </button>
                        <button
                          type="button"
                          onClick={() => handleOpenEdit(book)}
                          className="p-1.5 text-slate-500 hover:text-amber-600 hover:bg-amber-50 dark:hover:bg-slate-800 rounded-lg transition"
                          title="Edit Buku"
                        >
                          <Edit2 className="w-4 h-4" />
                        </button>
                        <button
                          type="button"
                          onClick={() => setDeleteTargetId(book.id)}
                          className="p-1.5 text-slate-500 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-slate-800 rounded-lg transition"
                          title="Hapus Buku"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      ) : (
        /* Grid View */
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {filteredBooks.map((book) => (
            <div
              key={book.id}
              className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 overflow-hidden shadow-sm hover:shadow-md transition card-hover-effect flex flex-col"
            >
              <div className="relative h-48 overflow-hidden bg-slate-100 dark:bg-slate-800">
                <img
                  src={book.cover}
                  alt={book.title}
                  className="w-full h-full object-cover object-center"
                />
                <div className="absolute top-3 right-3">
                  <span
                    className={`px-2.5 py-1 rounded-full text-xs font-bold shadow-md ${
                      book.availableStock > 0
                        ? 'bg-emerald-500 text-white'
                        : 'bg-rose-500 text-white'
                    }`}
                  >
                    Stok: {book.availableStock}
                  </span>
                </div>
              </div>

              <div className="p-4 flex-1 flex flex-col">
                <span className="text-[10px] font-bold text-indigo-600 dark:text-indigo-400 uppercase tracking-wider">
                  {book.category}
                </span>
                <h3 className="font-bold text-slate-900 dark:text-white text-sm line-clamp-2 mt-1">
                  {book.title}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">{book.author} ({book.year})</p>
                <div className="mt-2 text-xs text-slate-600 dark:text-slate-400 flex items-center gap-1">
                  <Bookmark className="w-3.5 h-3.5 text-slate-400" />
                  <span className="truncate">{book.shelf}</span>
                </div>

                <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                  <span className="font-mono text-[11px] text-slate-400">{book.isbn}</span>
                  <div className="flex items-center gap-1">
                    <button
                      type="button"
                      onClick={() => setViewingBook(book)}
                      className="p-1.5 text-slate-400 hover:text-indigo-600 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                    >
                      <Eye className="w-3.5 h-3.5" />
                    </button>
                    <button
                      type="button"
                      onClick={() => handleOpenEdit(book)}
                      className="p-1.5 text-slate-400 hover:text-amber-600 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                    >
                      <Edit2 className="w-3.5 h-3.5" />
                    </button>
                    <button
                      type="button"
                      onClick={() => setDeleteTargetId(book.id)}
                      className="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Add / Edit Book Modal */}
      <Modal
        isOpen={isAddEditOpen}
        onClose={() => setIsAddEditOpen(false)}
        title={editingBook ? 'Edit Data Buku' : 'Tambah Buku Baru ke Katalog'}
        subtitle="Lengkapi informasi spesifikasi buku perpustakaan"
      >
        <form onSubmit={handleFormSubmit} className="space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Kode ISBN *
              </label>
              <input
                type="text"
                required
                placeholder="Contoh: 978-623-010-845-7"
                value={formData.isbn}
                onChange={(e) => setFormData({ ...formData, isbn: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:outline-none font-mono"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Tahun Terbit *
              </label>
              <input
                type="number"
                required
                min="1950"
                max={new Date().getFullYear() + 1}
                value={formData.year}
                onChange={(e) => setFormData({ ...formData, year: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Judul Buku *
            </label>
            <input
              type="text"
              required
              placeholder="Masukkan judul buku lengkap"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:outline-none"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Pengarang / Penulis *
              </label>
              <input
                type="text"
                required
                placeholder="Nama pengarang"
                value={formData.author}
                onChange={(e) => setFormData({ ...formData, author: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Penerbit *
              </label>
              <input
                type="text"
                required
                placeholder="Nama penerbit buku"
                value={formData.publisher}
                onChange={(e) => setFormData({ ...formData, publisher: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:outline-none"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Kategori *
              </label>
              <select
                value={formData.category}
                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
              >
                <option value="Teknologi & RPL">Teknologi & RPL</option>
                <option value="Fiksi & Novel">Fiksi & Novel</option>
                <option value="Sains & Matematika">Sains & Matematika</option>
                <option value="Pengembangan Diri">Pengembangan Diri</option>
                <option value="Agama & Budi Pekerti">Agama & Budi Pekerti</option>
                <option value="Umum">Umum</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Lokasi Rak *
              </label>
              <input
                type="text"
                required
                placeholder="Contoh: Rak A-01"
                value={formData.shelf}
                onChange={(e) => setFormData({ ...formData, shelf: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Jumlah Stok Total *
              </label>
              <input
                type="number"
                required
                min="1"
                value={formData.stock}
                onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              URL Cover Sampul (Opsional)
            </label>
            <input
              type="url"
              placeholder="https://..."
              value={formData.cover}
              onChange={(e) => setFormData({ ...formData, cover: e.target.value })}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Sinopsis / Deskripsi Buku
            </label>
            <textarea
              rows={3}
              placeholder="Ringkasan singkat isi buku..."
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
            />
          </div>

          <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
            <button
              type="button"
              onClick={() => setIsAddEditOpen(false)}
              className="px-4 py-2 text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
            >
              Batal
            </button>
            <button
              type="submit"
              className="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-xl shadow-md transition"
            >
              {editingBook ? 'Simpan Perubahan' : 'Tambahkan ke Katalog'}
            </button>
          </div>
        </form>
      </Modal>

      {/* Book Detail Modal */}
      {viewingBook && (
        <Modal
          isOpen={!!viewingBook}
          onClose={() => setViewingBook(null)}
          title="Detail Koleksi Buku"
          maxWidth="max-w-xl"
        >
          <div className="flex flex-col sm:flex-row gap-6">
            <img
              src={viewingBook.cover}
              alt={viewingBook.title}
              className="w-36 h-52 object-cover rounded-xl shadow-md border border-slate-200 dark:border-slate-700 self-center sm:self-start"
            />
            <div className="space-y-3 flex-1 text-xs sm:text-sm">
              <div>
                <span className="px-2 py-0.5 bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300 rounded-full font-bold text-[10px]">
                  {viewingBook.category}
                </span>
                <h3 className="text-base font-extrabold text-slate-900 dark:text-white mt-1">
                  {viewingBook.title}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Oleh <span className="font-semibold">{viewingBook.author}</span> ({viewingBook.year})
                </p>
              </div>

              <div className="p-3 bg-slate-50 dark:bg-slate-800/60 rounded-xl space-y-1.5 border border-slate-100 dark:border-slate-800">
                <div className="flex justify-between">
                  <span className="text-slate-400">Penerbit:</span>
                  <span className="font-medium text-slate-800 dark:text-slate-200">{viewingBook.publisher}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">ISBN:</span>
                  <span className="font-mono text-slate-800 dark:text-slate-200">{viewingBook.isbn}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Lokasi Rak:</span>
                  <span className="font-semibold text-indigo-600 dark:text-indigo-400">{viewingBook.shelf}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Ketersediaan Stok:</span>
                  <span className="font-bold text-emerald-600">
                    {viewingBook.availableStock} Tersedia / {viewingBook.stock} Total
                  </span>
                </div>
              </div>

              <div>
                <h5 className="font-bold text-slate-900 dark:text-white text-xs mb-1">Sinopsis:</h5>
                <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                  {viewingBook.description}
                </p>
              </div>
            </div>
          </div>
        </Modal>
      )}

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={!!deleteTargetId}
        onClose={() => setDeleteTargetId(null)}
        onConfirm={handleDeleteConfirm}
        title="Hapus Data Buku"
        message="Apakah Anda yakin ingin menghapus buku ini dari basis data perpustakaan? Tindakan ini tidak dapat dibatalkan."
        confirmText="Ya, Hapus Buku"
        type="danger"
      />
    </div>
  );
};
