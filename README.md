# Belajar Python Visual

Web pembelajaran Python yang menampilkan kode berjalan baris demi baris: baris aktif disorot, kotak variabel berubah, pointer bergerak, dan output muncul seperti di terminal.

Materi:
1. Hitung Huruf Vokal (`sum()` + generator)
2. Membalik Kata (`for`)
3. Cek Palindrom (`while` + dua pointer)
4. Jumlah Angka (`split()` + list)
5. Cari Nilai Terbesar (list comprehension + `if`)
6. Faktorial (`range()` + `*=`)

Setiap materi punya penjelasan per langkah, input yang bisa diganti, kartu konsep, dan tantangan tebak output. Kontrol keyboard: Spasi (putar/jeda), ← → (mundur/maju), R (ulang).

### Editor Kode
- Tulis kode Python sendiri dan jalankan langsung di browser (Python asli lewat [Pyodide](https://pyodide.org)).
- **▶ Jalankan** (Ctrl + Enter): menampilkan output dan nilai akhir variabel.
- **🔍 Langkah demi Langkah** (Ctrl + Shift + Enter): visualisasi baris aktif, kotak variabel, variabel lokal fungsi, dan output per langkah.
- Kolom input untuk `input()`; jika kosong, browser menanyakan input saat program berjalan.
- Pesan error dijelaskan dalam bahasa Indonesia, dan perulangan tanpa akhir dihentikan otomatis.
- 12 contoh kode (variabel, if, for, while, list, fungsi, dictionary, contoh error, dll.). Kode tersimpan otomatis di browser.

### Latihan
8 soal dengan penilaian otomatis (dicek dengan beberapa input), lengkap dengan petunjuk dan contoh solusi. Progres tersimpan di browser.

> Editor dan Latihan memerlukan koneksi internet di sisi pengguna untuk memuat Python (±10 MB, hanya pertama kali).

## Install di Ubuntu Server

```bash
curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo bash
```

Dengan port atau domain tertentu:

```bash
curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo PORT=8080 DOMAIN=contoh.id bash
```

Site `default` bawaan nginx tidak dihapus otomatis. Jika server dibuka lewat IP di port 80 masih menampilkan halaman bawaan nginx, jalankan dengan `REPLACE_DEFAULT=1` untuk menonaktifkannya (atau gunakan `PORT`/`DOMAIN`):

```bash
curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo REPLACE_DEFAULT=1 bash
```

Skrip memasang nginx dan git, menyalin aplikasi ke `/var/www/belajar-python`, lalu membuat konfigurasi nginx. Jalankan perintah yang sama lagi untuk update.

## Versi

Versi aplikasi tampil di pojok kanan atas dan tersimpan di file `VERSION`. Hook `.githooks/pre-commit` menaikkannya otomatis setiap commit (V1.1 → V1.2 → … → V1.10, dst.). Aktifkan sekali setelah clone:

```bash
git config core.hooksPath .githooks
```

## Jalankan lokal

Cukup buka `index.html` di browser. Tidak perlu server atau instalasi.
