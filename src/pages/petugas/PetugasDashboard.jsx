import React from 'react';
import {
  BookOpen,
  Users,
  Repeat,
  AlertCircle,
  TrendingUp,
  Award,
  ArrowRight,
  DollarSign,
  PlusCircle,
  FileText
} from 'lucide-react';
import { statsService } from '../../services/statsService';

export const PetugasDashboard = ({ onNavigate, onOpenPinjamModal }) => {
  const stats = statsService.getDashboardStats();

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Welcome Banner */}
      <div className="relative overflow-hidden bg-gradient-to-r from-indigo-600 via-indigo-700 to-violet-800 rounded-3xl p-6 sm:p-8 text-white shadow-xl shadow-indigo-600/15">
        <div className="relative z-10 max-w-2xl">
          <div className="inline-flex items-center gap-2 px-3 py-1 bg-white/15 backdrop-blur-md rounded-full text-xs font-semibold uppercase tracking-wider mb-3">
            <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
            SIMPERPUS SMK - Panel Petugas
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">
            Selamat Datang di Sistem Perpustakaan Digital
          </h1>
          <p className="mt-2 text-indigo-100 text-sm sm:text-base leading-relaxed">
            Kelola data buku, sirkulasi peminjaman, anggota, serta pemantauan otomatis denda keterlambatan secara efisien dan terstruktur.
          </p>
          <div className="mt-5 flex flex-wrap gap-3">
            <button
              type="button"
              onClick={() => onNavigate('sirkulasi')}
              className="inline-flex items-center gap-2 px-4 py-2.5 bg-white text-indigo-700 hover:bg-indigo-50 font-bold text-xs sm:text-sm rounded-xl shadow-md transition"
            >
              <PlusCircle className="w-4 h-4" /> Proses Sirkulasi Baru
            </button>
            <button
              type="button"
              onClick={() => onNavigate('laporan')}
              className="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-500/30 hover:bg-indigo-500/40 border border-white/20 text-white font-semibold text-xs sm:text-sm rounded-xl backdrop-blur-sm transition"
            >
              <FileText className="w-4 h-4" /> Lihat Rekap Laporan
            </button>
          </div>
        </div>
      </div>

      {/* Alert Banner for Overdue Books */}
      {stats.overdueLoansCount > 0 && (
        <div className="p-4 bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-900 rounded-2xl flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-rose-100 dark:bg-rose-900/60 text-rose-600 dark:text-rose-300 rounded-xl">
              <AlertCircle className="w-5 h-5" />
            </div>
            <div>
              <h4 className="text-sm font-bold text-rose-900 dark:text-rose-200">
                Peringatan: {stats.overdueLoansCount} Peminjaman Melewati Batas Jatuh Tempo!
              </h4>
              <p className="text-xs text-rose-700 dark:text-rose-400">
                Estimasi akumulasi denda berjalan: Rp {stats.potentialOverdueFines.toLocaleString('id-ID')}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={() => onNavigate('sirkulasi')}
            className="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold rounded-xl transition flex-shrink-0"
          >
            Tinjau Sirkulasi
          </button>
        </div>
      )}

      {/* Metric Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Buku */}
        <div
          onClick={() => onNavigate('buku')}
          className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm hover:shadow-md cursor-pointer transition card-hover-effect"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Katalog Buku</span>
            <div className="p-2.5 bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600 dark:text-indigo-400 rounded-xl">
              <BookOpen className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-extrabold text-slate-900 dark:text-white">
              {stats.totalBooks} <span className="text-xs font-normal text-slate-400">Eksemplar</span>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              Dari {stats.totalTitles} Judul Terdaftar
            </p>
          </div>
        </div>

        {/* Total Anggota */}
        <div
          onClick={() => onNavigate('anggota')}
          className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm hover:shadow-md cursor-pointer transition card-hover-effect"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Anggota Siswa</span>
            <div className="p-2.5 bg-emerald-50 dark:bg-emerald-950/50 text-emerald-600 dark:text-emerald-400 rounded-xl">
              <Users className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-extrabold text-slate-900 dark:text-white">
              {stats.totalMembers} <span className="text-xs font-normal text-slate-400">Siswa</span>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              {stats.activeMembers} Anggota Berstatus Aktif
            </p>
          </div>
        </div>

        {/* Peminjaman Aktif */}
        <div
          onClick={() => onNavigate('sirkulasi')}
          className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm hover:shadow-md cursor-pointer transition card-hover-effect"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Peminjaman Aktif</span>
            <div className="p-2.5 bg-sky-50 dark:bg-sky-950/50 text-sky-600 dark:text-sky-400 rounded-xl">
              <Repeat className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-extrabold text-slate-900 dark:text-white">
              {stats.activeLoansCount + stats.overdueLoansCount}{' '}
              <span className="text-xs font-normal text-slate-400">Transaksi</span>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              {stats.overdueLoansCount} Terlambat, {stats.activeLoansCount} Tepat Waktu
            </p>
          </div>
        </div>

        {/* Total Denda Terkumpul */}
        <div
          onClick={() => onNavigate('laporan')}
          className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm hover:shadow-md cursor-pointer transition card-hover-effect"
        >
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Total Kas Denda</span>
            <div className="p-2.5 bg-amber-50 dark:bg-amber-950/50 text-amber-600 dark:text-amber-400 rounded-xl">
              <DollarSign className="w-5 h-5" />
            </div>
          </div>
          <div className="mt-3">
            <div className="text-2xl font-extrabold text-slate-900 dark:text-white">
              Rp {stats.totalFinesCollected.toLocaleString('id-ID')}
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              Dari transaksi pengembalian selesai
            </p>
          </div>
        </div>
      </div>

      {/* Two Column Layout: Top Books & Recent Transactions */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Top 5 Most Borrowed Books */}
        <div className="lg:col-span-1 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Award className="w-5 h-5 text-amber-500" />
              <h3 className="font-bold text-slate-900 dark:text-white text-base">Buku Terfavorit</h3>
            </div>
            <span className="text-xs text-slate-400">Top 5</span>
          </div>

          <div className="space-y-3">
            {stats.topBooks.map((book, idx) => (
              <div
                key={book.id}
                className="flex items-center gap-3 p-2.5 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800/50 transition border border-transparent hover:border-slate-100 dark:hover:border-slate-800"
              >
                <div
                  className={`w-7 h-7 rounded-lg flex items-center justify-center font-bold text-xs flex-shrink-0 ${
                    idx === 0
                      ? 'bg-amber-100 text-amber-700 dark:bg-amber-950 dark:text-amber-300'
                      : idx === 1
                      ? 'bg-slate-200 text-slate-700 dark:bg-slate-800 dark:text-slate-300'
                      : idx === 2
                      ? 'bg-amber-50 text-amber-800'
                      : 'bg-slate-100 text-slate-500 dark:bg-slate-800 dark:text-slate-400'
                  }`}
                >
                  #{idx + 1}
                </div>
                <img
                  src={book.cover}
                  alt={book.title}
                  className="w-10 h-14 rounded-md object-cover shadow-sm flex-shrink-0"
                />
                <div className="flex-1 min-w-0">
                  <h4 className="text-xs font-bold text-slate-900 dark:text-white truncate">
                    {book.title}
                  </h4>
                  <p className="text-[11px] text-slate-500 dark:text-slate-400 truncate">
                    {book.author}
                  </p>
                  <div className="mt-1 flex items-center gap-2 text-[10px] text-indigo-600 dark:text-indigo-400 font-semibold">
                    <TrendingUp className="w-3 h-3" /> {book.borrowedCount || 0}x Dipinjam
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Transactions Table */}
        <div className="lg:col-span-2 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="font-bold text-slate-900 dark:text-white text-base">
                Aktivitas Sirkulasi Terbaru
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                Data peminjaman & pengembalian buku terakhir
              </p>
            </div>
            <button
              type="button"
              onClick={() => onNavigate('sirkulasi')}
              className="text-xs font-semibold text-indigo-600 dark:text-indigo-400 hover:underline flex items-center gap-1"
            >
              Lihat Semua <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>

          <div className="overflow-x-auto flex-1">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-slate-100 dark:border-slate-800 text-slate-400 uppercase tracking-wider">
                  <th className="pb-3 font-semibold">ID / Peminjam</th>
                  <th className="pb-3 font-semibold">Judul Buku</th>
                  <th className="pb-3 font-semibold">Batas Kembali</th>
                  <th className="pb-3 font-semibold">Status</th>
                  <th className="pb-3 font-semibold text-right">Denda</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800/60">
                {stats.recentTransactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition">
                    <td className="py-3">
                      <div className="font-mono font-bold text-slate-900 dark:text-white">{tx.id}</div>
                      <div className="text-slate-500 dark:text-slate-400 text-[11px]">{tx.memberName}</div>
                    </td>
                    <td className="py-3 max-w-[200px] truncate font-medium text-slate-800 dark:text-slate-200">
                      {tx.bookTitle}
                    </td>
                    <td className="py-3 text-slate-600 dark:text-slate-400">
                      {tx.dueDate}
                    </td>
                    <td className="py-3">
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
                    </td>
                    <td className="py-3 text-right font-bold">
                      {tx.fineAmount > 0 ? (
                        <span className="text-rose-600">Rp {tx.fineAmount.toLocaleString('id-ID')}</span>
                      ) : (
                        <span className="text-slate-400">-</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};
