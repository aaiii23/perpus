import 'package:flutter/material.dart';
import '../../../models/member_model.dart';
import '../../../services/member_service.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/member_card_dialog.dart';

class KelolaAnggotaTab extends StatefulWidget {
  final VoidCallback onDataChanged;

  const KelolaAnggotaTab({super.key, required this.onDataChanged});

  @override
  State<KelolaAnggotaTab> createState() => _KelolaAnggotaTabState();
}

class _KelolaAnggotaTabState extends State<KelolaAnggotaTab> {
  final _memberService = MemberService();
  String _searchQuery = '';
  String _selectedClass = 'Semua';

  void _refresh() {
    setState(() {});
    widget.onDataChanged();
  }

  void _openAddEditDialog({MemberModel? member}) {
    final isEdit = member != null;
    final nisnController = TextEditingController(text: member?.nisn ?? '');
    final nameController = TextEditingController(text: member?.name ?? '');
    final kelasController = TextEditingController(text: member?.kelas ?? 'XII RPL 1');
    final jurusanController = TextEditingController(text: member?.jurusan ?? 'Rekayasa Perangkat Lunak');
    final emailController = TextEditingController(text: member?.email ?? '');
    final phoneController = TextEditingController(text: member?.phone ?? '08');
    final addressController = TextEditingController(text: member?.address ?? 'Bandung, Jawa Barat');

    String selectedGender = member?.gender ?? 'Laki-laki';
    String selectedStatus = member?.status ?? 'Aktif';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480, maxHeight: 650),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Data Anggota' : 'Tambah Anggota Baru',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: nisnController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nomor NISN Siswa *',
                              hintText: '006xxxxxxx',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nama Lengkap Siswa *',
                              hintText: 'Nama lengkap...',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: kelasController,
                                  decoration: const InputDecoration(labelText: 'Kelas *'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: jurusanController,
                                  decoration: const InputDecoration(labelText: 'Jurusan *'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedGender,
                                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                                  items: ['Laki-laki', 'Perempuan'].map((g) {
                                    return DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 13)));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => selectedGender = val);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedStatus,
                                  decoration: const InputDecoration(labelText: 'Status Keanggotaan'),
                                  items: ['Aktif', 'Nonaktif'].map((s) {
                                    return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => selectedStatus = val);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Siswa',
                              hintText: 'siswa@smk.sch.id',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Nomor Telepon / WhatsApp',
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: addressController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Alamat Tinggal Siswa',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final nisn = nisnController.text.trim();
                          final name = nameController.text.trim();
                          final kelas = kelasController.text.trim();

                          if (nisn.isEmpty || name.isEmpty || kelas.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('NISN, Nama, dan Kelas wajib diisi!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            if (isEdit) {
                              final updated = member.copyWith(
                                nisn: nisn,
                                name: name,
                                kelas: kelas,
                                jurusan: jurusanController.text.trim(),
                                gender: selectedGender,
                                status: selectedStatus,
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                address: addressController.text.trim(),
                              );
                              await _memberService.updateMember(member.id, updated);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Data anggota ${updated.name} berhasil diperbarui!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } else {
                              final newMember = MemberModel(
                                id: '',
                                userId: '',
                                nisn: nisn,
                                name: name,
                                gender: selectedGender,
                                kelas: kelas,
                                jurusan: jurusanController.text.trim().isNotEmpty
                                    ? jurusanController.text.trim()
                                    : 'Rekayasa Perangkat Lunak',
                                email: emailController.text.trim().isNotEmpty
                                    ? emailController.text.trim()
                                    : '$nisn@smk.sch.id',
                                phone: phoneController.text.trim(),
                                address: addressController.text.trim(),
                                joinedDate: DateTime.now().toIso8601String().split('T')[0],
                                status: selectedStatus,
                                avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
                              );
                              await _memberService.createMember(newMember);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Anggota baru ${newMember.name} berhasil ditambahkan!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                            if (ctx.mounted) Navigator.of(ctx).pop();
                            _refresh();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(isEdit ? 'Simpan' : 'Tambah Anggota'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDeleteMember(MemberModel member) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Hapus Data Anggota',
      message: 'Apakah Anda yakin ingin menghapus data anggota "${member.name}" (NISN: ${member.nisn})?',
      confirmText: 'Ya, Hapus',
      isDanger: true,
    );

    if (confirmed == true) {
      try {
        await _memberService.deleteMember(member.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data anggota ${member.name} berhasil dihapus!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMembers = _memberService.getAllMembers();
    final classList = ['Semua', ...allMembers.map((m) => m.kelas).toSet()];

    final filteredMembers = allMembers.where((m) {
      final matchesSearch = m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.nisn.contains(_searchQuery) ||
          m.kelas.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesClass = _selectedClass == 'Semua' || m.kelas == _selectedClass;
      return matchesSearch && matchesClass;
    }).toList();

    return Column(
      children: [
        // Action Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelola Anggota (Siswa)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Pencatatan NISN & kartu anggota digital',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => _openAddEditDialog(),
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('Tambah Anggota', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari nama, NISN, atau kelas...',
                  prefixIcon: Icon(Icons.search_rounded, size: 20),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 8),

              // Class Filter Chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: classList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (ctx, index) {
                    final cls = classList[index];
                    final isSelected = cls == _selectedClass;
                    return ChoiceChip(
                      label: Text(cls, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedClass = cls),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Member List
        Expanded(
          child: filteredMembers.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada anggota yang sesuai kriteria pencarian.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredMembers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, index) {
                    final member = filteredMembers[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF4F46E5).withOpacity(0.12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: member.avatar.isNotEmpty
                                  ? Image.network(
                                      member.avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 28,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 28, color: Color(0xFF4F46E5)),
                            ),
                            const SizedBox(width: 12),

                            // Member info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          member.name,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: member.status == 'Aktif'
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          member.status,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: member.status == 'Aktif' ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'NISN: ${member.nisn} • ${member.kelas}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  Text(
                                    '${member.jurusan} • Telp: ${member.phone}',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            // Action Buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Cetak Kartu Digital',
                                  icon: const Icon(Icons.credit_card_rounded, size: 18, color: Color(0xFF4F46E5)),
                                  onPressed: () => MemberCardDialog.show(context, member),
                                ),
                                IconButton(
                                  tooltip: 'Edit Anggota',
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                                  onPressed: () => _openAddEditDialog(member: member),
                                ),
                                IconButton(
                                  tooltip: 'Hapus Anggota',
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                                  onPressed: () => _handleDeleteMember(member),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
