import { STORAGE_KEYS, getStorageData, setStorageData, logActivity } from './storage';

export const authService = {
  getCurrentUser: () => {
    return getStorageData(STORAGE_KEYS.CURRENT_USER);
  },

  login: (username, password) => {
    const users = getStorageData(STORAGE_KEYS.USERS) || [];
    const user = users.find(
      (u) => (u.username.toLowerCase() === username.trim().toLowerCase() || u.email.toLowerCase() === username.trim().toLowerCase()) && u.password === password
    );

    if (!user) {
      throw new Error('Username atau Password tidak sesuai!');
    }

    // Save session
    setStorageData(STORAGE_KEYS.CURRENT_USER, user);
    logActivity(user, 'LOGIN', `${user.name} (${user.role}) berhasil masuk ke sistem`);
    return user;
  },

  registerMember: (formData) => {
    const users = getStorageData(STORAGE_KEYS.USERS) || [];
    const members = getStorageData(STORAGE_KEYS.MEMBERS) || [];

    // Check duplicate username or NISN
    if (users.some((u) => u.username.toLowerCase() === formData.username.trim().toLowerCase())) {
      throw new Error('Username sudah digunakan! Silakan gunakan username lain.');
    }
    if (members.some((m) => m.nisn === formData.nisn.trim())) {
      throw new Error('NISN sudah terdaftar sebagai anggota perpustakaan!');
    }

    const userId = `USR-${Date.now().toString().slice(-4)}`;
    const memberId = `MBR-${Date.now().toString().slice(-4)}`;

    const newUser = {
      id: userId,
      username: formData.username.trim(),
      password: formData.password,
      name: formData.name.trim(),
      email: formData.email.trim(),
      role: 'anggota',
      nisn: formData.nisn.trim(),
      kelas: formData.kelas,
      phone: formData.phone || '-',
      avatar: formData.avatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${formData.username}`
    };

    const newMember = {
      id: memberId,
      userId: userId,
      nisn: formData.nisn.trim(),
      name: formData.name.trim(),
      gender: formData.gender || 'Laki-laki',
      kelas: formData.kelas,
      jurusan: formData.jurusan || 'Rekayasa Perangkat Lunak',
      email: formData.email.trim(),
      phone: formData.phone || '-',
      address: formData.address || 'Alamat Siswa',
      joinedDate: new Date().toISOString().split('T')[0],
      status: 'Aktif',
      avatar: newUser.avatar
    };

    users.push(newUser);
    members.push(newMember);

    setStorageData(STORAGE_KEYS.USERS, users);
    setStorageData(STORAGE_KEYS.MEMBERS, members);
    setStorageData(STORAGE_KEYS.CURRENT_USER, newUser);

    logActivity(newUser, 'REGISTER', `Pendaftaran anggota baru: ${newUser.name} (${newUser.nisn})`);
    return newUser;
  },

  logout: () => {
    const user = authService.getCurrentUser();
    if (user) {
      logActivity(user, 'LOGOUT', `${user.name} keluar dari sistem`);
    }
    localStorage.removeItem(STORAGE_KEYS.CURRENT_USER);
    return true;
  },

  switchRoleQuickDemo: (role) => {
    const users = getStorageData(STORAGE_KEYS.USERS) || [];
    const targetUser = users.find((u) => u.role === role);
    if (targetUser) {
      setStorageData(STORAGE_KEYS.CURRENT_USER, targetUser);
      logActivity(targetUser, 'SWITCH_DEMO', `Demo role switch ke: ${role}`);
      return targetUser;
    }
    return null;
  }
};
