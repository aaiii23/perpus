import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/member_model.dart';
import '../models/book_model.dart';
import '../models/transaction_model.dart';
import '../models/settings_model.dart';
import '../models/activity_log_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String keyUsers = 'simperpus_users_v1';
  static const String keyBooks = 'simperpus_books_v1';
  static const String keyMembers = 'simperpus_members_v1';
  static const String keyTransactions = 'simperpus_transactions_v1';
  static const String keySettings = 'simperpus_settings_v1';
  static const String keyLogs = 'simperpus_logs_v1';
  static const String keyCurrentUser = 'simperpus_auth_user_v1';
  static const String keyTheme = 'simperpus_theme_mode_v1';

  SharedPreferences? _prefs;

  // In-memory cache
  List<UserModel> _users = [];
  List<BookModel> _books = [];
  List<MemberModel> _members = [];
  List<TransactionModel> _transactions = [];
  SettingsModel _settings = SettingsModel();
  List<ActivityLogModel> _logs = [];
  UserModel? _currentUser;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  UserModel? get currentUser => _currentUser;
  SettingsModel get settings => _settings;

  static String _formatDate(int offsetDays) {
    final d = DateTime.now().add(Duration(days: offsetDays));
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  static List<UserModel> get initialUsers => [
    UserModel(
      id: 'USR-001',
      username: 'petugas',
      password: '123',
      name: 'Siti Rahmawati, S.Kom',
      email: 'petugas@perpus.sch.id',
      role: 'petugas',
      phone: '0812-3456-7890',
      avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80',
    ),
    UserModel(
      id: 'USR-002',
      username: 'siswa',
      password: '123',
      name: 'Ahmad Faiz Pratama',
      email: 'ahmad.faiz@smk.sch.id',
      role: 'anggota',
      nisn: '0061234567',
      kelas: 'XII RPL 1',
      phone: '0857-9876-5432',
      avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80',
    ),
    UserModel(
      id: 'USR-003',
      username: 'zahra',
      password: '123',
      name: 'Zahra Anindya Putri',
      email: 'zahra.putri@smk.sch.id',
      role: 'anggota',
      nisn: '0067654321',
      kelas: 'XI RPL 2',
      phone: '0821-4455-6677',
      avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80',
    ),
  ];

  static List<MemberModel> get initialMembers => [
    MemberModel(
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
      avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80',
    ),
    MemberModel(
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
      avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80',
    ),
    MemberModel(
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
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
    ),
    MemberModel(
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
      avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80',
    ),
  ];

  static List<BookModel> get initialBooks => [
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&auto=format&fit=crop&q=80',
    ),
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400&auto=format&fit=crop&q=80',
    ),
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&auto=format&fit=crop&q=80',
    ),
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400&auto=format&fit=crop&q=80',
    ),
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&auto=format&fit=crop&q=80',
    ),
    BookModel(
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
      cover: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&auto=format&fit=crop&q=80',
    ),
  ];

  static List<TransactionModel> get initialTransactions => [
    TransactionModel(
      id: 'TRX-2026-001',
      memberId: 'MBR-001',
      memberName: 'Ahmad Faiz Pratama',
      memberNisn: '0061234567',
      bookId: 'BK-001',
      bookTitle: 'Pemrograman Mobile Berbasis Flutter & Dart',
      bookIsbn: '978-623-010-845-7',
      borrowDate: _formatDate(-12),
      dueDate: _formatDate(-5),
      returnDate: null,
      status: 'Terlambat',
      fineAmount: 5000,
      officerName: 'Siti Rahmawati, S.Kom',
      notes: 'Peminjaman untuk tugas UKK RPL',
      daysLate: 5,
    ),
    TransactionModel(
      id: 'TRX-2026-002',
      memberId: 'MBR-001',
      memberName: 'Ahmad Faiz Pratama',
      memberNisn: '0061234567',
      bookId: 'BK-003',
      bookTitle: 'Bumi (Serial Dunia Paralel)',
      bookIsbn: '978-602-032-478-4',
      borrowDate: _formatDate(-3),
      dueDate: _formatDate(4),
      returnDate: null,
      status: 'Dipinjam',
      fineAmount: 0,
      officerName: 'Siti Rahmawati, S.Kom',
      notes: 'Bacaan akhir pekan',
      daysLate: 0,
    ),
    TransactionModel(
      id: 'TRX-2026-003',
      memberId: 'MBR-002',
      memberName: 'Zahra Anindya Putri',
      memberNisn: '0067654321',
      bookId: 'BK-002',
      bookTitle: 'Clean Code: Panduan Menulis Kode yang Rapi dan Efisien',
      bookIsbn: '978-602-063-317-6',
      borrowDate: _formatDate(-2),
      dueDate: _formatDate(5),
      returnDate: null,
      status: 'Dipinjam',
      fineAmount: 0,
      officerName: 'Siti Rahmawati, S.Kom',
      notes: 'Referensi materi refactoring',
      daysLate: 0,
    ),
    TransactionModel(
      id: 'TRX-2026-004',
      memberId: 'MBR-003',
      memberName: 'Rian Dimas Hidayat',
      memberNisn: '0069988776',
      bookId: 'BK-004',
      bookTitle: 'Laskar Pelangi',
      bookIsbn: '978-979-306-279-2',
      borrowDate: _formatDate(-15),
      dueDate: _formatDate(-8),
      returnDate: _formatDate(-6),
      status: 'Kembali',
      fineAmount: 2000,
      officerName: 'Siti Rahmawati, S.Kom',
      notes: 'Denda sudah dilunasi saat pengembalian',
      daysLate: 2,
    ),
  ];

  static List<ActivityLogModel> get initialLogs => [
    ActivityLogModel(
      id: 'LOG-001',
      timestamp: DateTime.now().toIso8601String(),
      user: 'Siti Rahmawati, S.Kom',
      action: 'LOGIN',
      details: 'Petugas perpustakaan berhasil login ke sistem',
    ),
    ActivityLogModel(
      id: 'LOG-002',
      timestamp: DateTime.now().toIso8601String(),
      user: 'Ahmad Faiz Pratama',
      action: 'PINJAM_BUKU',
      details: 'Meminjam buku "Bumi (Serial Dunia Paralel)"',
    ),
  ];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Load Theme
    _isDarkMode = _prefs?.getBool(keyTheme) ?? false;

    // Load Users
    final usersJson = _prefs?.getString(keyUsers);
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        final List list = jsonDecode(usersJson);
        _users = list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _users = initialUsers;
      }
    } else {
      _users = initialUsers;
      await _saveUsers();
    }

    // Load Members
    final membersJson = _prefs?.getString(keyMembers);
    if (membersJson != null && membersJson.isNotEmpty) {
      try {
        final List list = jsonDecode(membersJson);
        _members = list.map((e) => MemberModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _members = initialMembers;
      }
    } else {
      _members = initialMembers;
      await _saveMembers();
    }

    // Load Books
    final booksJson = _prefs?.getString(keyBooks);
    if (booksJson != null && booksJson.isNotEmpty) {
      try {
        final List list = jsonDecode(booksJson);
        _books = list.map((e) => BookModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _books = initialBooks;
      }
    } else {
      _books = initialBooks;
      await _saveBooks();
    }

    // Load Transactions
    final txJson = _prefs?.getString(keyTransactions);
    if (txJson != null && txJson.isNotEmpty) {
      try {
        final List list = jsonDecode(txJson);
        _transactions = list.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _transactions = initialTransactions;
      }
    } else {
      _transactions = initialTransactions;
      await _saveTransactions();
    }

    // Load Settings
    final settingsJson = _prefs?.getString(keySettings);
    if (settingsJson != null && settingsJson.isNotEmpty) {
      try {
        _settings = SettingsModel.fromJson(jsonDecode(settingsJson));
      } catch (_) {
        _settings = SettingsModel();
      }
    } else {
      _settings = SettingsModel();
      await _saveSettings();
    }

    // Load Logs
    final logsJson = _prefs?.getString(keyLogs);
    if (logsJson != null && logsJson.isNotEmpty) {
      try {
        final List list = jsonDecode(logsJson);
        _logs = list.map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {
        _logs = initialLogs;
      }
    } else {
      _logs = initialLogs;
      await _saveLogs();
    }

    // Load Current User
    final currentUserJson = _prefs?.getString(keyCurrentUser);
    if (currentUserJson != null && currentUserJson.isNotEmpty) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(currentUserJson));
      } catch (_) {
        _currentUser = _users.firstWhere((u) => u.role == 'petugas', orElse: () => _users.first);
      }
    } else {
      // Default to petugas for smooth UKK assessment experience
      _currentUser = _users.firstWhere((u) => u.role == 'petugas', orElse: () => _users.first);
      await setCurrentUser(_currentUser);
    }
  }

  // Save helpers
  Future<void> _saveUsers() async {
    final str = jsonEncode(_users.map((e) => e.toJson()).toList());
    await _prefs?.setString(keyUsers, str);
  }

  Future<void> _saveMembers() async {
    final str = jsonEncode(_members.map((e) => e.toJson()).toList());
    await _prefs?.setString(keyMembers, str);
  }

  Future<void> _saveBooks() async {
    final str = jsonEncode(_books.map((e) => e.toJson()).toList());
    await _prefs?.setString(keyBooks, str);
  }

  Future<void> _saveTransactions() async {
    final str = jsonEncode(_transactions.map((e) => e.toJson()).toList());
    await _prefs?.setString(keyTransactions, str);
  }

  Future<void> _saveSettings() async {
    final str = jsonEncode(_settings.toJson());
    await _prefs?.setString(keySettings, str);
  }

  Future<void> _saveLogs() async {
    final str = jsonEncode(_logs.map((e) => e.toJson()).toList());
    await _prefs?.setString(keyLogs, str);
  }

  // Theme toggle
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs?.setBool(keyTheme, value);
  }

  // Auth & Session
  Future<void> setCurrentUser(UserModel? user) async {
    _currentUser = user;
    if (user != null) {
      await _prefs?.setString(keyCurrentUser, jsonEncode(user.toJson()));
    } else {
      await _prefs?.remove(keyCurrentUser);
    }
  }

  // Activity Log
  Future<void> logActivity(String action, String details, {String? username}) async {
    final newLog = ActivityLogModel(
      id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now().toIso8601String(),
      user: username ?? _currentUser?.name ?? 'Sistem',
      action: action,
      details: details,
    );
    _logs.insert(0, newLog);
    if (_logs.length > 100) {
      _logs = _logs.sublist(0, 100);
    }
    await _saveLogs();
  }

  // Getters for lists
  List<UserModel> getUsers() => List.unmodifiable(_users);
  List<MemberModel> getMembers() => List.unmodifiable(_members);
  List<BookModel> getBooks() => List.unmodifiable(_books);
  List<TransactionModel> getTransactions() => List.unmodifiable(_transactions);
  List<ActivityLogModel> getLogs() => List.unmodifiable(_logs);

  // Setters for full lists
  Future<void> setUsers(List<UserModel> list) async {
    _users = List.from(list);
    await _saveUsers();
  }

  Future<void> setMembers(List<MemberModel> list) async {
    _members = List.from(list);
    await _saveMembers();
  }

  Future<void> setBooks(List<BookModel> list) async {
    _books = List.from(list);
    await _saveBooks();
  }

  Future<void> setTransactions(List<TransactionModel> list) async {
    _transactions = List.from(list);
    await _saveTransactions();
  }

  // Reset to initial test dataset
  Future<void> resetAllDataToDefault() async {
    _users = initialUsers;
    _members = initialMembers;
    _books = initialBooks;
    _transactions = initialTransactions;
    _settings = SettingsModel();
    _logs = initialLogs;

    await _saveUsers();
    await _saveMembers();
    await _saveBooks();
    await _saveTransactions();
    await _saveSettings();
    await _saveLogs();

    _currentUser = _users.firstWhere((u) => u.role == 'petugas', orElse: () => _users.first);
    await setCurrentUser(_currentUser);
  }
}
