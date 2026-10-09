# LAPORAN PENGUJIAN PERANGKAT LUNAK (BLACKBOX TESTING)
## SIMPERPUS DIGITAL - APLIKASI PEMINJAMAN BUKU PERPUSTAKAAN
**Standar Uji Kompetensi Keahlian Rekayasa Perangkat Lunak (Kode: KM25.4.1.1)**

---

### Tabel Hasil Pengujian Sistem (Test Cases & Results)

| No | Modul Pengujian | Skenario Pengujian | Data Masukan (Input) | Hasil yang Diharapkan | Hasil Uji | Status |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **1** | Autentikasi | Login Petugas dengan akun valid | User: `petugas`, Pass: `123` | Masuk ke Dashboard Petugas, muncul toast sukses | Sesuai Harapan | **VALID** |
| **2** | Autentikasi | Login Siswa dengan akun valid | User: `siswa`, Pass: `123` | Masuk ke Beranda Siswa, kartu digital tampil | Sesuai Harapan | **VALID** |
| **3** | Autentikasi | Login dengan password salah | User: `petugas`, Pass: `salah` | Muncul pesan error "Username atau Password tidak sesuai" | Sesuai Harapan | **VALID** |
| **4** | Autentikasi | Registrasi Siswa baru | NISN, Nama, Kelas, Email, Pass | Akun terdaftar dan otomatis login ke beranda siswa | Sesuai Harapan | **VALID** |
| **5** | Autentikasi | Registrasi NISN duplikat | NISN yang sudah terdaftar | Sistem menolak dengan notifikasi NISN sudah ada | Sesuai Harapan | **VALID** |
| **6** | Autentikasi | Quick Demo Role Switcher | Klik tombol Petugas / Siswa | Sistem instan beralih peran tanpa logout manual | Sesuai Harapan | **VALID** |
| **7** | Kelola Buku | Tambah buku baru | Form lengkap dengan ISBN unik | Buku masuk ke katalog, stok dan rak tercatat | Sesuai Harapan | **VALID** |
| **8** | Kelola Buku | Tambah buku ISBN duplikat | ISBN yang sudah ada di tabel | Sistem menolak dan menampilkan peringatan duplikasi | Sesuai Harapan | **VALID** |
| **9** | Kelola Buku | Edit data buku | Mengubah judul/stok/rak | Data buku terupdate seketika | Sesuai Harapan | **VALID** |
| **10** | Kelola Buku | Hapus buku yang tidak dipinjam | Klik hapus -> konfirmasi Ya | Buku terhapus dari basis data | Sesuai Harapan | **VALID** |
| **11** | Kelola Buku | Hapus buku yang sedang dipinjam | Klik hapus pada buku berstatus pinjam | Sistem menolak dengan alasan buku sedang dipinjam | Sesuai Harapan | **VALID** |
| **12** | Kelola Anggota | Tambah data anggota baru | Form identitas siswa lengkap | Anggota tersimpan dan dapat mencetak kartu | Sesuai Harapan | **VALID** |
| **13** | Kelola Anggota | Cetak Kartu Anggota Digital | Klik ikon kartu ID | Modal kartu digital dengan barcode & data siswa terbuka | Sesuai Harapan | **VALID** |
| **14** | Sirkulasi | Peminjaman buku stok tersedia | Pilih anggota aktif + buku tersedia | Transaksi tersimpan, stok buku berkurang 1, struk pinjam keluar | Sesuai Harapan | **VALID** |
| **15** | Sirkulasi | Pinjam buku stok 0 (habis) | Pilih buku yang stoknya 0 | Pilihan dinonaktifkan/ditolak | Sesuai Harapan | **VALID** |
| **16** | Sirkulasi | Pinjam melebihi batas (max 3) | Anggota yang sudah pinjam 3 buku | Ditolak dengan notifikasi batas maksimal pinjam tercapai | Sesuai Harapan | **VALID** |
| **17** | Sirkulasi | Hitung denda pengembalian tepat waktu | Transaksi belum melewati due date | Denda terhitung Rp 0, status berubah jadi 'Kembali' | Sesuai Harapan | **VALID** |
| **18** | Sirkulasi | Hitung denda otomatis terlambat | Transaksi lewat 5 hari dari tempo | Denda otomatis terhitung Rp 5.000 (5 x Rp 1.000), stok kembali pulih | Sesuai Harapan | **VALID** |
| **19** | Sirkulasi | Perpanjang pinjaman buku | Klik perpanjang pada transaksi aktif | Tanggal jatuh tempo bertambah 7 hari | Sesuai Harapan | **VALID** |
| **20** | Katalog Siswa | Pencarian dan filter kategori | Ketik "Flutter" / Pilih "Fiksi" | Daftar buku tersaring sesuai kriteria secara live | Sesuai Harapan | **VALID** |
| **21** | Peminjaman Siswa | Pengajuan pinjam mandiri | Klik "Ajukan Pinjam" di katalog | Peminjaman langsung tercatat di menu Peminjaman Saya | Sesuai Harapan | **VALID** |
| **22** | Laporan | Ekspor data ke CSV/Excel | Klik tombol "Ekspor Excel/CSV" | File `.csv` terunduh otomatis berisi data sirkulasi | Sesuai Harapan | **VALID** |
| **23** | Antarmuka | Simulasi Mobile & Tema Gelap | Klik toggle Mobile & Theme | Layout beralih ke frame smartphone dan tema gelap mulus | Sesuai Harapan | **VALID** |

---

### Kesimpulan Hasil Pengujian:
- **Total Uji Coba**: 23 Kasus Uji
- **Total Sukses / Valid**: 23 (100%)
- **Total Gagal / Defect**: 0 (0%)
- **Kesimpulan Akhir**: Sistem berfungsi secara handal, bebas error logika, dan memenuhi seluruh kriteria kelulusan UKK SMK RPL.
