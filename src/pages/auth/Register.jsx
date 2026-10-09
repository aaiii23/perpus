import React, { useState } from 'react';
import {
  BookOpen,
  User,
  Lock,
  Mail,
  Phone,
  GraduationCap,
  ArrowLeft,
  CheckCircle2
} from 'lucide-react';
import { authService } from '../../services/authService';

export const Register = ({ onRegisterSuccess, onSwitchToLogin, showToast }) => {
  const [formData, setFormData] = useState({
    username: '',
    password: '',
    name: '',
    nisn: '',
    kelas: 'XII RPL 1',
    jurusan: 'Rekayasa Perangkat Lunak',
    email: '',
    phone: '',
    gender: 'Laki-laki',
    address: ''
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    try {
      const newUser = authService.registerMember(formData);
      showToast({
        type: 'success',
        message: `Pendaftaran berhasil! Selamat datang, ${newUser.name}`
      });
      onRegisterSuccess(newUser);
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    }
  };

  return (
    <div className="min-h-[85vh] flex items-center justify-center p-4">
      <div className="w-full max-w-lg bg-white dark:bg-slate-900 rounded-3xl p-8 border border-slate-200 dark:border-slate-800 shadow-2xl relative overflow-hidden">
        {/* Brand Header */}
        <div className="text-center mb-6">
          <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-indigo-600 to-violet-600 flex items-center justify-center text-white mx-auto shadow-md mb-3">
            <GraduationCap className="w-6 h-6" />
          </div>
          <h2 className="text-xl font-black text-slate-900 dark:text-white tracking-tight">
            Pendaftaran Anggota Perpustakaan
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
            Khusus Siswa / Anggota Sekolah Terdaftar
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3.5">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                NISN Siswa *
              </label>
              <input
                type="text"
                required
                maxLength={10}
                placeholder="006xxxxxxx"
                value={formData.nisn}
                onChange={(e) => setFormData({ ...formData, nisn: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white font-mono"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Username Login *
              </label>
              <input
                type="text"
                required
                placeholder="username_siswa"
                value={formData.username}
                onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Nama Lengkap Siswa *
            </label>
            <input
              type="text"
              required
              placeholder="Sesuai rapor sekolah"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Kelas *
              </label>
              <input
                type="text"
                required
                placeholder="Contoh: XII RPL 1"
                value={formData.kelas}
                onChange={(e) => setFormData({ ...formData, kelas: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Jurusan / Konsentrasi *
              </label>
              <input
                type="text"
                required
                placeholder="Rekayasa Perangkat Lunak"
                value={formData.jurusan}
                onChange={(e) => setFormData({ ...formData, jurusan: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Email Siswa *
              </label>
              <input
                type="email"
                required
                placeholder="siswa@smk.sch.id"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
                Password Akun *
              </label>
              <input
                type="password"
                required
                placeholder="Minimal 3 karakter"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                className="w-full px-3.5 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white"
              />
            </div>
          </div>

          <div className="pt-2">
            <button
              type="submit"
              className="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs sm:text-sm rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center justify-center gap-2"
            >
              <CheckCircle2 className="w-4 h-4" /> Daftar Sebagai Anggota
            </button>
          </div>
        </form>

        <div className="mt-5 pt-3 border-t border-slate-100 dark:border-slate-800 text-center">
          <button
            type="button"
            onClick={onSwitchToLogin}
            className="inline-flex items-center gap-1.5 text-xs font-bold text-slate-600 dark:text-slate-400 hover:text-indigo-600"
          >
            <ArrowLeft className="w-3.5 h-3.5" /> Kembali ke Halaman Login
          </button>
        </div>
      </div>
    </div>
  );
};
