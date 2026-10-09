# PANDUAN PUSH GITHUB & SCREENSHOT LAPORAN UKK

Panduan ini membimbing kamu langkah demi langkah dari menjalankan proyek, mengambil screenshot untuk laporan ujian, hingga melakukan `push` ke akun GitHub kamu sendiri.

---

## 📸 BAGIAN 1: PANDUAN SCREENSHOT UNTUK LAPORAN UKK

Buka aplikasi di browser kamu: `http://localhost:3000/`.  
Gunakan tombol `Windows + Shift + S` (di Windows) untuk mengambil tangkapan layar (screenshot) pada 7 tampilan wajib berikut:

| No | Tampilan Layar yang Di-Screenshot | Letak di Aplikasi | Penjelasan untuk Laporan Siswa |
| :---: | :--- | :--- | :--- |
| **1** | **Layar Login & Quick Demo** | Halaman awal saat logout | Menunjukkan autentikasi multi-peran (Petugas & Siswa) dan antarmuka modern. |
| **2** | **Dashboard Petugas** | Menu Sidebar: *Dashboard Petugas* | Menampilkan kartu statistik (Total Buku, Anggota, Sirkulasi Aktif, Kas Denda), buku terfavorit, dan alert keterlambatan. |
| **3** | **Kelola Data Buku (CRUD & Table/Grid)** | Menu Sidebar: *Kelola Data Buku* | Menunjukkan katalog buku, filter kategori/rak, stok eksemplar, serta modal tambah/edit buku. |
| **4** | **Kelola Anggota & Cetak Kartu Digital** | Menu Sidebar: *Kelola Anggota* | Menunjukkan daftar siswa, NISN, status, dan popup Kartu Anggota Digital lengkap dengan barcode. |
| **5** | **Sirkulasi Transaksi & Denda Otomatis** | Menu Sidebar: *Sirkulasi Transaksi* | Menunjukkan proses transaksi pinjam baru, peringatan terlambat, kalkulasi denda otomatis (Rp 1.000/hari), serta struk bukti pinjam. |
| **6** | **Laporan Rekapitulasi & Kop Resmi** | Menu Sidebar: *Laporan Rekapitulasi* | Menunjukkan tabel rekap sirkulasi, format cetak laporan resmi sekolah, dan tombol ekspor Excel/CSV. |
| **7** | **Beranda Siswa (Mode Simulasi Mobile)** | Klik tombol **"Simulasi Mobile"** di navbar atas | Menunjukkan kartu digital siswa dan responsivitas tampilan mobile/smartphone (nilai tambah UKK Pemrograman Mobile). |

---

## 🚀 BAGIAN 2: CARA PUSH PROYEK KE GITHUB KAMU

Ikuti langkah-langkah di bawah ini di Terminal / Command Prompt:

### Langkah 1: Buka Terminal di Folder Proyek
Pastikan posisi terminal berada di folder proyek:
```bash
cd c:\Users\Asus\Documents\perpus_ai
```

### Langkah 2: Inisialisasi Git dan Buat Commit
Ketik perintah berikut secara berurutan:
```bash
git init
git add .
git commit -m "feat: UKK RPL KM25.4.1.1 - Aplikasi Peminjaman Buku SIMPERPUS Digital"
```

### Langkah 3: Buat Repository Baru di Akun GitHub Kamu
1. Buka browser dan login ke [GitHub.com](https://github.com).
2. Klik tombol **"+"** di pojok kanan atas, lalu pilih **"New repository"**.
3. Beri nama repository, misalnya: `perpus-digital-ukk` atau `simperpus-rpl`.
4. Pilih **Public**, lalu klik tombol hijau **"Create repository"**.
5. Salin URL repository GitHub kamu (contoh: `https://github.com/username-kamu/perpus-digital-ukk.git`).

### Langkah 4: Hubungkan & Push ke GitHub
Jalankan perintah ini (ganti `URL_GITHUB_KAMU` dengan link yang kamu salin di Langkah 3):
```bash
git branch -M main
git remote add origin URL_GITHUB_KAMU
git push -u origin main
```
*Contoh:*
```bash
git branch -M main
git remote add origin https://github.com/ahmadfaiz/perpus-digital-ukk.git
git push -u origin main
```

---

## 🌐 BAGIAN 3: (OPSIONAL) DEPLOY GRATIS KE VERCEL / NETLIFY

Jika ingin menampilkan link website langsung kepada penguji UKK:
1. Buka [Vercel.com](https://vercel.com) atau [Netlify.com](https://netlify.com).
2. Login dengan akun GitHub kamu.
3. Pilih repository `perpus-digital-ukk` yang baru saja kamu push.
4. Klik **Deploy**. Dalam 1 menit aplikasi kamu akan aktif secara online dengan link publik (misal: `https://simperpus-digital.vercel.app`)!

---

## 💡 TIPS PRESENTASI DI DEPAN PENGUJI UKK
1. **Perkenalkan Arsitektur**: Jelaskan bahwa aplikasi memisahkan role antara Petugas dan Siswa (*Role-Based Access Control*).
2. **Tunjukkan Sirkulasi & Denda**: Demokan peminjaman buku, lalu tunjukkan transaksi yang terlambat dengan perhitungan denda otomatis Rp 1.000 per hari keterlambatan.
3. **Tunjukkan Mode Mobile**: Klik tombol **"Simulasi Mobile"** di navbar atas untuk memperlihatkan bahwa aplikasi didesain mobile-first dengan tampilan smartphone interaktif.
4. **Cetak Bukti & Laporan**: Tunjukkan fitur cetak kartu digital siswa dan cetak laporan resmi dengan Kop Surat sekolah.
