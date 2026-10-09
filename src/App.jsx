import React, { useState, useEffect } from 'react';
import { initStorage, resetAllDataToDefault } from './services/storage';
import { authService } from './services/authService';
import { transactionService } from './services/transactionService';

// Layout & Global Components
import { Navbar } from './components/Navbar';
import { Sidebar } from './components/Sidebar';
import { MobileBottomNav } from './components/MobileBottomNav';
import { Toast } from './components/Toast';
import { ConfirmDialog } from './components/ConfirmDialog';

// Auth Pages
import { Login } from './pages/auth/Login';
import { Register } from './pages/auth/Register';

// Petugas Pages
import { PetugasDashboard } from './pages/petugas/PetugasDashboard';
import { KelolaBuku } from './pages/petugas/KelolaBuku';
import { KelolaAnggota } from './pages/petugas/KelolaAnggota';
import { SirkulasiTransaksi } from './pages/petugas/SirkulasiTransaksi';
import { LaporanRekapitulasi } from './pages/petugas/LaporanRekapitulasi';

// Anggota Pages
import { AnggotaDashboard } from './pages/anggota/AnggotaDashboard';
import { KatalogBuku } from './pages/anggota/KatalogBuku';
import { PeminjamanSaya } from './pages/anggota/PeminjamanSaya';
import { ProfilAnggota } from './pages/anggota/ProfilAnggota';

