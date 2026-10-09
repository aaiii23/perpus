import { STORAGE_KEYS, getStorageData, setStorageData, logActivity } from './storage';
import { authService } from './authService';

export const memberService = {
  getAllMembers: () => {
    return getStorageData(STORAGE_KEYS.MEMBERS) || [];
  },

  getMemberById: (id) => {
    const members = memberService.getAllMembers();
    return members.find((m) => m.id === id) || null;
  },

  getMemberByNisn: (nisn) => {
    const members = memberService.getAllMembers();
    return members.find((m) => m.nisn === nisn.trim()) || null;
  },

  createMember: (memberData) => {
    const members = memberService.getAllMembers();
    const users = getStorageData(STORAGE_KEYS.USERS) || [];

    if (members.some((m) => m.nisn === memberData.nisn.trim())) {
      throw new Error(`Siswa dengan NISN ${memberData.nisn} sudah terdaftar!`);
    }

    const newId = `MBR-${String(members.length + 1).padStart(3, '0')}`;
    const newUserId = `USR-${Date.now().toString().slice(-4)}`;

    const newMember = {
      id: newId,
      userId: newUserId,
      nisn: memberData.nisn.trim(),
      name: memberData.name.trim(),
      gender: memberData.gender || 'Laki-laki',
      kelas: memberData.kelas || 'X RPL 1',
      jurusan: memberData.jurusan || 'Rekayasa Perangkat Lunak',
      email: memberData.email?.trim() || `${memberData.nisn}@smk.sch.id`,
      phone: memberData.phone || '-',
      address: memberData.address || 'Alamat Lengkap',
      joinedDate: new Date().toISOString().split('T')[0],
      status: memberData.status || 'Aktif',
      avatar: memberData.avatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${memberData.name}`
    };

    // Auto create user login for this member
    const newUser = {
      id: newUserId,
      username: memberData.nisn.trim(),
      password: '123',
      name: newMember.name,
      email: newMember.email,
      role: 'anggota',
      nisn: newMember.nisn,
      kelas: newMember.kelas,
      phone: newMember.phone,
      avatar: newMember.avatar
    };

    users.push(newUser);
    const updated = [newMember, ...members];
    
    setStorageData(STORAGE_KEYS.USERS, users);
    setStorageData(STORAGE_KEYS.MEMBERS, updated);
    logActivity(authService.getCurrentUser(), 'CREATE_MEMBER', `Menambahkan anggota perpustakaan: ${newMember.name} (NISN: ${newMember.nisn})`);
    return newMember;
  },

  updateMember: (id, memberData) => {
    const members = memberService.getAllMembers();
    const index = members.findIndex((m) => m.id === id);
    if (index === -1) {
      throw new Error('Anggota tidak ditemukan!');
    }

    const current = members[index];
    const updatedMember = {
      ...current,
      ...memberData,
      id: current.id
    };

    members[index] = updatedMember;
    setStorageData(STORAGE_KEYS.MEMBERS, members);
    logActivity(authService.getCurrentUser(), 'UPDATE_MEMBER', `Memperbarui data anggota: ${updatedMember.name}`);
    return updatedMember;
  },

  deleteMember: (id) => {
    const members = memberService.getAllMembers();
    const target = members.find((m) => m.id === id);
    if (!target) {
      throw new Error('Anggota tidak ditemukan!');
    }

    // Check if member has active loans
    const transactions = getStorageData(STORAGE_KEYS.TRANSACTIONS) || [];
    const hasActiveLoan = transactions.some((t) => t.memberId === id && (t.status === 'Dipinjam' || t.status === 'Terlambat'));
    if (hasActiveLoan) {
      throw new Error('Anggota masih memiliki tanggungan peminjaman buku yang belum dikembalikan!');
    }

    const filtered = members.filter((m) => m.id !== id);
    setStorageData(STORAGE_KEYS.MEMBERS, filtered);
    logActivity(authService.getCurrentUser(), 'DELETE_MEMBER', `Menghapus anggota: ${target.name}`);
    return true;
  }
};
