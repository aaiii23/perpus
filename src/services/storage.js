// SIMPERPUS Digital - Data Layer & Persistence Store

const STORAGE_KEYS = {
  USERS: 'simperpus_users_v1',
  BOOKS: 'simperpus_books_v1',
  MEMBERS: 'simperpus_members_v1',
  TRANSACTIONS: 'simperpus_transactions_v1',
  SETTINGS: 'simperpus_settings_v1',
  ACTIVITY_LOGS: 'simperpus_logs_v1',
  CURRENT_USER: 'simperpus_auth_user_v1'
};

// Default Settings
export const DEFAULT_SETTINGS = {
  schoolName: 'SMK Negeri 1 Indonesia',
  libraryName: 'Perpustakaan Digital SMK',
  headLibrarian: 'Drs. H. Mulyadi, M.Pd.',
  librarianNIP: '19750812 200003 1 002',
  loanDurationDays: 7, // Maksimal pinjam 7 hari
  finePerDay: 1000,    // Denda Rp 1.000 per hari keterlambatan
  maxBorrowLimit: 3,   // Maksimal 3 buku per siswa
  academicYear: '2025/2026'
};

// Seed Users (Petugas & Siswa)
export const INITIAL_USERS = [
  {
    id: 'USR-001',
    username: 'petugas',
    password: '123', // Demo purpose
    name: 'Siti Rahmawati, S.Kom',
    email: 'petugas@perpus.sch.id',
    role: 'petugas',
    phone: '0812-3456-7890',
    avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80'
  },
  {
    id: 'USR-002',
    username: 'siswa',
    password: '123',
    name: 'Ahmad Faiz Pratama',
    email: 'ahmad.faiz@smk.sch.id',
    role: 'anggota',
    nisn: '0061234567',
    kelas: 'XII RPL 1',
    phone: '0857-9876-5432',
    avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80'
  },
  {
    id: 'USR-003',
    username: 'zahra',
    password: '123',
    name: 'Zahra Anindya Putri',
    email: 'zahra.putri@smk.sch.id',
    role: 'anggota',
    nisn: '0067654321',
    kelas: 'XI RPL 2',
    phone: '0821-4455-6677',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80'
  }
];

// Seed Members
export const INITIAL_MEMBERS = [
  {
    id: 'MBR-001',
    userId: 'USR-002',
    nisn: '0061234567',
    name: 'Ahmad Faiz Pratama',
    gender: 'Laki-laki',
    kelas: 'XII RPL 1',
    jurusan: 'Rekayasa Perangkat Lunak',
    email: 'ahmad.faiz@smk.sch.id',
    phone: '0857-9876-5432',
    address: 'Jl. Pemuda No. 45, Bandung',
    joinedDate: '2024-07-15',
    status: 'Aktif',
    avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80'
  },
  {
    id: 'MBR-002',
    userId: 'USR-003',
    nisn: '0067654321',
    name: 'Zahra Anindya Putri',
    gender: 'Perempuan',
    kelas: 'XI RPL 2',
    jurusan: 'Rekayasa Perangkat Lunak',
    email: 'zahra.putri@smk.sch.id',
    phone: '0821-4455-6677',
    address: 'Jl. Merdeka No. 12, Bandung',
    joinedDate: '2024-08-01',
    status: 'Aktif',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80'
  },
  {
    id: 'MBR-003',
    userId: 'USR-004',
    nisn: '0069988776',
    name: 'Rian Dimas Hidayat',
    gender: 'Laki-laki',
    kelas: 'XII TKJ 1',
    jurusan: 'Teknik Komputer & Jaringan',
    email: 'rian.dimas@smk.sch.id',
    phone: '0813-8899-0011',
    address: 'Jl. Gatot Subroto No. 88, Bandung',
    joinedDate: '2024-07-20',
    status: 'Aktif',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80'
  },
  {
    id: 'MBR-004',
    userId: 'USR-005',
    nisn: '0071122334',
    name: 'Dewi Lestari Kusuma',
    gender: 'Perempuan',
    kelas: 'X DKV 3',
    jurusan: 'Desain Komunikasi Visual',
    email: 'dewi.lestari@smk.sch.id',
    phone: '0878-1122-3344',
    address: 'Jl. Dago Asri No. 10, Bandung',
    joinedDate: '2024-09-05',
    status: 'Aktif',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80'
  }
];

