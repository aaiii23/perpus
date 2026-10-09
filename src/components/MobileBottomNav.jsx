import React from 'react';
import {
  LayoutDashboard,
  BookMarked,
  Users,
  Repeat,
  FileBarChart2,
  BookOpen,
  Clock,
  User
} from 'lucide-react';

export const MobileBottomNav = ({ activeTab, onTabChange, role, overdueCount = 0 }) => {
  const petugasMenu = [
    { id: 'dashboard', label: 'Dashboard', icon: <LayoutDashboard className="w-5 h-5" /> },
    { id: 'buku', label: 'Buku', icon: <BookMarked className="w-5 h-5" /> },
    { id: 'anggota', label: 'Anggota', icon: <Users className="w-5 h-5" /> },
    {
      id: 'sirkulasi',
      label: 'Sirkulasi',
      icon: <Repeat className="w-5 h-5" />,
      badge: overdueCount > 0 ? overdueCount : null
    },
    { id: 'laporan', label: 'Laporan', icon: <FileBarChart2 className="w-5 h-5" /> }
  ];

  const anggotaMenu = [
    { id: 'dashboard', label: 'Beranda', icon: <LayoutDashboard className="w-5 h-5" /> },
    { id: 'katalog', label: 'Katalog', icon: <BookOpen className="w-5 h-5" /> },
    {
      id: 'peminjaman_saya',
      label: 'Pinjaman',
      icon: <Clock className="w-5 h-5" />,
      badge: overdueCount > 0 ? overdueCount : null
    },
    { id: 'profil', label: 'Profil', icon: <User className="w-5 h-5" /> }
  ];

  const menu = role === 'petugas' ? petugasMenu : anggotaMenu;

  return (
    <div className="sticky bottom-0 left-0 right-0 z-40 bg-white/95 dark:bg-slate-900/95 backdrop-blur-lg border-t border-slate-200 dark:border-slate-800 px-2 py-1.5 shadow-lg no-print">
      <div className="flex items-center justify-around">
        {menu.map((item) => {
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              type="button"
              onClick={() => onTabChange(item.id)}
              className={`flex flex-col items-center justify-center py-1 px-2 rounded-xl transition relative min-w-[56px] ${
                isActive
                  ? 'text-indigo-600 dark:text-indigo-400 font-bold'
                  : 'text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 font-medium'
              }`}
            >
              <div className="relative">
                {item.icon}
                {item.badge && (
                  <span className="absolute -top-1 -right-2 bg-rose-500 text-white text-[9px] font-bold w-4 h-4 rounded-full flex items-center justify-center shadow-sm animate-pulse">
                    {item.badge}
                  </span>
                )}
              </div>
              <span className="text-[10px] mt-0.5 tracking-tight">{item.label}</span>
              {isActive && (
                <span className="w-1.5 h-1.5 rounded-full bg-indigo-600 dark:bg-indigo-400 mt-0.5"></span>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};
