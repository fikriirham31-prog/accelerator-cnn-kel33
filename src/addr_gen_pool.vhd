-- =============================================================================
-- Modul     : addr_gen_pool
-- Pemilik   : Anggota B
-- Deskripsi : Counter pool_p, pool_q (0-2) dan pool_cnt (0-5). fm_raddr = (2p+di)*6 + (2q+dj). res_waddr = 3p + q.
-- Kontrak   : Tabel 2.11 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr_gen_pool is
  port (
    clk       : in  std_logic;  -- Clock sistem
    rst       : in  std_logic;  -- Reset aktif rendah
    clr_all   : in  std_logic;  -- Kosongkan seluruh counter
    pool_run  : in  std_logic;  -- Enable counter (state POOL)
    pool_cnt  : out unsigned(2 downto 0);  -- Urutan siklus dalam satu blok (0-5)
    fm_raddr  : out unsigned(5 downto 0);  -- Alamat baca peta fitur
    res_waddr : out unsigned(3 downto 0);  -- Alamat tulis memori hasil (0-8)
    pool_done : out std_logic  -- Flag 9 blok selesai
  );
end entity;

architecture rtl of addr_gen_pool is
begin
  -- TODO: implementasi
end architecture;
