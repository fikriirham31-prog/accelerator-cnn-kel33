# Akselerator Konvolusi 2D + ReLU + Max Pooling di FPGA (Kelompok 33)

Tugas besar EL2002 Sistem Digital, Teknik Elektro, STEI ITB.
Satu lapisan CNN kecil: citra 8x8 (8-bit) -> konvolusi 3x3 -> ReLU + saturasi 0..255 -> max pooling 2x2 -> peta fitur 3x3, ditampilkan di seven segment. Data dikirim dari PC lewat UART (115200 8N1, 73 byte: 9 kernel + 64 piksel). Target: FPGA Altera Cyclone IV, clock 50 MHz.

## Anggota

| NIM | Nama | Kode |
|---|---|---|
| 13225085 | Nicholas A. H. Hutapea | (isi A/B/C) |
| 13225091 | Irham Fikri | (isi A/B/C) |
| 13225097 | Alexander Abie Kuntara | (isi A/B/C) |

## Struktur folder

```
src/       desain VHDL (satu file = satu entity = satu pemilik)
tb/        testbench (tb_<modul>.vhd), mulai dari tb_template.vhd
python/    golden_model.py (acuan hasil) dan send_uart.py (pengirim 73 byte)
quartus/   file project Quartus (.qpf, .qsf), hanya diedit anggota C
docs/      draft laporan, gambar, spreadsheet pembagian tugas
```

## Pemilik modul

| Modul | Pemilik | Kontrak port (Bab II) |
|---|---|---|
| uart_rx, kernel_reg, image_mem, addr_gen_conv, mac_unit, relu_sat | A | Tabel 2.4 - 2.9 |
| fm_mem, addr_gen_pool, pool_unit, result_mem, display_unit | B | Tabel 2.10 - 2.14 |
| fsm_global, top_module, tb top level, python/, quartus/ | C | Tabel 2.3, 2.15 - 2.18 |

Detail bobot, status, dan kasus uji ada di `docs/Pembagian_Tugas_VHDL_Kelompok33.xlsx`.

## Konvensi

- Reset aktif rendah (`rst = '0'`), satu clock 50 MHz untuk semua modul.
- Port mengikuti tabel I/O Bab II. Jangan ubah nama, lebar, atau tipe port tanpa kesepakatan seluruh anggota.
- Nama file = nama entity. Komentar bahasa Indonesia.
- Tiap modul punya testbench dengan kasus batas (bukan hanya kondisi ideal).

## Cara kerja dengan Git

```
git pull
git checkout -b feat/<modul>
git add src/<modul>.vhd tb/tb_<modul>.vhd
git commit -m "<modul>: deskripsi singkat"
git push -u origin feat/<modul>
```

Buka Pull Request ke `main` dan minta satu anggota lain mereview. Jangan edit file orang lain tanpa memberi tahu grup. Jangan commit hasil kompilasi (sudah diatur `.gitignore`).

## Menjalankan Python

```
pip install numpy pyserial
python python/golden_model.py --seed 1    # tulis python/out/test_vector.txt dan expected.txt
python python/send_uart.py --dry-run      # cek isi 73 byte tanpa port serial
python python/send_uart.py --port COM3    # kirim ke FPGA
```

Bandingkan 9 angka di seven segment (indeks + nilai) dengan `python/out/expected.txt`. Hasil harus sama persis.

## Catatan kontrak yang perlu disinkronkan dengan Bab II

Skeleton mengikuti tabel I/O Bab II dengan tiga penyesuaian yang perlu dicatat di laporan:

1. `conv_run` dan `pool_run` adalah keluaran `fsm_global` (masukan Tabel 2.7 dan 2.11), tetapi belum tercantum di Tabel 2.3.
2. `mac_cnt` dan `pool_cnt` adalah masukan `fsm_global` untuk penjadwalan siklus (dijelaskan di teks FSM, belum di Tabel 2.3).
3. `kernel_reg` dan `image_mem` tidak punya masukan `clr_all` (sesuai Tabel 2.5 dan 2.6). Counter tulisnya dibersihkan oleh `rst`, yang berasal dari tombol RESET.

## Status

Seluruh file di `src/` masih skeleton (port saja). `top_module.vhd` sudah memuat port map lengkap sesuai kontrak. Skeleton belum dikompilasi di Quartus, jadi cek syntax saat pertama kali dibuka.
