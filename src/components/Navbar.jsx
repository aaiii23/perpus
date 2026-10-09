import React from 'react';
import {
  BookOpen,
  Sun,
  Moon,
  Smartphone,
  Monitor,
  RotateCcw,
  LogOut,
  UserCheck,
  Shield,
  GraduationCap
} from 'lucide-react';
import { authService } from '../services/authService';

export const Navbar = ({
  currentUser,
  onUserChange,
  theme,
  onToggleTheme,
  isMobileSimulator,
  onToggleMobileSimulator,
  onResetData,
  showToast
}) => {
  const handleQuickSwitchRole = (role) => {
    const newUser = authService.switchRoleQuickDemo(role);
    if (newUser) {
      onUserChange(newUser);
      showToast({
        type: 'info',
        message: `Beralih ke mode akun: ${newUser.role.toUpperCase()} (${newUser.name})`
      });
    }
  };

  const handleLogout = () => {
    authService.logout();
    onUserChange(null);
    showToast({
      type: 'info',
      message: 'Anda telah keluar dari sistem'
    });
  };

  return (
    <header className="sticky top-0 z-40 bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 transition-colors no-print">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-4">
        {/* Brand Logo */}
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-indigo-600 to-violet-500 flex items-center justify-center text-white shadow-md shadow-indigo-500/20">
            <BookOpen className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-extrabold text-base sm:text-lg tracking-tight bg-gradient-to-r from-indigo-600 to-violet-600 bg-clip-text text-transparent dark:from-indigo-400 dark:to-violet-400">
                SIMPERPUS
              </span>
              <span className="hidden sm:inline-block px-2 py-0.5 text-[10px] font-bold bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300 rounded-full uppercase tracking-wider">
                UKK RPL KM25
              </span>
            </div>
            <p className="text-[11px] text-slate-500 dark:text-slate-400 hidden sm:block">
              Perpustakaan Digital Sekolah Terpadu
            </p>
          </div>
        </div>

        {/* Action Controls */}
        <div className="flex items-center gap-2 sm:gap-3">
          {/* Quick Role Switcher for Demo / Exam */}
          <div className="hidden md:flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-xl border border-slate-200 dark:border-slate-700">
            <button
              type="button"
              onClick={() => handleQuickSwitchRole('petugas')}
              className={`flex items-center gap-1.5 px-3 py-1 text-xs font-semibold rounded-lg transition ${
                currentUser?.role === 'petugas'
                  ? 'bg-indigo-600 text-white shadow-sm'
                  : 'text-slate-600 dark:text-slate-300 hover:text-slate-900'
              }`}
            >
              <Shield className="w-3.5 h-3.5" /> Petugas
            </button>
            <button
              type="button"
              onClick={() => handleQuickSwitchRole('anggota')}
              className={`flex items-center gap-1.5 px-3 py-1 text-xs font-semibold rounded-lg transition ${
                currentUser?.role === 'anggota'
                  ? 'bg-indigo-600 text-white shadow-sm'
                  : 'text-slate-600 dark:text-slate-300 hover:text-slate-900'
              }`}
            >
              <GraduationCap className="w-3.5 h-3.5" /> Siswa (Anggota)
            </button>
          </div>

          {/* Mobile Simulator View Toggle (Crucial for UKK Pemrograman Mobile assessment) */}
          <button
            type="button"
            onClick={onToggleMobileSimulator}
            title={isMobileSimulator ? 'Beralih ke Tampilan Desktop Penuh' : 'Simulasikan Tampilan Aplikasi Mobile'}
            className={`p-2 rounded-xl border text-xs font-medium flex items-center gap-1.5 transition ${
              isMobileSimulator
                ? 'bg-indigo-50 border-indigo-300 text-indigo-700 dark:bg-indigo-950/60 dark:border-indigo-700 dark:text-indigo-300'
                : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50'
            }`}
          >
            {isMobileSimulator ? (
              <>
                <Monitor className="w-4 h-4 text-indigo-600 dark:text-indigo-400" />
                <span className="hidden lg:inline">Mode Desktop</span>
              </>
            ) : (
              <>
                <Smartphone className="w-4 h-4 text-slate-500" />
                <span className="hidden lg:inline">Simulasi Mobile</span>
              </>
            )}
          </button>

          {/* Theme Toggle */}
          <button
            type="button"
            onClick={onToggleTheme}
            className="p-2 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 transition"
            title="Ganti Tema (Gelap/Terang)"
          >
            {theme === 'dark' ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-600" />}
          </button>

          {/* Reset Demo Data Button */}
          <button
            type="button"
            onClick={onResetData}
            title="Reset Data Uji Coba Default"
            className="p-2 text-slate-500 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-xl border border-slate-200 dark:border-slate-700 transition"
          >
            <RotateCcw className="w-4 h-4" />
          </button>

          {/* User Profile Pill & Logout */}
          {currentUser && (
            <div className="flex items-center gap-2 pl-2 border-l border-slate-200 dark:border-slate-700">
              <img
                src={currentUser.avatar || 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150'}
                alt={currentUser.name}
                className="w-8 h-8 rounded-full object-cover border border-indigo-400 shadow-sm"
              />
              <div className="hidden xl:block text-left">
                <div className="text-xs font-bold text-slate-800 dark:text-slate-200 leading-tight truncate max-w-[120px]">
                  {currentUser.name}
                </div>
                <div className="text-[10px] text-slate-400 capitalize">
                  {currentUser.role}
                </div>
              </div>

              <button
                type="button"
                onClick={handleLogout}
                title="Keluar"
                className="p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-xl transition"
              >
                <LogOut className="w-4 h-4" />
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};
