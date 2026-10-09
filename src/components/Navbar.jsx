import React, { useState } from 'react';
import {
  BookOpen,
  Sun,
  Moon,
  Smartphone,
  Monitor,
  RotateCcw,
  LogOut,
  Shield,
  GraduationCap,
  ChevronDown
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
  const [isRoleDropdownOpen, setIsRoleDropdownOpen] = useState(false);

  const handleQuickSwitchRole = (role) => {
    const newUser = authService.switchRoleQuickDemo(role);
    if (newUser) {
      onUserChange(newUser);
      setIsRoleDropdownOpen(false);
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
    <header className="sticky top-0 z-50 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 transition-colors no-print">
      <div className="max-w-7xl mx-auto px-3 sm:px-6 lg:px-8 py-2.5 flex items-center justify-between gap-2">
        {/* Brand Logo & App Name */}
        <div className="flex items-center gap-2.5 min-w-0">
          <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-600 to-violet-500 flex items-center justify-center text-white shadow-md shadow-indigo-500/20 flex-shrink-0">
            <BookOpen className="w-5 h-5" />
          </div>
          <div className="min-w-0">
            <div className="flex items-center gap-1.5">
              <span className="font-extrabold text-sm sm:text-base tracking-tight bg-gradient-to-r from-indigo-600 to-violet-600 bg-clip-text text-transparent dark:from-indigo-400 dark:to-violet-400 truncate">
                SIMPERPUS
              </span>
              <span className="hidden md:inline-block px-1.5 py-0.5 text-[9px] font-bold bg-indigo-100 text-indigo-700 dark:bg-indigo-950 dark:text-indigo-300 rounded-full uppercase">
                UKK RPL
              </span>
            </div>
            <p className="text-[10px] text-slate-400 hidden sm:block truncate">
              Perpustakaan Digital SMK
            </p>
          </div>
        </div>

        {/* Action Controls */}
        <div className="flex items-center gap-1.5 sm:gap-2 flex-shrink-0">
          {/* Role Switcher Pill / Dropdown */}
          {currentUser && (
            <div className="relative">
              {/* Desktop view role switcher */}
              <div className="hidden lg:flex items-center bg-slate-100 dark:bg-slate-800 p-1 rounded-xl border border-slate-200 dark:border-slate-700 text-xs">
                <button
                  type="button"
                  onClick={() => handleQuickSwitchRole('petugas')}
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-lg font-semibold transition ${
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
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-lg font-semibold transition ${
                    currentUser?.role === 'anggota'
                      ? 'bg-indigo-600 text-white shadow-sm'
                      : 'text-slate-600 dark:text-slate-300 hover:text-slate-900'
                  }`}
                >
                  <GraduationCap className="w-3.5 h-3.5" /> Siswa
                </button>
              </div>

              {/* Mobile compact role switch pill */}
              <button
                type="button"
                onClick={() => setIsRoleDropdownOpen(!isRoleDropdownOpen)}
                className="lg:hidden flex items-center gap-1 px-2.5 py-1.5 bg-indigo-50 dark:bg-indigo-950/70 text-indigo-700 dark:text-indigo-300 border border-indigo-200 dark:border-indigo-800 rounded-xl text-xs font-bold transition"
              >
                {currentUser?.role === 'petugas' ? (
                  <Shield className="w-3.5 h-3.5" />
                ) : (
                  <GraduationCap className="w-3.5 h-3.5" />
                )}
                <span className="capitalize">{currentUser?.role}</span>
                <ChevronDown className="w-3 h-3 ml-0.5" />
              </button>

              {/* Mobile Role Dropdown */}
              {isRoleDropdownOpen && (
                <div className="lg:hidden absolute right-0 mt-2 w-44 bg-white dark:bg-slate-800 rounded-2xl shadow-xl border border-slate-200 dark:border-slate-700 py-1 z-50 animate-fade-in">
                  <div className="px-3 py-1.5 text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                    Ganti Peran Demo:
                  </div>
                  <button
                    type="button"
                    onClick={() => handleQuickSwitchRole('petugas')}
                    className={`w-full text-left px-3 py-2 text-xs font-semibold flex items-center gap-2 hover:bg-slate-50 dark:hover:bg-slate-700 ${
                      currentUser?.role === 'petugas' ? 'text-indigo-600 dark:text-indigo-400' : 'text-slate-700 dark:text-slate-300'
                    }`}
                  >
                    <Shield className="w-4 h-4" /> Petugas Perpustakaan
                  </button>
                  <button
                    type="button"
                    onClick={() => handleQuickSwitchRole('anggota')}
                    className={`w-full text-left px-3 py-2 text-xs font-semibold flex items-center gap-2 hover:bg-slate-50 dark:hover:bg-slate-700 ${
                      currentUser?.role === 'anggota' ? 'text-indigo-600 dark:text-indigo-400' : 'text-slate-700 dark:text-slate-300'
                    }`}
                  >
                    <GraduationCap className="w-4 h-4" /> Siswa (Anggota)
                  </button>
                </div>
              )}
            </div>
          )}

          {/* Toggle Device Simulator (Desktop vs Mobile Frame) */}
          <button
            type="button"
            onClick={onToggleMobileSimulator}
            title={isMobileSimulator ? 'Tampilan Desktop Penuh' : 'Simulasi Layar HP'}
            className={`p-1.5 sm:p-2 rounded-xl border text-xs font-semibold flex items-center gap-1 transition ${
              isMobileSimulator
                ? 'bg-indigo-600 text-white border-indigo-600 shadow-sm'
                : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-50'
            }`}
          >
            {isMobileSimulator ? (
              <>
                <Monitor className="w-4 h-4" />
                <span className="hidden sm:inline">Desktop</span>
              </>
            ) : (
              <>
                <Smartphone className="w-4 h-4 text-indigo-600 dark:text-indigo-400" />
                <span className="hidden sm:inline">Mode HP</span>
              </>
            )}
          </button>

          {/* Theme Toggle */}
          <button
            type="button"
            onClick={onToggleTheme}
            className="p-1.5 sm:p-2 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 transition"
            title="Ganti Tema (Gelap/Terang)"
          >
            {theme === 'dark' ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-600" />}
          </button>

          {/* Reset Demo Data Button */}
          <button
            type="button"
            onClick={onResetData}
            title="Reset Data Uji Coba Default"
            className="p-1.5 sm:p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-xl border border-slate-200 dark:border-slate-700 transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
          </button>

          {/* Logout Button */}
          {currentUser && (
            <button
              type="button"
              onClick={handleLogout}
              title="Keluar"
              className="p-1.5 sm:p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 rounded-xl transition"
            >
              <LogOut className="w-4 h-4" />
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
