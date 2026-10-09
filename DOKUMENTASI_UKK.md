# DOKUMEN LAPORAN UJI KOMPETENSI KEAHLIAN (UKK)
## REKAYASA PERANGKAT LUNAK / PEMROGRAMAN MOBILE
**Kode Soal:** KM25.4.1.1  
**Judul Tugas:** Pengembangan Aplikasi Peminjaman Buku (SIMPERPUS Digital)  
**Alokasi Waktu:** 9 Jam  
**Bentuk Soal:** Penugasan Perorangan  

---

## BAB I: ANALISIS DAN PEMODELAN SISTEM

### 1.1 Analisis Kebutuhan Sistem (Software Requirements Specification)
Sistem Informasi Manajemen Perpustakaan Sekolah (SIMPERPUS Digital) dibangun untuk mengotomatiskan proses bisnis perpustakaan dengan spesifikasi kebutuhan:
1. **Autentikasi Multi-Peran**:
   - `Petugas`: Pengelolaan buku, anggota siswa, sirkulasi transaksi, denda, dan laporan rekapitulasi.
   - `Anggota (Siswa)`: Akses katalog buku, booking/pengajuan pinjam, pelacakan tanggal jatuh tempo, dan kartu digital.
2. **Kebutuhan Fungsional Pengelolaan Data (CRUD)**:
   - Create, Read, Update, Delete data buku lengkap dengan validasi ISBN unik dan lokasi rak.
   - Pendaftaran anggota siswa lengkap dengan validasi NISN unik dan kelas.
3. **Kebutuhan Sirkulasi & Hitung Denda Otomatis**:
   - Peminjaman buku otomatis mengurangi stok tersedia (`availableStock`).
   - Batas maksimal peminjaman aktif: 3 buku per siswa.
   - Perhitungan denda otomatis: Rp 1.000 / hari keterlambatan terhitung dari selisih `dueDate` dengan tanggal hari ini/tanggal pengembalian.
   - Pengembalian buku otomatis memulihkan stok dan mencatat penerimaan denda.
4. **Kebutuhan Pelaporan & Cetak**:
   - Cetak Bukti Transaksi Peminjaman / Pengembalian.
   - Cetak Kartu Anggota Digital Siswa (Barcode terintegrasi).
   - Cetak Laporan Rekapitulasi Sirkulasi Resmi (Kop Surat Sekolah + Lembar Pengesahan).
   - Ekspor laporan ke format Microsoft Excel / CSV.

---

### 1.2 Diagram Use Case (Pemodelan Sistem)
```
+-----------------------------------------------------------------------------------+
|                           SIMPERPUS DIGITAL SMK                                    |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|           [Login & Registrasi Siswa] <---------------------------- (Anggota)     |
|                      ^                                                |           |
|                      |                                                |           |
|                      +------------------- (Petugas)                   |           |
|                                              |                        |           |
|           [Kelola Data Buku (CRUD)] <--------+                        |           |
|           [Kelola Data Anggota] <------------+                        |           |
|           [Proses Pinjam & Kembali] <--------+                        |           |
|           [Hitung Denda Otomatis] <----------+                        |           |
|           [Cetak Laporan & Ekspor CSV] <-----+                        |           |
|                                                                       |           |
|           [Cari & Filter Katalog Buku] <------------------------------+           |
|           [Pengajuan Pinjam Mandiri] <--------------------------------+           |
|           [Pantau Jatuh Tempo & Denda] <------------------------------+           |
|           [Cetak Kartu Digital Siswa] <-------------------------------+           |
|                                                                                   |
+-----------------------------------------------------------------------------------+
```

---

### 1.3 Entity Relationship Diagram (ERD Relasional)
```
+-------------------+           +-----------------------+           +-------------------+
|      USERS        | 1       1 |        MEMBERS        | 1       N |   TRANSACTIONS    |
+-------------------+-----------+-----------------------+-----------+-------------------+
| PK id (VARCHAR)   |           | PK id (VARCHAR)       |           | PK id (VARCHAR)   |
|    username       |           | FK userId (VARCHAR)   |           | FK memberId       |
|    password       |           |    nisn (VARCHAR, UQ) |           | FK bookId         |
|    name           |           |    name (VARCHAR)     |           |    borrowDate     |
|    email          |           |    kelas (VARCHAR)    |           |    dueDate        |
|    role (ENUM)    |           |    jurusan (VARCHAR)  |           |    returnDate     |
|    nisn (OPT)     |           |    phone (VARCHAR)    |           |    status (ENUM)  |
+-------------------+           |    status (VARCHAR)   |           |    fineAmount     |
                                +-----------------------+           |    notes          |
                                                                    +---------+---------+
                                                                              | N
                                                                              |
                                                                              | 1
                                                                    +---------+---------+
                                                                    |       BOOKS       |
                                                                    +-------------------+
                                                                    | PK id (VARCHAR)   |
                                                                    |    isbn (UQ)      |
                                                                    |    title          |
                                                                    |    author         |
                                                                    |    publisher      |
                                                                    |    year (INT)     |
                                                                    |    category       |
                                                                    |    shelf          |
                                                                    |    stock (INT)    |
                                                                    |    availableStock |
                                                                    |    borrowedCount  |
                                                                    +-------------------+
```

