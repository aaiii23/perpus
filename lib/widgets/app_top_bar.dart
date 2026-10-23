import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'confirm_dialog.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel? currentUser;
  final VoidCallback onDataChanged;
  final VoidCallback onThemeToggled;
  final VoidCallback onLoggedOut;

  const AppTopBar({
    super.key,
    required this.currentUser,
    required this.onDataChanged,
    required this.onThemeToggled,
    required this.onLoggedOut,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  Future<void> _handleSwitchRole(BuildContext context, String role) async {
    final auth = AuthService();
    final updated = await auth.switchRoleQuickDemo(role);
    if (updated != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Beralih ke peran: ${updated.role.toUpperCase()} (${updated.name})'),
          backgroundColor: const Color(0xFF4F46E5),
        ),
      );
      onDataChanged();
    }
  }

  Future<void> _handleResetData(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Reset Semua Data ke Kondisi Awal',
      message:
          'Apakah Anda ingin mengembalikan seluruh data buku, sirkulasi transaksi, denda, dan anggota ke data awal pengujian UKK?',
      confirmText: 'Ya, Reset Data',
      isDanger: true,
    );

    if (confirmed == true && context.mounted) {
      await StorageService().resetAllDataToDefault();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil di-reset ke kondisi awal pengujian UKK!'),
          backgroundColor: Colors.green,
        ),
      );
      onDataChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    'SIMPERPUS',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'UKK RPL',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Perpustakaan Digital SMK',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (currentUser != null) ...[
          // Quick Role Switcher Button
          PopupMenuButton<String>(
            tooltip: 'Ganti Peran Demo',
            onSelected: (role) => _handleSwitchRole(context, role),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'petugas',
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 18,
                      color: currentUser?.role == 'petugas'
                          ? const Color(0xFF4F46E5)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Text('Petugas Perpustakaan', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'anggota',
                child: Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: 18,
                      color: currentUser?.role == 'anggota'
                          ? const Color(0xFF4F46E5)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Text('Siswa (Anggota)', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    currentUser?.role == 'petugas'
                        ? Icons.admin_panel_settings_rounded
                        : Icons.school_rounded,
                    size: 16,
                    color: const Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currentUser?.role == 'petugas' ? 'Petugas' : 'Siswa',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF4F46E5)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],

        // Dark / Light Mode Toggle
        IconButton(
          tooltip: 'Ganti Tema',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 20,
            color: isDark ? Colors.amber : const Color(0xFF475569),
          ),
          onPressed: onThemeToggled,
        ),

        // Reset Demo Data
        IconButton(
          tooltip: 'Reset Data Uji Coba UKK',
          icon: const Icon(
            Icons.restart_alt_rounded,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
          onPressed: () => _handleResetData(context),
        ),

        // Logout Button
        if (currentUser != null)
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Konfirmasi Keluar',
                message: 'Apakah Anda yakin ingin keluar dari sistem perpustakaan?',
                confirmText: 'Ya, Keluar',
                isDanger: true,
              );
              if (confirmed == true) {
                await AuthService().logout();
                onLoggedOut();
              }
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
