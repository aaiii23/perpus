import '../models/member_model.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class MemberService {
  final StorageService _storage = StorageService();

  List<MemberModel> getAllMembers() {
    return _storage.getMembers();
  }

  MemberModel? getMemberById(String id) {
    return _storage.getMembers().cast<MemberModel?>().firstWhere(
      (m) => m?.id == id,
      orElse: () => null,
    );
  }

  MemberModel? getMemberByNisn(String nisn) {
    final clean = nisn.trim();
    return _storage.getMembers().cast<MemberModel?>().firstWhere(
      (m) => m?.nisn == clean,
      orElse: () => null,
    );
  }

  Future<MemberModel> createMember(MemberModel memberData) async {
    final members = _storage.getMembers();
    final users = _storage.getUsers();

    if (members.any((m) => m.nisn == memberData.nisn.trim())) {
      throw Exception('Siswa dengan NISN ${memberData.nisn} sudah terdaftar!');
    }

    final newId = 'MBR-${(members.length + 1).toString().padLeft(3, '0')}';
    final newUserId = 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final newMember = memberData.copyWith(
      id: newId,
      userId: newUserId,
      joinedDate: DateTime.now().toIso8601String().split('T')[0],
      status: memberData.status.isNotEmpty ? memberData.status : 'Aktif',
    );

    // Auto create user account for this member
    final newUser = UserModel(
      id: newUserId,
      username: newMember.nisn,
      password: '123',
      name: newMember.name,
      email: newMember.email,
      role: 'anggota',
      nisn: newMember.nisn,
      kelas: newMember.kelas,
      phone: newMember.phone,
      avatar: newMember.avatar,
    );

    final updatedMembers = [newMember, ...members];
    final updatedUsers = [...users, newUser];

    await _storage.setMembers(updatedMembers);
    await _storage.setUsers(updatedUsers);

    await _storage.logActivity(
      'CREATE_MEMBER',
      'Menambahkan anggota perpustakaan: ${newMember.name} (NISN: ${newMember.nisn})',
    );

    return newMember;
  }

  Future<MemberModel> updateMember(String id, MemberModel memberData) async {
    final members = List<MemberModel>.from(_storage.getMembers());
    final index = members.indexWhere((m) => m.id == id);
    if (index == -1) {
      throw Exception('Anggota tidak ditemukan!');
    }

    final updated = memberData.copyWith(id: id);
    members[index] = updated;

    await _storage.setMembers(members);
    await _storage.logActivity(
      'UPDATE_MEMBER',
      'Memperbarui data anggota: ${updated.name}',
    );

    return updated;
  }

  Future<bool> deleteMember(String id) async {
    final members = List<MemberModel>.from(_storage.getMembers());
    final target = members.cast<MemberModel?>().firstWhere(
      (m) => m?.id == id,
      orElse: () => null,
    );

    if (target == null) {
      throw Exception('Anggota tidak ditemukan!');
    }

    // Check if member has active loans
    final transactions = _storage.getTransactions();
    final hasActiveLoan = transactions.any(
      (t) =>
          t.memberId == id &&
          (t.status == 'Dipinjam' || t.status == 'Terlambat'),
    );

    if (hasActiveLoan) {
      throw Exception(
        'Anggota masih memiliki tanggungan peminjaman buku yang belum dikembalikan!',
      );
    }

    members.removeWhere((m) => m.id == id);
    await _storage.setMembers(members);
    await _storage.logActivity(
      'DELETE_MEMBER',
      'Menghapus anggota: ${target.name}',
    );

    return true;
  }
}
