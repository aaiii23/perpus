import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/transaction_service.dart';
import '../../widgets/app_top_bar.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/kelola_buku_tab.dart';
import 'tabs/kelola_anggota_tab.dart';
import 'tabs/sirkulasi_tab.dart';
import 'tabs/laporan_tab.dart';

class PetugasMainScreen extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback onThemeToggled;
  final VoidCallback onLoggedOut;
  final VoidCallback onDataChanged;

  const PetugasMainScreen({
    super.key,
    required this.currentUser,
    required this.onThemeToggled,
    required this.onLoggedOut,
    required this.onDataChanged,
  });

  @override
  State<PetugasMainScreen> createState() => _PetugasMainScreenState();
}

class _PetugasMainScreenState extends State<PetugasMainScreen> {
  int _currentIndex = 0;
  final _transactionService = TransactionService();

  void _onDataChanged() {
    setState(() {});
    widget.onDataChanged();
  }

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _transactionService.getAllTransactions();
    final overdueCount = transactions.where((t) => t.status == 'Terlambat').length;

    final tabs = [
      DashboardTab(
        onNavigateTab: _navigateToTab,
      ),
      KelolaBukuTab(
        onDataChanged: _onDataChanged,
      ),
      KelolaAnggotaTab(
        onDataChanged: _onDataChanged,
      ),
      SirkulasiTab(
        onDataChanged: _onDataChanged,
      ),
      LaporanTab(
        onDataChanged: _onDataChanged,
      ),
    ];

    return Scaffold(
      appBar: AppTopBar(
        currentUser: widget.currentUser,
        onDataChanged: _onDataChanged,
        onThemeToggled: widget.onThemeToggled,
        onLoggedOut: widget.onLoggedOut,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Beranda',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Buku',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'Anggota',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: overdueCount > 0,
              label: Text('$overdueCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.sync_alt_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: overdueCount > 0,
              label: Text('$overdueCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.sync_alt_rounded),
            ),
            label: 'Sirkulasi',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