export default function App() {
  // Initialize storage once
  useEffect(() => {
    initStorage();
  }, []);

  // Auth & User State
  const [currentUser, setCurrentUser] = useState(() => {
    initStorage();
    const stored = authService.getCurrentUser();
    // Default to 'petugas' for convenient first impression
    if (!stored) {
      const defaultOfficer = authService.switchRoleQuickDemo('petugas');
      return defaultOfficer;
    }
    return stored;
  });

  const [authView, setAuthView] = useState('login'); // 'login' | 'register'
  const [activeTab, setActiveTab] = useState('dashboard');
  const [theme, setTheme] = useState(() => localStorage.getItem('simperpus_theme') || 'light');
  const [isMobileSimulator, setIsMobileSimulator] = useState(false);
  const [toast, setToast] = useState(null);
  const [isResetConfirmOpen, setIsResetConfirmOpen] = useState(false);

  // Sync theme
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('simperpus_theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  };

  const showToast = ({ type = 'info', message }) => {
    setToast({ type, message });
    setTimeout(() => {
      setToast(null);
    }, 4000);
  };

  const handleResetData = () => {
    resetAllDataToDefault();
    const freshUser = authService.switchRoleQuickDemo(currentUser?.role || 'petugas');
    setCurrentUser(freshUser);
    setActiveTab('dashboard');
    showToast({
      type: 'success',
      message: 'Semua data buku, sirkulasi & denda telah dikembalikan ke kondisi awal!'
    });
  };

  // Count overdue transactions for badges
  const transactions = transactionService.getAllTransactions();
  const overdueCount = currentUser?.role === 'petugas'
    ? transactions.filter((t) => t.status === 'Terlambat').length
    : transactions.filter((t) => t.memberNisn === currentUser?.nisn && t.status === 'Terlambat').length;

  return (
    <div className={`min-h-screen ${isMobileSimulator ? 'bg-slate-200 dark:bg-slate-950 py-4 sm:py-8 px-2 flex justify-center items-center' : 'bg-slate-50 dark:bg-slate-950'}`}>
      {/* Container - Normal Desktop or Smartphone Simulator Frame */}
      <div className={isMobileSimulator ? 'mobile-device-frame shadow-2xl' : 'min-h-screen flex flex-col'}>
        {/* Notch on Smartphone Simulator */}
        {isMobileSimulator && (
          <div className="mobile-notch">
            <div className="mobile-notch-camera"></div>
            <div className="mobile-notch-speaker"></div>
          </div>
        )}

        {/* Global Navigation Bar */}
        <Navbar
          currentUser={currentUser}
          onUserChange={(usr) => {
            setCurrentUser(usr);
            setActiveTab('dashboard');
          }}
          theme={theme}
          onToggleTheme={toggleTheme}
          isMobileSimulator={isMobileSimulator}
          onToggleMobileSimulator={() => setIsMobileSimulator(!isMobileSimulator)}
          onResetData={() => setIsResetConfirmOpen(true)}
          showToast={showToast}
        />

        {/* Main Content Area */}
        {!currentUser ? (
          /* Auth View (Login / Register) */
          <main className="flex-1 w-full p-4 sm:p-6 lg:p-8 flex items-center justify-center">
            {authView === 'login' ? (
              <Login
                onLoginSuccess={(usr) => {
                  setCurrentUser(usr);
                  setActiveTab('dashboard');
                }}
                onSwitchToRegister={() => setAuthView('register')}
                showToast={showToast}
              />
            ) : (
              <Register
                onRegisterSuccess={(usr) => {
                  setCurrentUser(usr);
                  setActiveTab('dashboard');
                }}
                onSwitchToLogin={() => setAuthView('login')}
                showToast={showToast}
              />
            )}
          </main>
        ) : (
          /* Authenticated View */
          <div className="flex-1 flex flex-col md:flex-row w-full max-w-7xl mx-auto">
            {/* Desktop Sidebar (Only visible when NOT in mobile simulator and viewport >= md) */}
            {!isMobileSimulator && (
              <div className="hidden md:block">
                <Sidebar
                  activeTab={activeTab}
                  onTabChange={(tab) => setActiveTab(tab)}
                  role={currentUser.role}
                  overdueCount={overdueCount}
                />
              </div>
            )}

            {/* Main Application Pages */}
            <main className="flex-1 p-3 sm:p-6 lg:p-8 overflow-y-auto w-full pb-20 md:pb-8">
              {currentUser.role === 'petugas' ? (
                /* Petugas Pages */
                <>
                  {activeTab === 'dashboard' && (
                    <PetugasDashboard
                      onNavigate={(tab) => setActiveTab(tab)}
                      onOpenPinjamModal={() => setActiveTab('sirkulasi')}
                    />
                  )}
                  {activeTab === 'buku' && <KelolaBuku showToast={showToast} />}
                  {activeTab === 'anggota' && <KelolaAnggota showToast={showToast} />}
                  {activeTab === 'sirkulasi' && <SirkulasiTransaksi showToast={showToast} />}
                  {activeTab === 'laporan' && <LaporanRekapitulasi showToast={showToast} />}
                </>
              ) : (
                /* Siswa / Anggota Pages */
                <>
                  {activeTab === 'dashboard' && (
                    <AnggotaDashboard
                      currentUser={currentUser}
                      onNavigate={(tab) => setActiveTab(tab)}
                      onOpenBookDetail={() => setActiveTab('katalog')}
                    />
                  )}
                  {activeTab === 'katalog' && (
                    <KatalogBuku
                      currentUser={currentUser}
                      showToast={showToast}
                      onLoanSuccess={() => setActiveTab('peminjaman_saya')}
                    />
                  )}
                  {activeTab === 'peminjaman_saya' && (
                    <PeminjamanSaya currentUser={currentUser} showToast={showToast} />
                  )}
                  {activeTab === 'profil' && (
                    <ProfilAnggota currentUser={currentUser} showToast={showToast} />
                  )}
                </>
              )}
            </main>
          </div>
        )}

        {/* Mobile Bottom Navigation Bar (Visible in mobile simulator OR on real mobile screens < md) */}
        {currentUser && (
          <div className={isMobileSimulator ? 'block' : 'block md:hidden'}>
            <MobileBottomNav
              activeTab={activeTab}
              onTabChange={(tab) => setActiveTab(tab)}
              role={currentUser.role}
              overdueCount={overdueCount}
            />
          </div>
        )}

        {/* Global Toast Notification */}
        <Toast toast={toast} onClose={() => setToast(null)} />

        {/* Reset Confirmation Dialog */}
        <ConfirmDialog
          isOpen={isResetConfirmOpen}
          onClose={() => setIsResetConfirmOpen(false)}
          onConfirm={handleResetData}
          title="Reset Semua Data ke Kondisi Awal"
          message="Apakah Anda ingin mengembalikan seluruh data buku, sirkulasi transaksi, denda, dan anggota ke data awal uji coba UKK?"
          confirmText="Ya, Reset Data"
          type="danger"
        />
      </div>
    </div>
  );
}