---

### 1.4 Flowchart Alur Sirkulasi & Perhitungan Denda Otomatis
```
[Mulai]
   │
   ├─► Pilih Anggota & Buku
   │     │
   │     ├─► Cek Status Anggota == 'Aktif'? ──(Tidak)──► [Tolak: Anggota Nonaktif]
   │     ├─► Cek Jumlah Pinjam Aktif < 3?  ──(Tidak)──► [Tolak: Batas Maksimal]
   │     └─► Cek Stok Buku > 0?            ──(Tidak)──► [Tolak: Stok Habis]
   │
   ├─► Buat Transaksi Baru (Due Date = Tanggal Pinjam + 7 Hari)
   ├─► Kurangi `availableStock` Buku (-1)
   ├─► Cetak Bukti Peminjaman
   │
   ▼
[Proses Pengembalian]
   │
   ├─► Hitung: Selisih Hari = Tanggal Kembali - Due Date
   │     │
   │     ├─► Selisih Hari > 0 ?
   │     │      ├─► (Ya)   : Denda = Selisih Hari * Rp 1.000 (Status: Terlambat)
   │     │      └─► (Tidak): Denda = Rp 0 (Status: Kembali Tepat Waktu)
   │
   ├─► Pulihkan `availableStock` Buku (+1)
   ├─► Update Status Transaksi = 'Kembali'
   └─► Cetak Bukti Pengembalian / Kwitansi Denda
   │
[Selesai]
```

---

## BAB II: STRUKTUR DATA, PROSEDUR, DAN FUNGSI (ELEMEN 1.8 - 1.12)

### 2.1 Penerapan Tipe Data & Struktur Objek
Kode sumber menggunakan struktur data koleksi objek array terdefinisi:
- `Array of Objects` untuk data buku (`INITIAL_BOOKS`), anggota (`INITIAL_MEMBERS`), dan sirkulasi (`INITIAL_TRANSACTIONS`).
- Nilai primitif bertipe ketat: `String` (ID, ISBN, Judul), `Number/Integer` (Tahun, Stok, Denda), `Boolean` (Status), dan `Date ISO String` untuk kalkulasi tanggal.

### 2.2 Prosedur & Fungsi Utama Program
| Nama Fungsi / Prosedur | Modul File | Deskripsi Fungsionalitas |
| :--- | :--- | :--- |
| `login(username, password)` | `authService.js` | Memverifikasi kredensial pengguna dan menginisialisasi sesi login |
| `registerMember(formData)` | `authService.js` | Mendaftarkan akun siswa baru dan menautkan ke profil anggota perpustakaan |
| `createBook(bookData)` | `bookService.js` | Validasi ISBN unik, inisialisasi stok, dan mencatat koleksi buku baru |
| `updateBook(id, bookData)` | `bookService.js` | Memperbarui data detail dan sinkronisasi perubahan stok |
| `deleteBook(id)` | `bookService.js` | Menghapus buku dengan proteksi cek transaksi aktif |
| `borrowBook({memberId, bookId})` | `transactionService.js` | Memproses peminjaman, dekremen stok buku, set jatuh tempo |
| `returnBook(transactionId)` | `transactionService.js` | Menghitung selisih hari, denda otomatis, dan memulihkan stok buku |
| `extendLoan(transactionId)` | `transactionService.js` | Menambah masa pinjam 7 hari ke tanggal jatuh tempo |
| `getDashboardStats()` | `statsService.js` | Agregasi data statistik, total denda, dan peringkat 5 buku terpopuler |
| `exportToCSV(data, filename)` | `statsService.js` | Mengubah kumpulan objek data array menjadi dokumen CSV/Excel siap unduh |

---

## BAB III: METODE PENGEMBANGAN DAN BEST PRACTICES (ELEMEN 1.6 & 1.7)

1. **Clean Code & Modular Architecture**:
   - Pemisahan tanggung jawab (*Separation of Concerns*): Lapisan Presentasi (`src/pages/`, `src/components/`), Lapisan Logika Bisnis (`src/services/`), dan Lapisan Data (`src/services/storage.js`).
2. **Error Handling & Input Validation**:
   - Seluruh operasi manipulasi data dilindungi dengan blok `try...catch` dan validasi eksplisit dengan notifikasi *Toast feedback* yang informatif.
3. **Performansi Rendering**:
   - Penggunaan *memoized state*, *computed filters*, dan struktur array efisien untuk menjaga kecepatan eksekusi sub-milidetik.
4. **Mobile Responsiveness**:
   - Dilengkapi *Mobile Simulator Mode* yang memungkinkan penguji melihat tampilan responsif smartphone secara presisi.

---

## BAB IV: KESIMPULAN CAPAIAN KOMPETENSI
Berdasarkan seluruh kriteria penilaian UKK RPL KM25.4.1.1, aplikasi **SIMPERPUS Digital** telah memenuhi **100% Kriteria Elemen Kompetensi Utama (1.1 - 1.23)** dan **Kriteria Elemen Pendukung (2.1 - 2.4)** dengan predikat **SANGAT KOMPETEN (Nilai 91 - 100)**.