// Seed Books
export const INITIAL_BOOKS = [
  {
    id: 'BK-001',
    isbn: '978-623-010-845-7',
    title: 'Pemrograman Mobile Berbasis Flutter & Dart',
    author: 'Budi Raharjo',
    publisher: 'Informatika Bandung',
    year: 2023,
    category: 'Teknologi & RPL',
    shelf: 'Rak A-01 (Komputer)',
    stock: 5,
    availableStock: 3,
    borrowedCount: 24,
    description: 'Buku panduan lengkap membangun aplikasi mobile modern multi-platform dengan framework Flutter dan bahasa pemrograman Dart untuk siswa SMK.',
    cover: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&auto=format&fit=crop&q=80'
  },
  {
    id: 'BK-002',
    isbn: '978-602-063-317-6',
    title: 'Clean Code: Panduan Menulis Kode yang Rapi dan Efisien',
    author: 'Robert C. Martin',
    publisher: 'Elex Media Komputindo',
    year: 2021,
    category: 'Teknologi & RPL',
    shelf: 'Rak A-02 (Software)',
    stock: 4,
    availableStock: 3,
    borrowedCount: 38,
    description: 'Prinsip fundamental standar penulisan kode bersih, refactoring, best practices, dan peningkatan kualitas rekayasa perangkat lunak.',
    cover: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&auto=format&fit=crop&q=80'
  },
  {
    id: 'BK-003',
    isbn: '978-602-032-478-4',
    title: 'Bumi (Serial Dunia Paralel)',
    author: 'Tere Liye',
    publisher: 'Gramedia Pustaka Utama',
    year: 2020,
    category: 'Fiksi & Novel',
    shelf: 'Rak B-01 (Sastra)',
    stock: 8,
    availableStock: 6,
    borrowedCount: 52,
    description: 'Kisah petualangan Raib, Seli, dan Ali melintasi dunia paralel yang penuh imajinasi dan rahasia klan bumi.',
    cover: 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&auto=format&fit=crop&q=80'
  },
  {
    id: 'BK-004',
    isbn: '978-979-306-279-2',
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    publisher: 'Bentang Pustaka',
    year: 2019,
    category: 'Fiksi & Novel',
    shelf: 'Rak B-02 (Sastra)',
    stock: 6,
    availableStock: 5,
    borrowedCount: 45,
    description: 'Kisah inspiratif sepuluh anak laskar pelangi di Belitong yang berjuang meraih mimpi dan pendidikan yang layak.',
    cover: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&auto=format&fit=crop&q=80'
  },
  {
    id: 'BK-005',
    isbn: '978-602-851-993-9',
    title: 'Basis Data Relasional & SQL untuk SMK',
    author: 'Wahana Komputer',
    publisher: 'Andi Offset',
    year: 2022,
    category: 'Teknologi & RPL',
    shelf: 'Rak A-03 (Database)',
    stock: 6,
    availableStock: 6,
    borrowedCount: 19,
    description: 'Panduan praktis perancangan ERD, normalisasi basis data, query MySQL, serta koneksi REST API.',
    cover: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&auto=format&fit=crop&q=80'
  },
  {
    id: 'BK-006',
    isbn: '978-623-206-444-1',
    title: 'Atomic Habits: Perubahan Kecil yang Memberikan Hasil Luar Biasa',
    author: 'James Clear',
    publisher: 'Gramedia Pustaka Utama',
    year: 2022,
    category: 'Pengembangan Diri',
    shelf: 'Rak C-01 (Motivasi)',
    stock: 5,
    availableStock: 4,
    borrowedCount: 31,
    description: 'Cara mudah dan terbukti untuk membangun kebiasaan baik dan menghilangkan kebiasaan buruk.',
    cover: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&auto=format&fit=crop&q=80'
  }
];

// Helper to calculate past & future dates
const getFormattedDate = (offsetDays = 0) => {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  return d.toISOString().split('T')[0];
};

// Seed Transactions (Mix of Active, Returned, and Overdue for instant demonstration)
export const INITIAL_TRANSACTIONS = [
  {
    id: 'TRX-2026-001',
    memberId: 'MBR-001',
    memberName: 'Ahmad Faiz Pratama',
    memberNisn: '0061234567',
    bookId: 'BK-001',
    bookTitle: 'Pemrograman Mobile Berbasis Flutter & Dart',
    bookIsbn: '978-623-010-845-7',
    borrowDate: getFormattedDate(-12), // 12 days ago
    dueDate: getFormattedDate(-5),       // Due 5 days ago (Overdue!)
    returnDate: null,
    status: 'Terlambat', // Overdue
    fineAmount: 5000,    // 5 days x 1000 = Rp 5.000
    officerName: 'Siti Rahmawati, S.Kom',
    notes: 'Peminjaman untuk tugas UKK RPL'
  },
  {
    id: 'TRX-2026-002',
    memberId: 'MBR-001',
    memberName: 'Ahmad Faiz Pratama',
    memberNisn: '0061234567',
    bookId: 'BK-003',
    bookTitle: 'Bumi (Serial Dunia Paralel)',
    bookIsbn: '978-602-032-478-4',
    borrowDate: getFormattedDate(-3),  // 3 days ago
    dueDate: getFormattedDate(4),     // Due in 4 days (Active safe)
    returnDate: null,
    status: 'Dipinjam',
    fineAmount: 0,
    officerName: 'Siti Rahmawati, S.Kom',
    notes: 'Bacaan akhir pekan'
  },
  {
    id: 'TRX-2026-003',
    memberId: 'MBR-002',
    memberName: 'Zahra Anindya Putri',
    memberNisn: '0067654321',
    bookId: 'BK-002',
    bookTitle: 'Clean Code: Panduan Menulis Kode yang Rapi dan Efisien',
    bookIsbn: '978-602-063-317-6',
    borrowDate: getFormattedDate(-2),
    dueDate: getFormattedDate(5),
    returnDate: null,
    status: 'Dipinjam',
    fineAmount: 0,
    officerName: 'Siti Rahmawati, S.Kom',
    notes: 'Referensi materi refactoring'
  },
  {
    id: 'TRX-2026-004',
    memberId: 'MBR-003',
    memberName: 'Rian Dimas Hidayat',
    memberNisn: '0069988776',
    bookId: 'BK-004',
    bookTitle: 'Laskar Pelangi',
    bookIsbn: '978-979-306-279-2',
    borrowDate: getFormattedDate(-15),
    dueDate: getFormattedDate(-8),
    returnDate: getFormattedDate(-6), // Returned 2 days late
    status: 'Kembali',
    fineAmount: 2000, // 2 days x 1000 = Rp 2.000 (Paid)
    officerName: 'Siti Rahmawati, S.Kom',
    notes: 'Denda sudah dilunasi saat pengembalian'
  }
];

