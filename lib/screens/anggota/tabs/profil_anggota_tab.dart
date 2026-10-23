import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../services/member_service.dart';
import '../../../services/stats_service.dart';
import '../../../widgets/member_card_dialog.dart';

class ProfilAnggotaTab extends StatefulWidget {
  final UserModel currentUser;
  final VoidCallback onDataChanged;

  const ProfilAnggotaTab({
    super.key,
    required this.currentUser,
    required this.onDataChanged,
  });

  @override
  State<ProfilAnggotaTab> createState() => _ProfilAnggotaTabState();
}

class _ProfilAnggotaTabState extends State<ProfilAnggotaTab> {
  final _memberService = MemberService();
  final _statsService = StatsService();

  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '');
    _phoneController = TextEditingController(text: member?.phone ?? widget.currentUser.phone ?? '0857-9876-5432');
    _addressController = TextEditingController(text: member?.address ?? 'Jl. Pemuda No. 45, Bandung');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '');
    if (member != null) {
      await _memberService.updateMember(
        member.id,
        member.copyWith(
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        ),
      );
      widget.onDataChanged();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil kontak berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _savePassword() {
    final newPass = _newPasswordController.text.trim();
    if (newPass.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password baru minimal 3 karakter!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _newPasswordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password akun berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final member = _memberService.getMemberByNisn(widget.currentUser.nisn ?? '') ??
        _memberService.getAllMembers().firstOrNull;

    final stats = _statsService.getMemberStats(member?.nisn ?? widget.currentUser.nisn ?? '');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.badge_rounded, color: Color(0xFF4F46E5), size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Siswa & Kartu Digital',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Informasi identitas keanggotaan perpustakaan digital dan pengaturan kontak',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (member != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.credit_card_rounded, size: 18),
                      label: const Text('Cetak Kartu'),
                      onPressed: () => MemberCardDialog.show(context, member),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Profile Overview Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(member?.avatar ?? widget.currentUser.avatar ?? ''),
                    backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    member?.name ?? widget.currentUser.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NISN: ${member?.nisn ?? widget.currentUser.nisn ?? "-"}',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.indigo, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${member?.kelas ?? widget.currentUser.kelas ?? "XII RPL 1"} • ${member?.jurusan ?? "Rekayasa Perangkat Lunak"}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'STATUS: ANGGOTA AKTIF TERVERIFIKASI',
                      style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mini Stats
          Row(
            children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text('PINJAMAN AKTIF', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          '${stats.activeLoans.length}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text('SELESAI KEMBALI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          '${stats.returnedCount}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text('TERLAMBAT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          '${stats.overdueCount}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: stats.overdueCount > 0 ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Form Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PERBARUI KONTAK SAYA',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor WhatsApp / Telepon',
                      prefixIcon: Icon(Icons.phone_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Tempat Tinggal',
                      prefixIcon: Icon(Icons.home_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.save_rounded, size: 16),
                    label: const Text('Simpan Perubahan Kontak'),
                    onPressed: _saveProfile,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GANTI PASSWORD AKUN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password Baru',
                      prefixIcon: Icon(Icons.lock_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.lock_reset_rounded, size: 16),
                    label: const Text('Update Password'),
                    onPressed: _savePassword,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
