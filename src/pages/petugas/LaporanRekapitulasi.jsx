import React, { useState } from 'react';
import {
  FileBarChart2,
  Printer,
  Download,
  Calendar,
  Filter,
  Award,
  BookOpen,
  DollarSign,
  CheckCircle2,
  TrendingUp,
  FileSpreadsheet
} from 'lucide-react';
import { transactionService } from '../../services/transactionService';
import { bookService } from '../../services/bookService';
import { statsService } from '../../services/statsService';
import { DEFAULT_SETTINGS } from '../../services/storage';

export const LaporanRekapitulasi = ({ showToast }) => {
  const [filterStatus, setFilterStatus] = useState('Semua');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');

  const transactions = transactionService.getAllTransactions();
  const books = bookService.getAllBooks();
  const stats = statsService.getDashboardStats();

  const filteredTransactions = transactions.filter((tx) => {
    const matchesStatus = filterStatus === 'Semua' || tx.status === filterStatus;
    const matchesStart = !startDate || tx.borrowDate >= startDate;
    const matchesEnd = !endDate || tx.borrowDate <= endDate;
    return matchesStatus && matchesStart && matchesEnd;
  });

  const totalDendaFiltered = filteredTransactions.reduce((acc, t) => acc + (t.fineAmount || 0), 0);

  const handlePrint = () => {
    window.print();
  };

  const handleExportCSV = () => {
    const exportData = filteredTransactions.map((t) => ({
      ID_Transaksi: t.id,
      Nama_Anggota: t.memberName,
      NISN: t.memberNisn,
      Judul_Buku: t.bookTitle,
      ISBN: t.bookIsbn,
      Tgl_Pinjam: t.borrowDate,
      Batas_Kembali: t.dueDate,
      Tgl_Kembali: t.returnDate || '-',
      Status: t.status,
      Denda_Rp: t.fineAmount || 0,
      Petugas: t.officerName
    }));

    statsService.exportToCSV(exportData, `Rekap_Sirkulasi_Perpustakaan_${new Date().toISOString().split('T')[0]}.csv`);
    showToast({ type: 'success', message: 'Laporan berhasil diekspor ke format CSV / Excel!' });
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white dark:bg-slate-900 p-6 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm no-print">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Laporan Rekapitulasi & Statistik
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Rekapitulasi data transaksi sirkulasi, buku terfavorit, dan penerimaan denda perpustakaan
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={handleExportCSV}
            className="inline-flex items-center gap-2 px-3.5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs rounded-xl shadow-sm transition"
          >
            <FileSpreadsheet className="w-4 h-4" /> Ekspor Excel/CSV
          </button>
          <button
            type="button"
            onClick={handlePrint}
            className="inline-flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md transition"
          >
            <Printer className="w-4 h-4" /> Cetak Laporan Resmi
          </button>
        </div>
      </div>

      {/* Filter Control Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-wrap items-center gap-4 no-print">
        <div className="flex items-center gap-2">
          <Filter className="w-4 h-4 text-slate-400" />
          <span className="text-xs font-bold text-slate-700 dark:text-slate-300">Status Sirkulasi:</span>
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="px-3 py-1.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-800 dark:text-slate-200 focus:outline-none"
          >
            <option value="Semua">Semua Transaksi</option>
            <option value="Dipinjam">Sedang Dipinjam</option>
            <option value="Terlambat">Terlambat (Denda)</option>
            <option value="Kembali">Sudah Kembali</option>
          </select>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-xs text-slate-400">Dari:</span>
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="px-2.5 py-1 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-800 dark:text-slate-200 focus:outline-none"
          />
          <span className="text-xs text-slate-400">Sampai:</span>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            className="px-2.5 py-1 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs text-slate-800 dark:text-slate-200 focus:outline-none"
          />
        </div>

        {(startDate || endDate || filterStatus !== 'Semua') && (
          <button
            type="button"
            onClick={() => {
              setStartDate('');
              setEndDate('');
              setFilterStatus('Semua');
            }}
            className="text-xs text-rose-600 hover:underline font-medium ml-auto"
          >
            Reset Filter
          </button>
        )}
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 no-print">
        <div className="p-4 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-xs font-bold text-slate-400 uppercase">Total Sirkulasi Tersaring</div>
          <div className="text-2xl font-extrabold text-slate-900 dark:text-white mt-2">
            {filteredTransactions.length} <span className="text-xs font-normal text-slate-400">Transaksi</span>
          </div>
        </div>

        <div className="p-4 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-xs font-bold text-slate-400 uppercase">Buku Selesai Dikembalikan</div>
          <div className="text-2xl font-extrabold text-emerald-600 mt-2">
            {filteredTransactions.filter((t) => t.status === 'Kembali').length}{' '}
            <span className="text-xs font-normal text-slate-400">Buku</span>
          </div>
        </div>

        <div className="p-4 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-sm">
          <div className="text-xs font-bold text-slate-400 uppercase">Akumulasi Denda</div>
          <div className="text-2xl font-extrabold text-rose-600 mt-2">
            Rp {totalDendaFiltered.toLocaleString('id-ID')}
          </div>
        </div>
      </div>

      {/* Printable Official Report Document */}
      <div className="p-8 bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm print:p-0 print:border-none print:shadow-none">
        {/* Kop Surat Resmi */}
        <div className="text-center border-b-2 border-slate-800 dark:border-slate-300 pb-4 mb-6">
          <h3 className="text-xs font-bold tracking-widest text-slate-500 uppercase">
            PEMERINTAH DAERAH PROVINSI • DINAS PENDIDIKAN
          </h3>
          <h1 className="text-xl sm:text-2xl font-black text-slate-900 dark:text-white uppercase tracking-tight mt-0.5">
            {DEFAULT_SETTINGS.schoolName}
          </h1>
          <h2 className="text-sm sm:text-base font-bold text-indigo-700 dark:text-indigo-400 uppercase">
            {DEFAULT_SETTINGS.libraryName}
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
            Laporan Rekapitulasi Sirkulasi Peminjaman & Pengembalian Buku • Tahun Ajaran {DEFAULT_SETTINGS.academicYear}
          </p>
        </div>

        {/* Report Meta Info */}
        <div className="flex justify-between items-center text-xs text-slate-600 dark:text-slate-400 mb-4">
          <div>
            <strong>Periode:</strong> {startDate || 'Awal'} s/d {endDate || 'Hari Ini'} |{' '}
            <strong>Status:</strong> {filterStatus}
          </div>
          <div>
            <strong>Tanggal Cetak:</strong> {new Date().toLocaleDateString('id-ID', { dateStyle: 'long' })}
          </div>
        </div>

        {/* Table of Circulation */}
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs border border-slate-200 dark:border-slate-700">
            <thead className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200">
              <tr className="border-b border-slate-200 dark:border-slate-700">
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">No</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">ID Transaksi</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">Nama Peminjam</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">NISN</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">Judul Buku</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">Tgl Pinjam</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">Batas Waktu</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700">Tgl Kembali</th>
                <th className="py-2.5 px-3 font-bold border-r border-slate-200 dark:border-slate-700 text-center">Status</th>
                <th className="py-2.5 px-3 font-bold text-right">Denda (Rp)</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200 dark:divide-slate-700">
              {filteredTransactions.map((tx, idx) => (
                <tr key={tx.id} className="hover:bg-slate-50 dark:hover:bg-slate-800/40">
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 text-center">{idx + 1}</td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 font-mono font-semibold">
                    {tx.id}
                  </td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 font-medium">
                    {tx.memberName}
                  </td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 font-mono">
                    {tx.memberNisn}
                  </td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 max-w-[180px] truncate">
                    {tx.bookTitle}
                  </td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700">{tx.borrowDate}</td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700">{tx.dueDate}</td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700">{tx.returnDate || '-'}</td>
                  <td className="py-2 px-3 border-r border-slate-200 dark:border-slate-700 text-center font-semibold">
                    {tx.status}
                  </td>
                  <td className="py-2 px-3 text-right font-bold">
                    {(tx.fineAmount || 0).toLocaleString('id-ID')}
                  </td>
                </tr>
              ))}
            </tbody>
            <tfoot>
              <tr className="bg-slate-50 dark:bg-slate-800 font-bold border-t-2 border-slate-300 dark:border-slate-700">
                <td colSpan={9} className="py-2 px-3 text-right border-r border-slate-200 dark:border-slate-700">
                  TOTAL AKUMULASI DENDA:
                </td>
                <td className="py-2 px-3 text-right text-rose-600">
                  Rp {totalDendaFiltered.toLocaleString('id-ID')}
                </td>
              </tr>
            </tfoot>
          </table>
        </div>

        {/* Top 3 Favorit Summary in Official Report */}
        <div className="mt-8 pt-4 border-t border-slate-200 dark:border-slate-700">
          <h4 className="text-xs font-bold text-slate-800 dark:text-slate-200 uppercase mb-2">
            Ringkasan 3 Buku Terfavorit (Paling Sering Dipinjam)
          </h4>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            {stats.topBooks.slice(0, 3).map((b, i) => (
              <div
                key={b.id}
                className="p-3 bg-slate-50 dark:bg-slate-800/60 rounded-xl border border-slate-200 dark:border-slate-700 text-xs"
              >
                <div className="font-bold text-indigo-600 dark:text-indigo-400">Peringkat #{i + 1}</div>
                <div className="font-bold text-slate-900 dark:text-white truncate">{b.title}</div>
                <div className="text-slate-500 text-[11px]">{b.author}</div>
                <div className="mt-1 font-semibold text-slate-700 dark:text-slate-300">
                  Dipinjam {b.borrowedCount || 0} Kali
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Signature Box */}
        <div className="mt-12 flex justify-between text-xs text-center text-slate-800 dark:text-slate-300">
          <div>
            <p>Mengetahui,</p>
            <p className="font-semibold">Kepala Perpustakaan Sekolah</p>
            <div className="h-16"></div>
            <p className="font-bold underline">{DEFAULT_SETTINGS.headLibrarian}</p>
            <p className="text-[11px] text-slate-500">NIP. {DEFAULT_SETTINGS.librarianNIP}</p>
          </div>
          <div>
            <p>Bandung, {new Date().toLocaleDateString('id-ID', { dateStyle: 'long' })}</p>
            <p className="font-semibold">Petugas Pelaksana Perpustakaan</p>
            <div className="h-16"></div>
            <p className="font-bold underline">Siti Rahmawati, S.Kom</p>
            <p className="text-[11px] text-slate-500">NIP. 19890415 201502 2 003</p>
          </div>
        </div>
      </div>
    </div>
  );
};
