import React from 'react';
import {
  BookOpen,
  Clock,
  AlertCircle,
  CheckCircle2,
  TrendingUp,
  CreditCard,
  ArrowRight,
  ShieldCheck,
  Bookmark,
  Sparkles
} from 'lucide-react';
import { statsService } from '../../services/statsService';
import { bookService } from '../../services/bookService';
import { memberService } from '../../services/memberService';
import { DEFAULT_SETTINGS } from '../../services/storage';

export const AnggotaDashboard = ({ currentUser, onNavigate, onOpenBookDetail }) => {
  const member = memberService.getMemberByNisn(currentUser?.nisn || '') || {
    name: currentUser?.name || 'Siswa',
    nisn: currentUser?.nisn || '0061234567',
    kelas: currentUser?.kelas || 'XII RPL 1',
    jurusan: 'Rekayasa Perangkat Lunak',
    status: 'Aktif'
  };

  const memberStats = statsService.getMemberStats(member.nisn);
  const books = bookService.getAllBooks();
  const recommendedBooks = books.slice(0, 4);

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Student Profile Hero & Digital Card Banner */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left: Welcome Card */}
        <div className="lg:col-span-2 bg-gradient-to-br from-indigo-600 via-indigo-700 to-violet-800 rounded-3xl p-6 sm:p-8 text-white shadow-xl shadow-indigo-600/15 flex flex-col justify-between">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 bg-white/15 backdrop-blur-md rounded-full text-xs font-semibold mb-3">
              <Sparkles className="w-3.5 h-3.5 text-amber-300" />
              Siswa Terverifikasi • {DEFAULT_SETTINGS.schoolName}
            </div>
            <h1 className="text-2xl sm:text-3xl font-black tracking-tight">
              Hai, {member.name}! 👋
            </h1>
            <p className="mt-2 text-indigo-100 text-xs sm:text-sm leading-relaxed max-w-xl">
              Selamat datang di portal perpustakaan digital. Cari buku favoritmu, pantau batas waktu pengembalian, dan ajukan peminjaman secara mandiri.
            </p>
          </div>

          <div className="mt-6 flex flex-wrap gap-3">
            <button
              type="button"
              onClick={() => onNavigate('katalog')}
              className="inline-flex items-center gap-2 px-4 py-2.5 bg-white text-indigo-700 hover:bg-indigo-50 font-bold text-xs sm:text-sm rounded-xl shadow-md transition"
            >
              <BookOpen className="w-4 h-4" /> Buka Katalog Buku
            </button>
            <button
              type="button"
              onClick={() => onNavigate('peminjaman_saya')}
              className="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-500/30 hover:bg-indigo-500/40 border border-white/20 text-white font-semibold text-xs sm:text-sm rounded-xl backdrop-blur-sm transition"
            >
              <Clock className="w-4 h-4" /> Peminjaman Saya ({memberStats.activeLoans.length})
            </button>
          </div>
        </div>

        {/* Right: Digital Member Card Mockup */}
        <div className="bg-gradient-to-tr from-slate-900 via-slate-800 to-indigo-950 p-5 rounded-3xl text-white shadow-xl border border-slate-700/60 flex flex-col justify-between relative overflow-hidden">
          <div className="absolute top-0 right-0 -mr-8 -mt-8 w-32 h-32 bg-indigo-500/10 rounded-full blur-2xl"></div>

          <div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <CreditCard className="w-5 h-5 text-indigo-400" />
                <span className="font-extrabold text-xs tracking-wider uppercase text-indigo-300">
                  KARTU PERPUSTAKAAN
                </span>
              </div>
              <span className="text-[10px] font-bold px-2 py-0.5 bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 rounded-full">
                AKTIF
              </span>
            </div>

            <div className="mt-4 flex items-center gap-3.5">
              <img
                src={currentUser?.avatar || 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'}
                alt={member.name}
                className="w-12 h-12 rounded-full object-cover border-2 border-indigo-400"
              />
              <div className="min-w-0">
                <h4 className="font-bold text-sm text-white truncate">{member.name}</h4>
                <p className="font-mono text-xs text-indigo-200">NISN: {member.nisn}</p>
                <p className="text-[11px] text-slate-400">{member.kelas}</p>
              </div>
            </div>
          </div>

          <div className="mt-4 pt-3 border-t border-slate-700/80 flex items-center justify-between text-[11px] font-mono text-slate-400">
            <span>BARCODE: |||| | ||| {member.nisn.slice(-4)}</span>
            <span className="text-indigo-300 font-bold">{DEFAULT_SETTINGS.academicYear}</span>
          </div>
        </div>
      </div>

      {/* Active Borrowing Deadline Alert Banner */}
      {memberStats.overdueLoans.length > 0 ? (
        <div className="p-4 bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-900 rounded-2xl flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-rose-100 dark:bg-rose-900 text-rose-600 dark:text-rose-300 rounded-xl">
              <AlertCircle className="w-5 h-5" />
            </div>
            <div>
              <h4 className="text-sm font-bold text-rose-900 dark:text-rose-200">
                Perhatian: Kamu memiliki {memberStats.overdueLoans.length} buku yang melewati batas tanggal kembali!
              </h4>
              <p className="text-xs text-rose-700 dark:text-rose-400">
                Estimasi denda saat ini: Rp {memberStats.totalFines.toLocaleString('id-ID')}. Segera kembalikan ke petugas perpustakaan.
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={() => onNavigate('peminjaman_saya')}
            className="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold rounded-xl transition flex-shrink-0"
          >
            Lihat Buku
          </button>
        </div>
      ) : memberStats.activeLoans.length > 0 ? (
        <div className="p-4 bg-indigo-50 dark:bg-indigo-950/40 border border-indigo-200 dark:border-indigo-900 rounded-2xl flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-indigo-100 dark:bg-indigo-900 text-indigo-600 dark:text-indigo-300 rounded-xl">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <h4 className="text-sm font-bold text-indigo-950 dark:text-indigo-200">
                Kamu sedang meminjam {memberStats.activeLoans.length} buku
              </h4>
              <p className="text-xs text-indigo-700 dark:text-indigo-400">
                Batas pengembalian terdekat: {memberStats.activeLoans[0]?.dueDate}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={() => onNavigate('peminjaman_saya')}
            className="px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold rounded-xl transition flex-shrink-0"
          >
            Rincian Pinjam
          </button>
        </div>
      ) : null}

      {/* Summary Mini Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Sedang Dipinjam</span>
          <div className="text-2xl font-extrabold text-slate-900 dark:text-white mt-2">
            {memberStats.activeLoans.length + memberStats.overdueLoans.length}{' '}
            <span className="text-xs font-normal text-slate-400">/ 3 Maksimal</span>
          </div>
        </div>

        <div className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Total Buku Dibaca</span>
          <div className="text-2xl font-extrabold text-indigo-600 dark:text-indigo-400 mt-2">
            {memberStats.totalBorrowed} <span className="text-xs font-normal text-slate-400">Buku</span>
          </div>
        </div>

        <div className="p-5 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Tanggungan Denda</span>
          <div className={`text-2xl font-extrabold mt-2 ${memberStats.totalFines > 0 ? 'text-rose-600' : 'text-emerald-600'}`}>
            Rp {memberStats.totalFines.toLocaleString('id-ID')}
          </div>
        </div>
      </div>

      {/* Recommended Books Section */}
      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-base font-extrabold text-slate-900 dark:text-white">
              Rekomendasi Buku Populer
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              Koleksi buku terfavorit pilihan siswa SMK
            </p>
          </div>
          <button
            type="button"
            onClick={() => onNavigate('katalog')}
            className="text-xs font-bold text-indigo-600 dark:text-indigo-400 hover:underline flex items-center gap-1"
          >
            Lihat Semua Katalog <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {recommendedBooks.map((book) => (
            <div
              key={book.id}
              onClick={() => onOpenBookDetail(book)}
              className="p-3 bg-slate-50 dark:bg-slate-800/60 rounded-2xl border border-slate-200/80 dark:border-slate-800 hover:shadow-md cursor-pointer transition card-hover-effect flex flex-col"
            >
              <img
                src={book.cover}
                alt={book.title}
                className="w-full h-40 object-cover rounded-xl shadow-sm mb-3"
              />
              <span className="text-[10px] font-bold text-indigo-600 dark:text-indigo-400 uppercase">
                {book.category}
              </span>
              <h4 className="font-bold text-xs text-slate-900 dark:text-white line-clamp-2 mt-1 flex-1">
                {book.title}
              </h4>
              <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">{book.author}</p>
              <div className="mt-3 pt-2 border-t border-slate-200/60 dark:border-slate-700/60 flex items-center justify-between text-[11px]">
                <span className="text-slate-400">{book.shelf}</span>
                <span className="font-bold text-emerald-600">Stok: {book.availableStock}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
