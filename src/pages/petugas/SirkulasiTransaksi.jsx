import React, { useState } from 'react';
import {
  Repeat,
  PlusCircle,
  CheckCircle2,
  AlertCircle,
  Clock,
  Search,
  Printer,
  Calendar,
  User,
  BookOpen,
  DollarSign,
  ArrowUpRight,
  RotateCcw
} from 'lucide-react';
import { transactionService } from '../../services/transactionService';
import { bookService } from '../../services/bookService';
import { memberService } from '../../services/memberService';
import { Modal } from '../../components/Modal';
import { ConfirmDialog } from '../../components/ConfirmDialog';
import { PrintReceiptModal } from '../../components/PrintReceiptModal';

export const SirkulasiTransaksi = ({ showToast }) => {
  const [transactions, setTransactions] = useState(transactionService.getAllTransactions());
  const [activeSubTab, setActiveSubTab] = useState('all'); // 'all' | 'active' | 'overdue' | 'returned'
  const [searchQuery, setSearchQuery] = useState('');

  // New Loan Modal State
  const [isNewLoanOpen, setIsNewLoanOpen] = useState(false);
  const [selectedMemberId, setSelectedMemberId] = useState('');
  const [selectedBookId, setSelectedBookId] = useState('');
  const [loanDurationDays, setLoanDurationDays] = useState(7);
  const [loanNotes, setLoanNotes] = useState('');

  // Return & Fine Modal State
  const [returningTx, setReturningTx] = useState(null);
  const [returnNotes, setReturnNotes] = useState('');

  // Print Receipt State
  const [receiptData, setReceiptData] = useState(null);
  const [receiptType, setReceiptType] = useState('loan');

  const members = memberService.getAllMembers();
  const books = bookService.getAllBooks();

  const refreshData = () => {
    setTransactions(transactionService.getAllTransactions());
  };

  const filteredTransactions = transactions.filter((tx) => {
    const matchesSearch =
      tx.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tx.memberName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tx.bookTitle.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tx.memberNisn.includes(searchQuery);

    if (!matchesSearch) return false;

    if (activeSubTab === 'active') return tx.status === 'Dipinjam';
    if (activeSubTab === 'overdue') return tx.status === 'Terlambat';
    if (activeSubTab === 'returned') return tx.status === 'Kembali';
    return true;
  });

  const handleOpenNewLoan = () => {
    setSelectedMemberId(members[0]?.id || '');
    const availableBook = books.find((b) => b.availableStock > 0);
    setSelectedBookId(availableBook?.id || books[0]?.id || '');
    setLoanDurationDays(7);
    setLoanNotes('');
    setIsNewLoanOpen(true);
  };

  const handleCreateLoanSubmit = (e) => {
    e.preventDefault();
    try {
      const newTx = transactionService.borrowBook({
        memberId: selectedMemberId,
        bookId: selectedBookId,
        customDays: parseInt(loanDurationDays, 10),
        notes: loanNotes
      });

      showToast({
        type: 'success',
        message: `Peminjaman buku berhasil diproses! ID: ${newTx.id}`
      });

      setIsNewLoanOpen(false);
      refreshData();

      // Show receipt
      setReceiptData(newTx);
      setReceiptType('loan');
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  const handleOpenReturn = (tx) => {
    setReturningTx(tx);
    setReturnNotes('');
  };

  const handleConfirmReturn = () => {
    if (!returningTx) return;
    try {
      const updatedTx = transactionService.returnBook(returningTx.id, returnNotes);
      showToast({
        type: 'success',
        message: `Buku "${updatedTx.bookTitle}" berhasil dikembalikan!`
      });
      setReturningTx(null);
      refreshData();

      // Open print receipt for return
      setReceiptData(updatedTx);
      setReceiptType('return');
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  const handleExtend = (txId) => {
    try {
      const updated = transactionService.extendLoan(txId, 7);
      showToast({
        type: 'success',
        message: `Batas waktu pinjam berhasil diperpanjang hingga ${updated.dueDate}`
      });
      refreshData();
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  // Selected member & book preview info in form
  const currentSelectedMember = members.find((m) => m.id === selectedMemberId);
  const currentSelectedBook = books.find((b) => b.id === selectedBookId);

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Sirkulasi Peminjaman & Pengembalian
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Pencatatan sirkulasi buku, perpanjangan, dan kalkulasi otomatis denda keterlambatan
          </p>
        </div>
        <button
          type="button"
          onClick={handleOpenNewLoan}
          className="inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs sm:text-sm rounded-xl shadow-md shadow-indigo-600/20 transition"
        >
          <PlusCircle className="w-4 h-4" /> Transaksi Pinjam Baru
        </button>
      </div>

      {/* Filter Tabs & Search */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col md:flex-row items-stretch md:items-center justify-between gap-4">
        {/* Sub Tabs */}
        <div className="flex flex-wrap items-center gap-1.5 bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
          <button
            type="button"
            onClick={() => setActiveSubTab('all')}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition ${
              activeSubTab === 'all'
                ? 'bg-white dark:bg-slate-700 text-indigo-600 dark:text-indigo-300 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Semua ({transactions.length})
          </button>
          <button
            type="button"
            onClick={() => setActiveSubTab('active')}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition ${
              activeSubTab === 'active'
                ? 'bg-white dark:bg-slate-700 text-indigo-600 dark:text-indigo-300 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Dipinjam ({transactions.filter((t) => t.status === 'Dipinjam').length})
          </button>
          <button
            type="button"
            onClick={() => setActiveSubTab('overdue')}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition ${
              activeSubTab === 'overdue'
                ? 'bg-white dark:bg-slate-700 text-rose-600 dark:text-rose-400 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Terlambat ({transactions.filter((t) => t.status === 'Terlambat').length})
          </button>
          <button
            type="button"
            onClick={() => setActiveSubTab('returned')}
            className={`px-3 py-1.5 rounded-lg text-xs font-semibold transition ${
              activeSubTab === 'returned'
                ? 'bg-white dark:bg-slate-700 text-emerald-600 dark:text-emerald-400 shadow-sm'
                : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Kembali ({transactions.filter((t) => t.status === 'Kembali').length})
          </button>
        </div>

        {/* Search */}
        <div className="relative flex-1 md:max-w-xs">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Cari ID, siswa, atau buku..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-10 pr-4 py-1.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 text-slate-900 dark:text-white"
          />
        </div>
      </div>

      {/* Transactions Table */}
      <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs sm:text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/60 border-b border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3.5 px-4 font-semibold">ID Transaksi</th>
                <th className="py-3.5 px-4 font-semibold">Peminjam (Siswa)</th>
                <th className="py-3.5 px-4 font-semibold">Buku</th>
                <th className="py-3.5 px-4 font-semibold">Tgl Pinjam & Jatuh Tempo</th>
                <th className="py-3.5 px-4 font-semibold text-center">Status & Denda</th>
                <th className="py-3.5 px-4 font-semibold text-right">Aksi Sirkulasi</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800/60">
              {filteredTransactions.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 text-center text-slate-400 text-xs">
                    Tidak ada transaksi peminjaman pada kategori ini.
                  </td>
                </tr>
              ) : (
                filteredTransactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition">
                    <td className="py-3.5 px-4">
                      <div className="font-mono font-bold text-slate-900 dark:text-white">{tx.id}</div>
                      <div className="text-[10px] text-slate-400">Petugas: {tx.officerName}</div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="font-bold text-slate-900 dark:text-white">{tx.memberName}</div>
                      <div className="font-mono text-[11px] text-slate-400">NISN: {tx.memberNisn}</div>
                    </td>
                    <td className="py-3.5 px-4 max-w-[220px]">
                      <div className="font-semibold text-slate-800 dark:text-slate-200 truncate">
                        {tx.bookTitle}
                      </div>
                      <div className="font-mono text-[11px] text-slate-400">{tx.bookIsbn}</div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="flex items-center gap-1.5 text-xs text-slate-600 dark:text-slate-300">
                        <Calendar className="w-3.5 h-3.5 text-slate-400" /> Pinjam: {tx.borrowDate}
                      </div>
                      <div className="flex items-center gap-1.5 text-xs text-indigo-600 dark:text-indigo-400 font-semibold mt-0.5">
                        <Clock className="w-3.5 h-3.5" /> Tempo: {tx.dueDate}
                      </div>
                      {tx.returnDate && (
                        <div className="text-[11px] text-emerald-600 font-medium">
                          Kembali: {tx.returnDate}
                        </div>
                      )}
                    </td>
                    <td className="py-3.5 px-4 text-center">
                      <span
                        className={`badge-status ${
                          tx.status === 'Kembali'
                            ? 'bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300'
                            : tx.status === 'Terlambat'
                            ? 'bg-rose-100 text-rose-700 dark:bg-rose-950 dark:text-rose-300 animate-pulse'
                            : 'bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300'
                        }`}
                      >
                        {tx.status}
                      </span>
                      {tx.fineAmount > 0 && (
                        <div className="mt-1 font-bold text-xs text-rose-600">
                          Denda: Rp {tx.fineAmount.toLocaleString('id-ID')}
                          {tx.status === 'Terlambat' && (
                            <span className="block text-[10px] text-rose-500 font-normal">
                              ({tx.daysLate} hari terlambat)
                            </span>
                          )}
                        </div>
                      )}
                    </td>
                    <td className="py-3.5 px-4 text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        {tx.status !== 'Kembali' ? (
                          <>
                            <button
                              type="button"
                              onClick={() => handleOpenReturn(tx)}
                              className="px-2.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-bold text-xs shadow-sm transition flex items-center gap-1"
                              title="Proses Pengembalian Buku"
                            >
                              <CheckCircle2 className="w-3.5 h-3.5" /> Kembali
                            </button>
                            <button
                              type="button"
                              onClick={() => handleExtend(tx.id)}
                              className="p-1.5 text-slate-500 hover:text-indigo-600 hover:bg-indigo-50 dark:hover:bg-slate-800 rounded-lg transition"
                              title="Perpanjang Pinjam +7 Hari"
                            >
                              <RotateCcw className="w-4 h-4" />
                            </button>
                          </>
                        ) : (
                          <span className="text-[11px] text-slate-400 italic">Selesai</span>
                        )}

                        <button
                          type="button"
                          onClick={() => {
                            setReceiptData(tx);
                            setReceiptType(tx.status === 'Kembali' ? 'return' : 'loan');
                          }}
                          className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                          title="Cetak Bukti Transaksi"
                        >
                          <Printer className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* New Loan Modal */}
      <Modal
        isOpen={isNewLoanOpen}
        onClose={() => setIsNewLoanOpen(false)}
        title="Proses Peminjaman Buku Baru"
        subtitle="Pilih anggota dan judul buku yang dipinjam"
        maxWidth="max-w-xl"
      >
        <form onSubmit={handleCreateLoanSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Pilih Anggota Siswa (Peminjam) *
            </label>
            <select
              value={selectedMemberId}
              onChange={(e) => setSelectedMemberId(e.target.value)}
              className="w-full px-3.5 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
            >
              {members.map((m) => (
                <option key={m.id} value={m.id}>
                  {m.name} ({m.nisn}) - {m.kelas} [{m.status}]
                </option>
              ))}
            </select>
            {currentSelectedMember && (
              <div className="mt-2 p-2.5 bg-slate-50 dark:bg-slate-800/50 rounded-xl text-xs text-slate-600 dark:text-slate-300 flex items-center justify-between">
                <span>Jurusan: {currentSelectedMember.jurusan}</span>
                <span className="font-semibold text-indigo-600 dark:text-indigo-400">
                  Status: {currentSelectedMember.status}
                </span>
              </div>
            )}
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Pilih Buku yang Dipinjam *
            </label>
            <select
              value={selectedBookId}
              onChange={(e) => setSelectedBookId(e.target.value)}
              className="w-full px-3.5 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
            >
              {books.map((b) => (
                <option key={b.id} value={b.id} disabled={b.availableStock <= 0}>
                  {b.title} (Tersedia: {b.availableStock}/{b.stock}) - {b.shelf}
                </option>
              ))}
            </select>
            {currentSelectedBook && (
              <div className="mt-2 p-2.5 bg-slate-50 dark:bg-slate-800/50 rounded-xl text-xs text-slate-600 dark:text-slate-300 flex items-center justify-between">
                <span>Lokasi: {currentSelectedBook.shelf}</span>
                <span className={`font-bold ${currentSelectedBook.availableStock > 0 ? 'text-emerald-600' : 'text-rose-600'}`}>
                  Stok Tersedia: {currentSelectedBook.availableStock}
                </span>
              </div>
            )}
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Durasi Pinjam (Hari)
              </label>
              <select
                value={loanDurationDays}
                onChange={(e) => setLoanDurationDays(e.target.value)}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
              >
                <option value={3}>3 Hari</option>
                <option value={7}>7 Hari (Standar Perpustakaan)</option>
                <option value={14}>14 Hari</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Tarif Denda Keterlambatan
              </label>
              <div className="px-3.5 py-2 bg-slate-100 dark:bg-slate-800 rounded-xl text-xs font-semibold text-slate-700 dark:text-slate-300">
                Rp 1.000 / Hari Terlambat
              </div>
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Catatan Peminjaman (Opsional)
            </label>
            <input
              type="text"
              placeholder="Contoh: Untuk tugas praktikum UKK RPL"
              value={loanNotes}
              onChange={(e) => setLoanNotes(e.target.value)}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
            />
          </div>

          <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
            <button
              type="button"
              onClick={() => setIsNewLoanOpen(false)}
              className="px-4 py-2 text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
            >
              Batal
            </button>
            <button
              type="submit"
              className="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-xl shadow-md transition"
            >
              Simpan & Cetak Bukti Pinjam
            </button>
          </div>
        </form>
      </Modal>

      {/* Return & Fine Process Modal */}
      {returningTx && (
        <Modal
          isOpen={!!returningTx}
          onClose={() => setReturningTx(null)}
          title="Konfirmasi Pengembalian Buku"
          subtitle="Verifikasi kondisi buku dan perhitungan denda"
          maxWidth="max-w-md"
        >
          <div className="space-y-4">
            <div className="p-4 bg-slate-50 dark:bg-slate-800 rounded-xl space-y-2 text-xs sm:text-sm">
              <div className="flex justify-between">
                <span className="text-slate-500">Peminjam:</span>
                <span className="font-bold text-slate-900 dark:text-white">{returningTx.memberName}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">Judul Buku:</span>
                <span className="font-semibold text-slate-800 dark:text-slate-200 truncate max-w-[200px]">
                  {returningTx.bookTitle}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">Batas Waktu:</span>
                <span className="font-semibold text-indigo-600">{returningTx.dueDate}</span>
              </div>
            </div>

            {/* Fine Calculation Preview */}
            {returningTx.fineAmount > 0 ? (
              <div className="p-4 bg-rose-50 dark:bg-rose-950/50 border border-rose-200 dark:border-rose-900 rounded-xl">
                <div className="flex items-center gap-2 text-rose-700 dark:text-rose-300 font-bold text-sm">
                  <AlertCircle className="w-4 h-4" /> Terlambat {returningTx.daysLate} Hari!
                </div>
                <div className="mt-2 text-xs text-rose-600 dark:text-rose-400 flex justify-between items-center">
                  <span>Denda Otomatis Terhitung:</span>
                  <span className="font-extrabold text-base text-rose-700 dark:text-rose-300">
                    Rp {returningTx.fineAmount.toLocaleString('id-ID')}
                  </span>
                </div>
                <p className="text-[11px] text-rose-500 mt-1">
                  * Denda dihitung Rp 1.000 / hari keterlambatan. Pastikan siswa telah melunasi denda sebelum konfirmasi.
                </p>
              </div>
            ) : (
              <div className="p-3 bg-emerald-50 dark:bg-emerald-950/50 border border-emerald-200 dark:border-emerald-900 rounded-xl text-emerald-700 dark:text-emerald-300 text-xs flex items-center gap-2 font-semibold">
                <CheckCircle2 className="w-4 h-4 text-emerald-500" />
                Pengembalian Tepat Waktu (Tidak Ada Denda).
              </div>
            )}

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Catatan Pengembalian (Opsional)
              </label>
              <input
                type="text"
                placeholder="Kondisi buku baik / denda telah dibayar tunai"
                value={returnNotes}
                onChange={(e) => setReturnNotes(e.target.value)}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
              />
            </div>

            <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
              <button
                type="button"
                onClick={() => setReturningTx(null)}
                className="px-4 py-2 text-xs font-medium text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
              >
                Batal
              </button>
              <button
                type="button"
                onClick={handleConfirmReturn}
                className="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-md transition"
              >
                Konfirmasi Pengembalian
              </button>
            </div>
          </div>
        </Modal>
      )}

      {/* Print Receipt Modal */}
      {receiptData && (
        <PrintReceiptModal
          isOpen={!!receiptData}
          onClose={() => setReceiptData(null)}
          data={receiptData}
          type={receiptType}
        />
      )}
    </div>
  );
};
