## Aplikasi CRUD Pegawai (Flutter + PHP API)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Aplikasi mobile Flutter untuk manajemen data pegawai dengan fitur lengkap: Register, Login, dan CRUD Pegawai (Create, Read, Update, Delete). Backend API menggunakan PHP (JSON) dengan endpoint sederhana.

### Fitur Utama

- Autentikasi: Register dan Login.
- CRUD Pegawai: Tambah, Lihat daftar, Detail, Edit, dan Hapus.
- Refresh data (pull-to-refresh) dan umpan-balik (SnackBar).
- Arsitektur service-model yang rapi dan mudah dikembangkan.

### Arsitektur & Struktur Kode

- `lib/services/`
  - `api_config.dart`: Pusat konfigurasi endpoint API (baseUrl dan path).
  - `auth_service.dart`: Login & Register (request/response JSON).
  - `pegawai_service.dart`: CRUD pegawai (JSON body dan parsing respons API).
- `lib/models/`
  - `user_model.dart`: Representasi user dari API.
  - `pegawai_model.dart`: Representasi pegawai (`id, nama, jabatan, gaji`).
- `lib/screen/`
  - `splash_screen.dart`: Splash, lalu ke Login.
  - `login_screen.dart`, `register_screen.dart`: Form auth terintegrasi API.
  - `list_pegawai_screen.dart`: Menampilkan list pegawai + refresh + hapus.
  - `add_pegawai_screen.dart`: Form tambah pegawai.
  - `edit_pegawai_screen.dart`: Form edit pegawai.
  - `detail_pegawai_screen.dart`: Halaman detail + aksi edit/hapus.

### Backend API (PHP)

Semua endpoint mengembalikan JSON dengan struktur:

```json
{"status":"success","data": ... }
```

atau error:

```json
{ "status": "error", "message": "alasan" }
```

Endpoint yang dipakai aplikasi:

- `POST /auth/register.php` body JSON: `{ "nama", "email", "password" }`
- `POST /auth/login.php` body JSON: `{ "email", "password" }`, balikan `data: { id, nama, email }`
- `GET  /pegawai/list.php`
- `POST /pegawai/add.php` body JSON: `{ "nama", "jabatan", "gaji" }`
- `POST /pegawai/edit.php` body JSON: `{ "id", "nama", "jabatan", "gaji" }`
- `POST /pegawai/delete.php` body JSON: `{ "id" }`

Pastikan server mengatur header berikut:

```php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
```

### Cara Menjalankan

1. Pastikan API PHP berjalan dan dapat diakses dari emulator/device.
   - Untuk Android Emulator, gunakan IP server langsung (contoh: `http://172.27.240.1:8080`).
   - Set URL di `lib/services/api_config.dart` → `baseUrl` dan path endpoint sesuai struktur server Anda.
2. Install dependency Flutter:

```bash
flutter pub get
```

3. Jalankan aplikasi:

```bash
flutter run
```

### Tangkapan Layar (Screenshots)

Ganti gambar di bawah dengan hasil proyek Anda (letakkan di folder `assets/screenshots/` dan update path):

| Splash                                   | Login                                  | Register                                     |
| ---------------------------------------- | -------------------------------------- | -------------------------------------------- |
| ![Splash](assets/screenshots/splash.png) | ![Login](assets/screenshots/login.png) | ![Register](assets/screenshots/register.png) |

| List Pegawai                         | Detail                                   | Form Tambah                        |
| ------------------------------------ | ---------------------------------------- | ---------------------------------- |
| ![List](assets/screenshots/list.png) | ![Detail](assets/screenshots/detail.png) | ![Add](assets/screenshots/add.png) |

### Desain & UX

- Warna dasar biru; tipografi sederhana dan kontras.
- Komponen input dengan `OutlineInputBorder` untuk keterbacaan.
- Navigasi yang jelas: Splash → Login → List → Detail/Edit/Add.
- Snackbar untuk umpan-balik aksi (sukses/gagal).

### Kustomisasi Tampilan Lebih Menarik

Anda dapat mempercantik UI dengan beberapa langkah cepat:

- Tambahkan tema kustom di `main.dart` (warna utama, elevated buttons, text styles).
- Format tampilan gaji dengan formatter rupiah.
- Tambahkan ikon pada list item dan kartu (Card) untuk setiap pegawai.
- Gunakan `ListTile` + `Card` + `CircleAvatar` inisial nama.

Contoh formatter sederhana Rupiah (opsional):

```dart
String formatRupiah(int value) {
  return 'Rp${value.toString()}';
}
```

### Catatan Pengembangan

- Semua request ke API pegawai mengirim JSON (`Content-Type: application/json`).
- Error handling menampilkan pesan dari server jika tersedia.
- Struktur model dan service mudah disesuaikan bila API berubah (cukup ubah di satu tempat).

### Lisensi

Proyek ini dirilis di bawah lisensi MIT.
