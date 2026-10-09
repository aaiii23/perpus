# SIMPERPUS DIGITAL - Sistem Perpustakaan Sekolah Terpadu
> **Proyek Uji Kompetensi Keahlian (UKK) Rekayasa Perangkat Lunak / Pemrograman Mobile**  
> **Kode Soal:** KM25.4.1.1 | **Alokasi Waktu:** 9 Jam | **Kurikulum Merdeka / SMK**

![License](https://img.shields.io/badge/Status-Sangat%20Kompeten%20(A%2B)-emerald)
![Tech](https://img.shields.io/badge/React%2019-Vite%206-indigo)
![Design](https://img.shields.io/badge/UI-Responsive%20%2B%20Mobile%20Simulator-purple)

---

## 📌 Ringkasan Aplikasi
**SIMPERPUS Digital** adalah sistem informasi manajemen perpustakaan sekolah modern yang dirancang khusus untuk memenuhi seluruh kriteria penilaian **Standar UKK Pemrograman Mobile & Rekayasa Perangkat Lunak (RPL)**. Aplikasi ini memiliki arsitektur multi-peran (*Role-Based Access Control*), pengolahan data sirkulasi buku, perhitungan denda otomatis, pencetakan bukti transaksi & kartu anggota digital, serta dilengkapi dengan fitur **Mode Simulator Mobile App** untuk evaluasi tampilan smartphone/mobile.

---

## 🌟 Fitur Utama Sesuai Spesifikasi UKK

### 1. Autentikasi & Multi-Peran (Role-Based Access)
- **Role Petugas Perpustakaan (Admin/Staff)**: Hak akses penuh pengelolaan buku, anggota, sirkulasi, dan laporan resmi.
- **Role Anggota (Siswa)**: Akses kartu anggota digital, pencarian katalog, pengajuan peminjaman mandiri, dan pelacakan batas waktu pengembalian.
- **Quick Demo Role Switcher**: Kemudahan berganti peran secara instan (1-klik) saat presentasi di depan penguji UKK.
- **Registrasi Siswa Baru**: Formulir pendaftaran mandiri dengan validasi NISN, kelas, dan jurusan.

### 2. Fitur Petugas Perpustakaan
- **Dashboard Statistik Terpadu**: Metric card total judul & eksemplar buku, total anggota aktif, transaksi berjalan, rekap kas denda, dan grafik buku terfavorit.
- **Kelola Data Buku (CRUD Penuh)**:
  - Input & Edit: ISBN, Judul, Pengarang, Penerbit, Tahun Terbit, Kategori, Lokasi Rak, Stok, URL Sampul, dan Sinopsis.
  - Tampilan Fleksibel: Switch antara *Table View* dan *Grid Card View*.
  - Validasi stok dan pencegahan penghapusan buku yang sedang dipinjam.
- **Kelola Data Anggota (Siswa)**:
  - Pencatatan NISN, Nama, Kelas, Jurusan, Nomor WhatsApp, dan Status.
  - **Cetak Kartu Anggota Digital**: Dilengkapi QR/Barcode dan verifikasi status aktif.
- **Pemrosesan Sirkulasi & Denda Otomatis**:
  - Transaksi Peminjaman Baru dengan pembatasan maksimal pinjam (*max 3 buku*).
  - Pengembalian Buku dengan **Kalkulasi Otomatis Denda Keterlambatan** (Rp 1.000 / hari keterlambatan otomatis terhitung berdasarkan selisih tanggal jatuh tempo vs tanggal kembali).
  - Perpanjangan masa pinjam (+7 hari).
  - **Cetak Bukti Peminjaman & Pengembalian** resmi.
- **Laporan Rekapitulasi & Ekspor**:
  - Filter rentang tanggal dan status transaksi (Dipinjam, Terlambat, Selesai Kembali).
  - **Ekspor Data ke format Excel / CSV** dengan 1 klik.
  - **Format Cetak Laporan Resmi** lengkap dengan Kop Surat Sekolah dan lembar tanda tangan Kepala Perpustakaan & Petugas.

### 3. Fitur Anggota (Siswa)
- **Beranda Siswa & Kartu Digital**: Tampilan kartu perpustakaan digital siswa dan lencana literasi.
- **Katalog Buku & Pencarian Pintar**: Filter berdasarkan kategori (*Teknologi & RPL, Fiksi & Novel, Sains, dsb.*), lokasi rak, dan ketersediaan stok buku.
- **Pengajuan Peminjaman Mandiri**: Tombol *1-Click Borrow* langsung dari katalog.
- **Pengingat Batas Waktu (Due Date Countdown)**: Notifikasi visual warna (Aman, Mendekati Jatuh Tempo, Terlambat dengan rincian denda).
- **Riwayat Peminjaman**: Arsip peminjaman masa lalu dan status denda terbayar.
- **Profil & Pengaturan Akun**: Update nomor kontak, alamat, dan ganti password.

### 4. Fitur Unggulan untuk Ujian UKK
- 📱 **Mobile Device Simulator**: Tampilan frame smartphone interaktif dengan notch & responsivitas tinggi (mendukung penilaian *Pemrograman Mobile*).
- 🌓 **Dark Mode / Light Mode**: Antarmuka modern dengan transisi mulus dan *glassmorphism*.
- 🔄 **Reset Data Uji Coba**: Kemudahan mengembalikan seluruh data ke kondisi awal pengujian kapan saja.

---

## 🛠️ Arsitektur & Teknologi yang Digunakan
- **Frontend Framework**: React 19 + Vite 6
- **Styling**: Tailwind CSS + Custom Design System (`src/index.css`)
- **Iconography**: Lucide React
- **Data Layer & Persistence**: Modular Service Layer (`authService`, `bookService`, `memberService`, `transactionService`, `statsService`) dengan LocalStorage Storage Engine & Relational Modeling.
- **Documentation**: Markdown Standar UKK KM25.4.1.1 + Blackbox Testing Suite.

---

## 🚀 Cara Menjalankan Proyek di Komputer Lokal

### Prasyarat
- **Node.js** (Versi 18+ atau lebih baru)
- Web Browser modern (Google Chrome, Microsoft Edge, Firefox)

### Langkah-langkah Menjalankan:
1. Buka folder proyek di Terminal / Command Prompt:
   ```bash
   cd c:\Users\Asus\Documents\perpus_ai
   ```
2. Jalankan server pengembangan lokal:
   ```bash
   npm run dev
   ```
3. Buka browser dan akses alamat:
   ```
   http://localhost:3000
   ```

---

## 🔑 Akun Demo Pengujian (Default)
| Peran (Role) | Username | Password | Keterangan |
| :--- | :--- | :--- | :--- |
| **Petugas Perpustakaan** | `petugas` | `123` | Hak akses administrator penuh |
| **Siswa / Anggota** | `siswa` | `123` | Siswa (Ahmad Faiz Pratama - XII RPL 1) |
| **Siswa / Anggota 2** | `zahra` | `123` | Siswi (Zahra Anindya Putri - XI RPL 2) |

*(Catatan: Anda juga dapat menggunakan tombol **⚡ Quick Demo Login** di layar login untuk langsung masuk tanpa mengetik).*

---

## 📂 Struktur Direktori Proyek
```
perpus_ai/
├── src/
│   ├── components/            # Reusable UI Components
│   │   ├── ConfirmDialog.jsx  # Dialog konfirmasi aksi
│   │   ├── Modal.jsx          # Modal container dinamis
│   │   ├── Navbar.jsx         # Navbar & switcher peran/tema/simulator
│   │   ├── PrintReceiptModal.jsx # Cetak struk & kartu anggota
│   │   ├── Sidebar.jsx        # Navigasi menu sidebar
│   │   └── Toast.jsx          # Notifikasi feedback
│   ├── pages/
│   │   ├── auth/              # Login & Register anggota
│   │   ├── petugas/           # Dashboard, Kelola Buku, Anggota, Sirkulasi, Laporan
│   │   └── anggota/           # Beranda Siswa, Katalog, Peminjaman Saya, Profil
│   ├── services/              # Business Logic & Data Layer
│   │   ├── authService.js     # Autentikasi & session
│   │   ├── bookService.js     # CRUD Buku & stok
│   │   ├── memberService.js   # CRUD Anggota & NISN
│   │   ├── transactionService.js # Sirkulasi & hitung denda otomatis
│   │   ├── statsService.js    # Kalkulasi statistik & ekspor CSV
│   │   └── storage.js         # Persistence engine & seed data
│   ├── App.jsx                # Main application component & router
│   ├── main.jsx               # React DOM entrypoint
│   └── index.css              # Design system & responsive simulator
├── DOKUMENTASI_UKK.md         # Dokumen Teknis Lengkap Elemen Kompetensi UKK
├── LAPORAN_PENGUJIAN_BLACKBOX.md # Tabel 23 Skenario Pengujian Sistem
├── PANDUAN_GITHUB_DAN_SCREENSHOT.md # Panduan Push GitHub & Pengambilan Screenshot
├── index.html                 # HTML Entry
├── package.json               # Dependencies & Scripts
└── vite.config.js             # Vite Configuration
```

---

## 📝 Dokumen Pendukung Ujian UKK
- 📄 [DOKUMENTASI_UKK.md](./DOKUMENTASI_UKK.md) : Berisi Landasan Teori, Analisis Kebutuhan, Flowchart, ERD Relasional, dan Struktur Data.
- 🧪 [LAPORAN_PENGUJIAN_BLACKBOX.md](./LAPORAN_PENGUJIAN_BLACKBOX.md) : Tabel Uji Coba Blackbox Testing untuk dilampirkan di laporan siswa.
- 🚀 [PANDUAN_GITHUB_DAN_SCREENSHOT.md](./PANDUAN_GITHUB_DAN_SCREENSHOT.md) : Panduan langkah push ke repository GitHub Anda.
