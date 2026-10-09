import React from 'react';
import { Modal } from './Modal';
import { Printer, BookOpen, CheckCircle, ShieldCheck, User } from 'lucide-react';
import { DEFAULT_SETTINGS } from '../services/storage';

export const PrintReceiptModal = ({ isOpen, onClose, data, type = 'loan' }) => {
  if (!data) return null;

  const handlePrint = () => {
    window.print();
  };

  const isReturn = type === 'return';
  const isMemberCard = type === 'member_card';

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={
        isMemberCard
          ? 'Kartu Anggota Perpustakaan Digital'
          : isReturn
          ? 'Bukti Pengembalian Buku'
          : 'Bukti Peminjaman Buku Perpustakaan'
      }
      subtitle="Dokumen resmi sistem perpustakaan sekolah"
      maxWidth="max-w-lg"
    >
      <div className="space-y-6">
        {/* Printable Card */}
        <div className="print-card p-6 bg-slate-50 dark:bg-slate-800/60 rounded-2xl border-2 border-dashed border-slate-300 dark:border-slate-700">
          {/* Header Lembaga */}
          <div className="text-center border-b border-slate-200 dark:border-slate-700 pb-4 mb-4">
            <div className="flex items-center justify-center gap-2 text-indigo-600 dark:text-indigo-400 mb-1">
              <BookOpen className="w-6 h-6" />
              <span className="font-extrabold text-sm uppercase tracking-wider">
                {DEFAULT_SETTINGS.libraryName}
              </span>
            </div>
            <h4 className="text-base font-bold text-slate-900 dark:text-white">
              {DEFAULT_SETTINGS.schoolName}
            </h4>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              Tahun Ajaran {DEFAULT_SETTINGS.academicYear} • Standar UKK RPL KM25.4.1.1
            </p>
          </div>

          {/* Member Card View */}
          {isMemberCard ? (
            <div className="space-y-4">
              <div className="flex items-center gap-4 bg-white dark:bg-slate-900 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                <img
                  src={data.avatar || 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'}
                  alt={data.name}
                  className="w-16 h-16 rounded-full object-cover border-2 border-indigo-500 shadow-md"
                />
                <div>
                  <div className="text-xs font-bold text-indigo-600 dark:text-indigo-400 uppercase">
                    ID: {data.id}
                  </div>
                  <h5 className="font-bold text-slate-900 dark:text-white text-base leading-tight">
                    {data.name}
                  </h5>
                  <p className="text-xs text-slate-600 dark:text-slate-400">
                    NISN: <span className="font-mono font-semibold">{data.nisn}</span>
                  </p>
                  <p className="text-xs text-slate-600 dark:text-slate-400">
                    Kelas: {data.kelas} ({data.jurusan})
                  </p>
                </div>
              </div>

              {/* Barcode & Status Mockup */}
              <div className="bg-white dark:bg-slate-900 p-3 rounded-xl border border-slate-200 dark:border-slate-800 text-center">
                <div className="font-mono text-xs text-slate-400 mb-1">BARCODE ID SISWA</div>
                <div className="flex justify-center items-center gap-1 py-1 text-slate-900 dark:text-white font-mono font-bold tracking-widest text-lg">
                  ||| | |||| | || ||| || ||| {data.nisn}
                </div>
                <div className="text-[11px] text-emerald-600 dark:text-emerald-400 font-semibold flex items-center justify-center gap-1 mt-1">
                  <ShieldCheck className="w-3.5 h-3.5" /> STATUS: ANGGOTA AKTIF TERVERIFIKASI
                </div>
              </div>
            </div>
          ) : (
            /* Loan / Return Receipt View */
            <div className="space-y-3 text-sm">
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">No. Transaksi</span>
                <span className="font-mono font-bold text-slate-800 dark:text-slate-200">{data.id}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">Nama Anggota</span>
                <span className="font-semibold text-slate-800 dark:text-slate-200">{data.memberName} ({data.memberNisn})</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">Judul Buku</span>
                <span className="font-medium text-slate-800 dark:text-slate-200 text-right max-w-[240px] truncate">
                  {data.bookTitle}
                </span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">ISBN</span>
                <span className="font-mono text-slate-700 dark:text-slate-300">{data.bookIsbn}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">Tanggal Pinjam</span>
                <span className="text-slate-800 dark:text-slate-200">{data.borrowDate}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                <span className="text-slate-500 dark:text-slate-400">Batas Pengembalian</span>
                <span className="font-semibold text-indigo-600 dark:text-indigo-400">{data.dueDate}</span>
              </div>

              {isReturn && (
                <>
                  <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                    <span className="text-slate-500 dark:text-slate-400">Tanggal Kembali</span>
                    <span className="font-semibold text-emerald-600 dark:text-emerald-400">{data.returnDate || '-'}</span>
                  </div>
                  <div className="flex justify-between py-1 border-b border-slate-200/60 dark:border-slate-700/60">
                    <span className="text-slate-500 dark:text-slate-400">Denda Keterlambatan</span>
                    <span className={`font-bold ${data.fineAmount > 0 ? 'text-rose-600' : 'text-slate-700 dark:text-slate-300'}`}>
                      Rp {(data.fineAmount || 0).toLocaleString('id-ID')}
                    </span>
                  </div>
                </>
              )}

              <div className="pt-2 text-[11px] text-slate-400 italic text-center">
                * Harap simpan bukti ini sebagai bukti transaksi yang sah.
              </div>
            </div>
          )}

          {/* Tanda Tangan */}
          <div className="mt-6 pt-4 border-t border-slate-200 dark:border-slate-700 flex justify-between text-xs text-center text-slate-600 dark:text-slate-400">
            <div>
              <p>Peminjam / Anggota,</p>
              <div className="h-12"></div>
              <p className="font-semibold text-slate-900 dark:text-slate-200">
                ( {data.memberName || data.name} )
              </p>
            </div>
            <div>
              <p>Petugas Perpustakaan,</p>
              <div className="h-12"></div>
              <p className="font-semibold text-slate-900 dark:text-slate-200">
                ( {data.officerName || DEFAULT_SETTINGS.headLibrarian} )
              </p>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-end gap-3 no-print">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
          >
            Tutup
          </button>
          <button
            type="button"
            onClick={handlePrint}
            className="flex items-center gap-2 px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-xl shadow-md transition"
          >
            <Printer className="w-4 h-4" /> Cetak Dokumen / PDF
          </button>
        </div>
      </div>
    </Modal>
  );
};
