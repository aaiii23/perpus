import React, { useState } from 'react';
import {
  User,
  ShieldCheck,
  CreditCard,
  Phone,
  Mail,
  MapPin,
  Lock,
  Award,
  BookOpen,
  CheckCircle2
} from 'lucide-react';
import { memberService } from '../../services/memberService';
import { statsService } from '../../services/statsService';
import { PrintReceiptModal } from '../../components/PrintReceiptModal';

export const ProfilAnggota = ({ currentUser, showToast }) => {
  const [member, setMember] = useState(
    memberService.getMemberByNisn(currentUser?.nisn || '') || {
      name: currentUser?.name || 'Siswa',
      nisn: currentUser?.nisn || '0061234567',
      kelas: currentUser?.kelas || 'XII RPL 1',
      jurusan: 'Rekayasa Perangkat Lunak',
      email: currentUser?.email || 'siswa@smk.sch.id',
      phone: currentUser?.phone || '0812-3456-7890',
      address: 'Bandung, Jawa Barat',
      status: 'Aktif'
    }
  );

  const [phone, setPhone] = useState(member.phone || '');
  const [address, setAddress] = useState(member.address || '');
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [isCardModalOpen, setIsCardModalOpen] = useState(false);

  const memberStats = statsService.getMemberStats(member.nisn);

  const handleUpdateProfile = (e) => {
    e.preventDefault();
    try {
      if (member.id) {
        memberService.updateMember(member.id, { phone, address });
      }
      showToast({ type: 'success', message: 'Profil kontak berhasil diperbarui!' });
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  const handleChangePassword = (e) => {
    e.preventDefault();
    if (!newPassword || newPassword.length < 3) {
      showToast({ type: 'error', message: 'Password baru minimal 3 karakter!' });
      return;
    }
    showToast({ type: 'success', message: 'Password akun berhasil diubah!' });
    setCurrentPassword('');
    setNewPassword('');
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {/* Header */}
      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-extrabold text-slate-900 dark:text-white flex items-center gap-2">
            Profil Anggota Perpustakaan
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
            Informasi identitas siswa, kartu keanggotaan digital, dan pengaturan akun
          </p>
        </div>
        <button
          type="button"
          onClick={() => setIsCardModalOpen(true)}
          className="inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs sm:text-sm rounded-2xl shadow-md shadow-indigo-600/20 transition"
        >
          <CreditCard className="w-4 h-4" /> Cetak Kartu Digital
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column: Student ID Card & Badges */}
        <div className="lg:col-span-1 space-y-6">
          <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm text-center">
            <img
              src={currentUser?.avatar || 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'}
              alt={member.name}
              className="w-24 h-24 rounded-full object-cover mx-auto border-4 border-indigo-500 shadow-lg"
            />
            <h3 className="font-extrabold text-lg text-slate-900 dark:text-white mt-4">{member.name}</h3>
            <p className="font-mono text-xs font-semibold text-indigo-600 dark:text-indigo-400">
              NISN: {member.nisn}
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              {member.kelas} • {member.jurusan}
            </p>

            <div className="mt-4 pt-4 border-t border-slate-100 dark:border-slate-800 flex justify-around text-xs">
              <div>
                <span className="font-extrabold text-indigo-600 dark:text-indigo-400 text-base">
                  {memberStats.totalBorrowed}
                </span>
                <p className="text-slate-400 text-[10px]">Buku Dibaca</p>
              </div>
              <div className="border-r border-slate-100 dark:border-slate-800"></div>
              <div>
                <span className="font-extrabold text-emerald-600 text-base">{memberStats.completedLoans.length}</span>
                <p className="text-slate-400 text-[10px]">Tuntas Kembali</p>
              </div>
            </div>
          </div>

          {/* Gamification / Reading Badges */}
          <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm">
            <h4 className="font-bold text-sm text-slate-900 dark:text-white flex items-center gap-2 mb-3">
              <Award className="w-4 h-4 text-amber-500" /> Lencana Literasi Siswa
            </h4>

            <div className="space-y-3">
              <div className="p-3 bg-amber-50 dark:bg-amber-950/40 rounded-2xl border border-amber-200/60 dark:border-amber-900/60 flex items-center gap-3">
                <div className="p-2 bg-amber-500 text-white rounded-xl font-bold text-xs">⭐</div>
                <div>
                  <div className="font-bold text-xs text-amber-900 dark:text-amber-200">Kutu Buku SMK</div>
                  <p className="text-[10px] text-amber-700 dark:text-amber-400">Telah membaca koleksi literasi sekolah</p>
                </div>
              </div>

              <div className="p-3 bg-emerald-50 dark:bg-emerald-950/40 rounded-2xl border border-emerald-200/60 dark:border-emerald-900/60 flex items-center gap-3">
                <div className="p-2 bg-emerald-500 text-white rounded-xl font-bold text-xs">✨</div>
                <div>
                  <div className="font-bold text-xs text-emerald-900 dark:text-emerald-200">Peminjam Disiplin</div>
                  <p className="text-[10px] text-emerald-700 dark:text-emerald-400">Selalu mengembalikan tepat waktu</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column: Edit Contact & Change Password */}
        <div className="lg:col-span-2 space-y-6">
          {/* Edit Contact Form */}
          <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm">
            <h3 className="font-extrabold text-base text-slate-900 dark:text-white mb-4">
              Informasi Kontak & Domisili
            </h3>
            <form onSubmit={handleUpdateProfile} className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                    Email Siswa
                  </label>
                  <input
                    type="email"
                    disabled
                    value={member.email}
                    className="w-full px-3.5 py-2 bg-slate-100 dark:bg-slate-800/50 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-500 cursor-not-allowed"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                    Nomor WhatsApp / HP
                  </label>
                  <input
                    type="text"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                  Alamat Lengkap
                </label>
                <textarea
                  rows={3}
                  value={address}
                  onChange={(e) => setAddress(e.target.value)}
                  className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                />
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  className="px-5 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md transition"
                >
                  Simpan Perubahan Kontak
                </button>
              </div>
            </form>
          </div>

          {/* Change Password Form */}
          <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-sm">
            <h3 className="font-extrabold text-base text-slate-900 dark:text-white mb-4">
              Ganti Kata Sandi (Password)
            </h3>
            <form onSubmit={handleChangePassword} className="space-y-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                    Password Saat Ini
                  </label>
                  <input
                    type="password"
                    placeholder="••••••"
                    value={currentPassword}
                    onChange={(e) => setCurrentPassword(e.target.value)}
                    className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                    Password Baru
                  </label>
                  <input
                    type="password"
                    placeholder="••••••"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none"
                  />
                </div>
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  className="px-5 py-2 bg-slate-800 dark:bg-slate-700 hover:bg-slate-900 text-white font-bold text-xs rounded-xl shadow-sm transition"
                >
                  Update Password
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      {/* Print Member Card Modal */}
      {isCardModalOpen && (
        <PrintReceiptModal
          isOpen={isCardModalOpen}
          onClose={() => setIsCardModalOpen(false)}
          data={member}
          type="member_card"
        />
      )}
    </div>
  );
};