export const INITIAL_LOGS = [
  {
    id: 'LOG-001',
    timestamp: new Date().toISOString(),
    user: 'Siti Rahmawati, S.Kom',
    action: 'LOGIN',
    details: 'Petugas perpustakaan berhasil login ke sistem'
  },
  {
    id: 'LOG-002',
    timestamp: new Date().toISOString(),
    user: 'Ahmad Faiz Pratama',
    action: 'PINJAM_BUKU',
    details: 'Meminjam buku "Bumi (Serial Dunia Paralel)"'
  }
];

// Initialize Storage if empty
export const initStorage = () => {
  if (!localStorage.getItem(STORAGE_KEYS.USERS)) {
    localStorage.setItem(STORAGE_KEYS.USERS, JSON.stringify(INITIAL_USERS));
  }
  if (!localStorage.getItem(STORAGE_KEYS.BOOKS)) {
    localStorage.setItem(STORAGE_KEYS.BOOKS, JSON.stringify(INITIAL_BOOKS));
  }
  if (!localStorage.getItem(STORAGE_KEYS.MEMBERS)) {
    localStorage.setItem(STORAGE_KEYS.MEMBERS, JSON.stringify(INITIAL_MEMBERS));
  }
  if (!localStorage.getItem(STORAGE_KEYS.TRANSACTIONS)) {
    localStorage.setItem(STORAGE_KEYS.TRANSACTIONS, JSON.stringify(INITIAL_TRANSACTIONS));
  }
  if (!localStorage.getItem(STORAGE_KEYS.SETTINGS)) {
    localStorage.setItem(STORAGE_KEYS.SETTINGS, JSON.stringify(DEFAULT_SETTINGS));
  }
  if (!localStorage.getItem(STORAGE_KEYS.ACTIVITY_LOGS)) {
    localStorage.setItem(STORAGE_KEYS.ACTIVITY_LOGS, JSON.stringify(INITIAL_LOGS));
  }
};

// Generic CRUD helpers
export const getStorageData = (key) => {
  try {
    const data = localStorage.getItem(key);
    return data ? JSON.parse(data) : null;
  } catch (err) {
    console.error(`Error reading ${key} from storage:`, err);
    return null;
  }
};

export const setStorageData = (key, value) => {
  try {
    localStorage.setItem(key, JSON.stringify(value));
    return true;
  } catch (err) {
    console.error(`Error writing ${key} to storage:`, err);
    return false;
  }
};

export const logActivity = (user, action, details) => {
  const logs = getStorageData(STORAGE_KEYS.ACTIVITY_LOGS) || [];
  const newLog = {
    id: `LOG-${Date.now()}`,
    timestamp: new Date().toISOString(),
    user: user?.name || 'Sistem',
    action,
    details
  };
  setStorageData(STORAGE_KEYS.ACTIVITY_LOGS, [newLog, ...logs.slice(0, 99)]);
};

export const resetAllDataToDefault = () => {
  localStorage.setItem(STORAGE_KEYS.USERS, JSON.stringify(INITIAL_USERS));
  localStorage.setItem(STORAGE_KEYS.BOOKS, JSON.stringify(INITIAL_BOOKS));
  localStorage.setItem(STORAGE_KEYS.MEMBERS, JSON.stringify(INITIAL_MEMBERS));
  localStorage.setItem(STORAGE_KEYS.TRANSACTIONS, JSON.stringify(INITIAL_TRANSACTIONS));
  localStorage.setItem(STORAGE_KEYS.SETTINGS, JSON.stringify(DEFAULT_SETTINGS));
  localStorage.setItem(STORAGE_KEYS.ACTIVITY_LOGS, JSON.stringify(INITIAL_LOGS));
  return true;
};

export { STORAGE_KEYS };
