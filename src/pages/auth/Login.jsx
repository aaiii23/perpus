import React, { useState } from 'react';
import {
  BookOpen,
  Lock,
  User,
  Shield,
  GraduationCap,
  ArrowRight,
  Sparkles,
  KeyRound
} from 'lucide-react';
import { authService } from '../../services/authService';

export const Login = ({ onLoginSuccess, onSwitchToRegister, showToast }) => {
  const [username, setUsername] = useState('petugas');
  const [password, setPassword] = useState('123');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const user = authService.login(username, password);
      showToast({
        type: 'success',
        message: `Selamat datang kembali, ${user.name}! (${user.role.toUpperCase()})`
      });
      onLoginSuccess(user);
    } catch (err) {
      showToast({ type: 'error', message: err.message });
    } finally {
      setIsLoading(false);
    }
  };

  const handleQuickLogin = (role) => {
    if (role === 'petugas') {
      setUsername('petugas');
      setPassword('123');
      const user = authService.login('petugas', '123');
      onLoginSuccess(user);
      showToast({ type: 'success', message: 'Masuk sebagai Petugas Perpustakaan' });
    } else {
      setUsername('siswa');
      setPassword('123');
      const user = authService.login('siswa', '123');
      onLoginSuccess(user);
      showToast({ type: 'success', message: 'Masuk sebagai Anggota Siswa (Ahmad Faiz)' });
    }
  };

  return (
    <div className="min-h-[85vh] flex items-center justify-center p-4">
      <div className="w-full max-w-md bg-white dark:bg-slate-900 rounded-3xl p-8 border border-slate-200 dark:border-slate-800 shadow-2xl relative overflow-hidden">
        {/* Glow backdrop */}
        <div className="absolute -top-24 -right-24 w-48 h-48 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>

        {/* Brand Header */}
        <div className="text-center mb-8">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-indigo-600 to-violet-600 flex items-center justify-center text-white mx-auto shadow-lg shadow-indigo-600/30 mb-4 animate-float">
            <BookOpen className="w-7 h-7" />
          </div>
          <h2 className="text-2xl font-black text-slate-900 dark:text-white tracking-tight">
            SIMPERPUS Digital
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
            Sistem Informasi Perpustakaan Terpadu SMK
          </p>
        </div>

        {/* 1-Click Quick Demo Login for UKK Exam */}
        <div className="mb-6 p-3.5 bg-slate-50 dark:bg-slate-800/80 rounded-2xl border border-slate-200/80 dark:border-slate-700/80">
          <div className="text-[11px] font-bold text-slate-400 uppercase tracking-wider text-center mb-2">
            ⚡ Quick Demo Login (Penguji / Siswa)
          </div>
          <div className="grid grid-cols-2 gap-2">
            <button
              type="button"
              onClick={() => handleQuickLogin('petugas')}
              className="py-2 px-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm"
            >
              <Shield className="w-3.5 h-3.5" /> Petugas
            </button>
            <button
              type="button"
              onClick={() => handleQuickLogin('siswa')}
              className="py-2 px-3 bg-white dark:bg-slate-700 text-slate-800 dark:text-white border border-slate-200 dark:border-slate-600 hover:bg-slate-50 rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm"
            >
              <GraduationCap className="w-3.5 h-3.5 text-indigo-500" /> Siswa (Anggota)
            </button>
          </div>
        </div>

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Username atau Email
            </label>
            <div className="relative">
              <User className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="text"
                required
                placeholder="petugas / siswa"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500 font-medium"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1">
              Kata Sandi (Password)
            </label>
            <div className="relative">
              <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
              <input
                type="password"
                required
                placeholder="123"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-extrabold text-xs sm:text-sm rounded-xl shadow-lg shadow-indigo-600/30 transition flex items-center justify-center gap-2 mt-2"
          >
            Masuk ke Sistem <ArrowRight className="w-4 h-4" />
          </button>
        </form>

        {/* Switch to Register */}
        <div className="mt-6 pt-4 border-t border-slate-100 dark:border-slate-800 text-center text-xs text-slate-500 dark:text-slate-400">
          Belum terdaftar sebagai anggota?{' '}
          <button
            type="button"
            onClick={onSwitchToRegister}
            className="font-bold text-indigo-600 dark:text-indigo-400 hover:underline"
          >
            Daftar Akun Siswa Baru
          </button>
        </div>
      </div>
    </div>
  );
};
