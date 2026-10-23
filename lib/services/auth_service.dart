import '../models/user_model.dart';
import '../models/member_model.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  UserModel? getCurrentUser() {
    return _storage.currentUser;
  }

  Future<UserModel> login(String username, String password) async {
    final users = _storage.getUsers();
    final cleanUsername = username.trim().toLowerCase();

    final user = users.cast<UserModel?>().firstWhere(
      (u) =>
          u != null &&
          (u.username.toLowerCase() == cleanUsername ||
              u.email.toLowerCase() == cleanUsername) &&
          u.password == password,
      orElse: () => null,
    );

    if (user == null) {
      throw Exception('Username atau Password tidak sesuai!');
    }

    await _storage.setCurrentUser(user);
    await _storage.logActivity(
      'LOGIN',
      '${user.name} (${user.role.toUpperCase()}) berhasil masuk ke sistem',
    );
    return user;
  }

  Future<UserModel> registerMember({
    required String username,
    required String password,
    required String name,
    required String nisn,
    required String kelas,
    required String jurusan,
    required String email,
    String phone = '-',
    String gender = 'Laki-laki',
    String address = 'Alamat Siswa',
  }) async {
    final users = _storage.getUsers();
    final members = _storage.getMembers();

    final cleanUsername = username.trim().toLowerCase();
    final cleanNisn = nisn.trim();

    if (users.any((u) => u.username.toLowerCase() == cleanUsername)) {
      throw Exception('Username sudah digunakan! Silakan gunakan username lain.');
    }

    if (members.any((m) => m.nisn == cleanNisn)) {
      throw Exception('NISN sudah terdaftar sebagai anggota perpustakaan!');
    }

    final userId = 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final memberId = 'MBR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final avatar = 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150';

    final newUser = UserModel(
      id: userId,
      username: username.trim(),
      password: password,
      name: name.trim(),
      email: email.trim(),
      role: 'anggota',
      nisn: cleanNisn,
      kelas: kelas.trim(),
      phone: phone.trim(),
      avatar: avatar,
    );

    final newMember = MemberModel(
      id: memberId,
      userId: userId,
      nisn: cleanNisn,
      name: name.trim(),
      gender: gender,
      kelas: kelas.trim(),
      jurusan: jurusan.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      joinedDate: DateTime.now().toIso8601String().split('T')[0],
      status: 'Aktif',
      avatar: avatar,
    );

    final updatedUsers = [...users, newUser];
    final updatedMembers = [...members, newMember];

    await _storage.setUsers(updatedUsers);
    await _storage.setMembers(updatedMembers);
    await _storage.setCurrentUser(newUser);

    await _storage.logActivity(
      'REGISTER',
      'Pendaftaran anggota baru: ${newUser.name} ($cleanNisn)',
    );

    return newUser;
  }

  Future<void> logout() async {
    final user = _storage.currentUser;
    if (user != null) {
      await _storage.logActivity('LOGOUT', '${user.name} keluar dari sistem');
    }
    await _storage.setCurrentUser(null);
  }

  Future<UserModel?> switchRoleQuickDemo(String role) async {
    final users = _storage.getUsers();
    final targetUser = users.cast<UserModel?>().firstWhere(
      (u) => u?.role == role,
      orElse: () => null,
    );

    if (targetUser != null) {
      await _storage.setCurrentUser(targetUser);
      await _storage.logActivity('SWITCH_DEMO', 'Demo role switch ke: $role');
      return targetUser;
    }
    return null;
  }
}
