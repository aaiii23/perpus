import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/transaction_service.dart';
import '../../services/member_service.dart';
import '../../widgets/app_top_bar.dart';
import 'tabs/anggota_dashboard_tab.dart';
import 'tabs/katalog_buku_tab.dart';
import 'tabs/peminjaman_saya_tab.dart';
import 'tabs/profil_anggota_tab.dart';

class AnggotaMainScreen extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback onThemeToggled;
  final VoidCallback onLoggedOut;
  final VoidCallback onDataChanged;

  const AnggotaMainScreen({
    super.key,
    required this.currentUser,
    required this.onThemeToggled,
    required this.onLoggedOut,
    required this.onDataChanged,
  });

  @override
  State<AnggotaMainScreen> createState() => _AnggotaMainScreenState();
}

class _AnggotaMainScreenState extends State<AnggotaMainScreen> {
  int _currentIndex = 0;
  final _transactionService = TransactionService();
  final _memberService = MemberService();

  void _onDataChanged() {
    setState(() {});
    widget.onDataChanged();
  }

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '');
    final studentNisn = member?.nisn ?? widget.currentUser.nisn ?? '';

    final overdueCount = _transactionService.getAllTransactions().where(
          (t) => (t.memberNisn == studentNisn || t.memberName == widget.currentUser.name) && t.status == 'Terlambat',
        ).length;

    final tabs = [
      AnggotaDashboardTab(
        currentUser: widget.currentUser,
        onNavigateTab: _navigateToTab,
        onDataChanged: _onDataChanged,
      ),
      KatalogBukuTab(
        currentUser: widget.currentUser,
        onNavigateTab: _navigateToTab,
        onDataChanged: _onDataChanged,
      ),
      PeminjamanSayaTab(
        currentUser: widget.currentUser,
        onDataChanged: _onDataChanged,
      ),
      ProfilAnggotaTab(
        currentUser: widget.currentUser,
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: overdueCount > 0,
              label: Text('$overdueCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.history_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: overdueCount > 0,
              label: Text('$overdueCount'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.history_rounded),
            ),
            label: 'Pinjaman',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
