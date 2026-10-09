import React from 'react';
import {
  LayoutDashboard,
  BookMarked,
  Users,
  Repeat,
  FileBarChart2,
  BookOpen,
  Clock,
  User,
  AlertCircle
} from 'lucide-react';

export const Sidebar = ({ activeTab, onTabChange, role, overdueCount = 0 }) => {
  const petugasMenu = [
    {
      id: 'dashboard',
      label: 'Dashboard Petugas',
      icon: <LayoutDashboard className="w-4 h-4" />
    },
    {
      id: 'buku',
      label: 'Kelola Data Buku',
      icon: <BookMarked className="w-4 h-4" />
    },
    {
      id: 'anggota',
      label: 'Kelola Anggota',
      icon: <Users className="w-4 h-4" />
    },
    {
      id: 'sirkulasi',
      label: 'Sirkulasi Transaksi',
      icon: <Repeat className="w-4 h-4" />,
      badge: overdueCount > 0 ? `${overdueCount} Terlambat` : null
    },
    {
      id: 'laporan',
      label: 'Laporan Rekapitulasi',
      icon: <FileBarChart2 className="w-4 h-4" />
    }
  ];

  const anggotaMenu = [
    {
      id: 'dashboard',
      label: 'Beranda Siswa',
      icon: <LayoutDashboard className="w-4 h-4" />
    },
    {
      id: 'katalog',
      label: 'Katalog Buku',
      icon: <BookOpen className="w-4 h-4" />
    },
    {
      id: 'peminjaman_saya',
      label: 'Peminjaman Saya',
      icon: <Clock className="w-4 h-4" />,
      badge: overdueCount > 0 ? `${overdueCount} Jatuh Tempo` : null
    },
    {
      id: 'profil',
      label: 'Profil Saya',
      icon: <User className="w-4 h-4" />
    }
  ];

  const menu = role === 'petugas' ? petugasMenu : anggotaMenu;

  return (
    <aside className="w-full md:w-64 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 p-4 flex flex-col gap-1 transition-colors no-print">
      <div className="px-3 py-2 text-[11px] font-bold uppercase tracking-wider text-slate-400">
        Menu {role === 'petugas' ? 'Petugas Perpustakaan' : 'Anggota Perpustakaan'}
      </div>

      <nav className="space-y-1">
        {menu.map((item) => {
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              type="button"
              onClick={() => onTabChange(item.id)}
              className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-xl text-sm font-medium transition ${
                isActive
                  ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/20 font-semibold'
                  : 'text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800/60 hover:text-slate-900 dark:hover:text-slate-200'
              }`}
            >
              <div className="flex items-center gap-3">
                {item.icon}
                <span>{item.label}</span>
              </div>
              {item.badge && (
                <span
                  className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    isActive
                      ? 'bg-white text-indigo-700'
                      : 'bg-rose-100 text-rose-700 dark:bg-rose-950 dark:text-rose-300'
                  }`}
                >
                  {item.badge}
                </span>
              )}
            </button>
          );
        })}
      </nav>

      {/* Role Indicator Widget */}
      <div className="mt-auto pt-4 border-t border-slate-100 dark:border-slate-800 hidden md:block">
        <div className="p-3 bg-gradient-to-br from-indigo-50 to-violet-50 dark:from-slate-800/80 dark:to-slate-800/40 rounded-xl border border-indigo-100/50 dark:border-slate-700/60">
          <div className="text-[11px] font-semibold text-indigo-900 dark:text-indigo-300 flex items-center gap-1.5 mb-1">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            Modul UKK RPL KM25
          </div>
          <p className="text-[11px] text-slate-500 dark:text-slate-400 leading-relaxed">
            Sistem Sirkulasi & Denda Otomatis Siap Diuji.
          </p>
        </div>
      </div>
    </aside>
  );
};
