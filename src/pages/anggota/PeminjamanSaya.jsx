import React, { useState } from 'react';
import {
  Clock,
  Calendar,
  AlertCircle,
  CheckCircle2,
  Printer,
  RotateCcw,
  BookOpen,
  ArrowUpRight
} from 'lucide-react';
import { transactionService } from '../../services/transactionService';
import { memberService } from '../../services/memberService';
import { PrintReceiptModal } from '../../components/PrintReceiptModal';

export const PeminjamanSaya = ({ currentUser, showToast }) => {
  const [activeTab, setActiveTab] = useState('active'); // 'active' | 'history'
  const [receiptData, setReceiptData] = useState(null);

  const member = memberService.getMemberByNisn(currentUser?.nisn || '');
  const allTransactions = transactionService.getAllTransactions().filter(
    (t) => t.memberNisn === (member?.nisn || currentUser?.nisn || '0061234567')
  );

  const activeLoans = allTransactions.filter(
    (t) => t.status === 'Dipinjam' || t.status === 'Terlambat'
  );
  const completedLoans = allTransactions.filter((t) => t.status === 'Kembali');

  const handleExtend = (txId) => {
    try {
      const updated = transactionService.extendLoan(txId, 7);
      showToast({
        type: 'success',
        message: `Batas waktu pengembalian berhasil diperpanjang hingga ${updated.dueDate} (+7 Hari)`
      });
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Peminjaman & Riwayat Saya
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Pantau status batas waktu buku yang sedang kamu pinjam dan riwayat membaca
          </p>
        </div>

        {/* Tab switcher */}
        <div className="flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-2xl">
          <button
            type="button"
            onClick={() => setActiveTab('active')}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === 'active'
                ? 'bg-indigo-600 text-white shadow-md'
                : 'text-slate-600 dark:text-slate-400 hover:text-slate-900'
            }`}
          >
            Sedang Dipinjam ({activeLoans.length})
          </button>
          <button
            type="button"
            onClick={() => setActiveTab('history')}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === 'history'
                ? 'bg-indigo-600 text-white shadow-md'
                : 'text-slate-600 dark:text-slate-400 hover:text-slate-900'
            }`}
          >
            Riwayat Selesai ({completedLoans.length})
          </button>
        </div>
      </div>

      {/* Content based on Tab */}
      {activeTab === 'active' ? (
        <div className="space-y-4">
          {activeLoans.length === 0 ? (
            <div className="p-12 text-center bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800">
              <CheckCircle2 className="w-12 h-12 text-emerald-500 mx-auto mb-3" />
              <h4 className="text-base font-bold text-slate-800 dark:text-slate-200">
                Kamu Tidak Memiliki Tanggungan Peminjaman
              </h4>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
                Koleksi buku kamu rapi! Silakan kunjungi katalog untuk meminjam buku baru.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {activeLoans.map((tx) => {
                const isOverdue = tx.status === 'Terlambat';
                return (
                  <div
                    key={tx.id}
                    className={`p-5 bg-white dark:bg-slate-900 rounded-3xl border shadow-sm flex flex-col justify-between ${
                      isOverdue
                        ? 'border-rose-300 dark:border-rose-900 bg-rose-50/30'
                        : 'border-slate-200 dark:border-slate-800'
                    }`}
                  >
                    <div>
                      <div className="flex items-center justify-between gap-2">
                        <span className="font-mono text-xs font-bold text-slate-400">{tx.id}</span>
                        <span
                          className={`badge-status ${
                            isOverdue
                              ? 'bg-rose-100 text-rose-700 dark:bg-rose-950 dark:text-rose-300 animate-pulse'
                              : 'bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300'
                          }`}
                        >
                          {tx.status}
                        </span>
                      </div>

                      <h3 className="font-extrabold text-base text-slate-900 dark:text-white mt-3 line-clamp-2">
                        {tx.bookTitle}
                      </h3>
                      <p className="text-xs text-slate-400 font-mono mt-0.5">ISBN: {tx.bookIsbn}</p>

                      <div className="mt-4 p-3 bg-slate-50 dark:bg-slate-800/60 rounded-2xl space-y-1.5 text-xs">
                        <div className="flex justify-between">
                          <span className="text-slate-500">Tanggal Pinjam:</span>
                          <span className="font-medium text-slate-800 dark:text-slate-200">{tx.borrowDate}</span>
                        </div>
                        <div className="flex justify-between">
                          <span className="text-slate-500">Batas Pengembalian:</span>
                          <span className={`font-bold ${isOverdue ? 'text-rose-600' : 'text-indigo-600'}`}>
                            {tx.dueDate}
                          </span>
                        </div>
                        {isOverdue && (
                          <div className="flex justify-between pt-1 border-t border-rose-200 dark:border-rose-900/60 text-rose-600 font-bold">
                            <span>Denda Keterlambatan:</span>
                            <span>Rp {tx.fineAmount.toLocaleString('id-ID')}</span>
                          </div>
                        )}
                      </div>
                    </div>

                    <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between gap-2">
                      <button
                        type="button"
                        onClick={() => handleExtend(tx.id)}
                        disabled={isOverdue}
                        className={`inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-bold rounded-xl transition ${
                          isOverdue
                            ? 'bg-slate-100 text-slate-400 cursor-not-allowed'
                            : 'bg-indigo-50 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300 hover:bg-indigo-100'
                        }`}
                      >
                        <RotateCcw className="w-3.5 h-3.5" /> Perpanjang 7 Hari
                      </button>

                      <button
                        type="button"
                        onClick={() => setReceiptData(tx)}
                        className="p-2 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
                        title="Cetak Bukti Pinjam"
                      >
                        <Printer className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      ) : (
        /* History Tab */
        <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs sm:text-sm">
              <thead className="bg-slate-50 dark:bg-slate-800/60 border-b border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3.5 px-4 font-semibold">ID & Buku</th>
                  <th className="py-3.5 px-4 font-semibold">Tgl Pinjam & Batas</th>
                  <th className="py-3.5 px-4 font-semibold">Tgl Dikembalikan</th>
                  <th className="py-3.5 px-4 font-semibold text-center">Status</th>
                  <th className="py-3.5 px-4 font-semibold text-right">Denda Terbayar</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/60">
                {completedLoans.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="py-8 text-center text-slate-400 text-xs">
                      Belum ada riwayat peminjaman buku yang telah selesai.
                    </td>
                  </tr>
                ) : (
                  completedLoans.map((tx) => (
                    <tr key={tx.id} className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition">
                      <td className="py-3 px-4">
                        <div className="font-bold text-slate-900 dark:text-white">{tx.bookTitle}</div>
                        <div className="font-mono text-[11px] text-slate-400">{tx.id} • ISBN: {tx.bookIsbn}</div>
                      </td>
                      <td className="py-3 px-4 text-xs text-slate-600 dark:text-slate-400">
                        <div>Pinjam: {tx.borrowDate}</div>
                        <div className="text-slate-400">Tempo: {tx.dueDate}</div>
                      </td>
                      <td className="py-3 px-4 text-xs font-semibold text-emerald-600">
                        {tx.returnDate || '-'}
                      </td>
                      <td className="py-3 px-4 text-center">
                        <span className="badge-status bg-emerald-100 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300">
                          Kembali Selesai
                        </span>
                      </td>
                      <td className="py-3 px-4 text-right font-bold text-slate-700 dark:text-slate-300">
                        {tx.fineAmount > 0 ? `Rp ${tx.fineAmount.toLocaleString('id-ID')}` : 'Rp 0'}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Receipt Modal */}
      {receiptData && (
        <PrintReceiptModal
          isOpen={!!receiptData}
          onClose={() => setReceiptData(null)}
          data={receiptData}
          type="loan"
        />
      )}
    </div>
  );
};
