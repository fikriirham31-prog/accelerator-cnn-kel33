-- =============================================================================
-- Modul     : display_unit
-- Pemilik   : Anggota B
-- Deskripsi : Debounce 20 ms (1.000.000 siklus), edge detector NEXT, register idx 0-8, pemecah digit, scanner ~1 kHz, LUT seven segment aktif rendah, logika LED RX.
-- Kontrak   : Tabel 2.14 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_unit is
  port (
    clk      : in  std_logic;  -- Clock sistem 50 MHz
    next_btn : in  std_logic;  -- Tombol NEXT (aktif rendah)
    rst_btn  : in  std_logic;  -- Tombol RESET (aktif rendah)
    res_val  : in  unsigned(7 downto 0);  -- Nilai hasil dari memori hasil
    rx_ready : in  std_logic;  -- Pulsa byte diterima (memulai kedipan LED RX)
    img_full : in  std_logic;  -- Flag 73 byte lengkap (LED RX menyala tetap)
    idx      : out unsigned(3 downto 0);  -- Indeks hasil (0-8)
    rst      : out std_logic;  -- Reset sistem aktif rendah (hasil debounce RESET)
    an       : out std_logic_vector(3 downto 0);  -- Pemilih digit (aktif rendah)
    seg      : out std_logic_vector(6 downto 0);  -- Pola segmen (aktif rendah)
    led_rx   : out std_logic  -- Indikator penerimaan data
  );
end entity;

architecture rtl of display_unit is
begin
  -- TODO: implementasi
end architecture;
