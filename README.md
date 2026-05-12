# Agenda Nusantara

Agenda Nusantara adalah aplikasi Flutter untuk mengelola tugas harian secara lokal. Aplikasi ini memakai SQLite sebagai penyimpanan data, menyediakan login sederhana, pemisahan tugas penting dan biasa, daftar tugas dengan status selesai, serta ringkasan progres dalam bentuk statistik dan grafik.

## Fitur Utama

- Login dengan akun bawaan yang disimpan di database lokal.
- Menambah tugas ke dua kategori: `penting` dan `biasa`.
- Memilih tanggal jatuh tempo, judul, dan deskripsi tugas.
- Melihat daftar seluruh tugas dalam satu layar.
- Menandai tugas selesai atau belum selesai.
- Menghapus tugas dengan geser ke kiri dan konfirmasi.
- Melihat statistik tugas selesai dan belum selesai.
- Melihat grafik jumlah tugas selesai per hari selama 7 hari terakhir.
- Mengganti password akun dari menu pengaturan.
- Menampilkan profil developer pada halaman pengaturan.

## Screenshot Aplikasi

Screenshot aplikasi:

- `assets/ss/login.png` untuk layar login.
- `assets/ss/home.png` untuk beranda.
- `assets/ss/add-task-penting.png` untuk form tambah tugas penting.
- `assets/ss/add-task-biasa.png` untuk form tambah tugas biasa.
- `assets/ss/task-list.png` untuk daftar tugas.
- `assets/ss/settings.png` untuk halaman pengaturan.

<p align="center">
	<img src="assets/ss/login.png" alt="Login Screen" width="320">
</p>

<p align="center">
	<img src="assets/ss/home.png" alt="Home Screen" width="320">
</p>

<p align="center">
	<img src="assets/ss/add-task-penting.png" alt="Add Task Penting" width="320">
</p>

<p align="center">
	<img src="assets/ss/add-task-biasa.png" alt="Add Task Biasa" width="320">
</p>

<p align="center">
	<img src="assets/ss/task-list.png" alt="Task List Screen" width="320">
</p>

<p align="center">
	<img src="assets/ss/settings.png" alt="Settings Screen" width="320">
</p>

## Teknologi yang Dipakai

- Flutter
- Dart
- SQLite melalui `sqflite`
- `intl` untuk format tanggal Bahasa Indonesia
- `fl_chart` untuk grafik progres

## Cara Menjalankan

1. Pastikan Flutter sudah terpasang dan environment siap.
2. Jalankan perintah berikut di root project:

```bash
flutter pub get
flutter run
```

3. Pilih device atau emulator yang ingin digunakan.

## Akun Default

Aplikasi ini membuat user bawaan saat database pertama kali dibuat.

- Username: `user`
- Password: `user`

## Struktur Singkat Project

```text
lib/
	main.dart
	database/
		database_helper.dart
	models/
		task.dart
	screens/
		login_screen.dart
		home_screen.dart
		add_task_screen.dart
		task_list_screen.dart
		settings_screen.dart
assets/
	foto.jpg
```

## Alur Aplikasi

1. Pengguna login menggunakan akun bawaan atau password yang sudah diganti.
2. Setelah masuk, pengguna melihat ringkasan tugas, grafik progres, dan menu navigasi.
3. Tugas baru ditambahkan dari beranda ke kategori penting atau biasa.
4. Semua data tugas tersimpan secara lokal di SQLite.
5. Password akun bisa diubah dari menu pengaturan.

## Catatan

- Data aplikasi tersimpan lokal di perangkat, jadi tidak membutuhkan server.
- Grafik pada beranda menghitung tugas yang ditandai selesai berdasarkan tanggal penyelesaian.
- Folder `build/` adalah hasil kompilasi Flutter dan biasanya tidak perlu diubah manual.
