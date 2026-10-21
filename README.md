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

## Install di Ubuntu Server

```bash
curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo bash
```

Dengan port atau domain tertentu:

```bash
curl -fsSL https://raw.githubusercontent.com/ichalsmiler/belajar-python/main/install.sh | sudo PORT=8080 DOMAIN=contoh.id bash
```

Skrip memasang nginx dan git, menyalin aplikasi ke `/var/www/belajar-python`, lalu membuat konfigurasi nginx. Jalankan perintah yang sama lagi untuk update.

## Jalankan lokal

Cukup buka `index.html` di browser. Tidak perlu server atau instalasi.
