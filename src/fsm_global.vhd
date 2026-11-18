-- =============================================================================
-- Modul     : fsm_global
-- Pemilik   : Anggota C
-- Deskripsi : FSM Moore 6 state: IDLE, LOAD_KERNEL, LOAD_IMAGE, CONV, POOL, DONE. Jadwal CONV 11 siklus/posisi (Tabel 2.17), POOL 6 siklus/blok (Tabel 2.18). RESET (rst=0) -> IDLE dari state mana pun.
-- Kontrak   : Tabel 2.3, 2.15-2.18 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_global is
  port (
    clk       : in  std_logic;  -- Clock sistem
    rst       : in  std_logic;  -- Reset sistem aktif rendah
    rx_ready  : in  std_logic;  -- Status: byte diterima
    k_full    : in  std_logic;  -- Status: 9 byte kernel
    img_full  : in  std_logic;  -- Status: 64 byte citra
    conv_done : in  std_logic;  -- Status: 36 posisi selesai
    pool_done : in  std_logic;  -- Status: 9 blok selesai
    mac_cnt   : in  unsigned(3 downto 0);  -- Penjadwalan di CONV
    pool_cnt  : in  unsigned(2 downto 0);  -- Penjadwalan di POOL
    clr_all   : out std_logic;  -- Kosongkan counter dan flag
    k_we      : out std_logic;  -- Tulis register kernel
    img_we    : out std_logic;  -- Tulis memori citra
    acc_clr   : out std_logic;  -- Reset akumulator
    acc_en    : out std_logic;  -- Enable akumulasi
    fm_we     : out std_logic;  -- Tulis peta fitur
    pool_clr  : out std_logic;  -- Reset register maksimum
    pool_en   : out std_logic;  -- Enable pembandingan
    res_we    : out std_logic;  -- Tulis memori hasil
    conv_run  : out std_logic;  -- Enable counter konvolusi (state CONV)
    pool_run  : out std_logic;  -- Enable counter pooling (state POOL)
    led_done  : out std_logic  -- Aktif pada state DONE
  );
end entity;

architecture rtl of fsm_global is
begin
  -- TODO: implementasi
end architecture;
