-- =============================================================================
-- Modul     : pool_unit
-- Pemilik   : Anggota B
-- Deskripsi : Register maksimum 8 bit + komparator. pool_clr -> 0, pool_en -> bandingkan dan perbarui.
-- Kontrak   : Tabel 2.12 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pool_unit is
  port (
    clk      : in  std_logic;  -- Clock sistem
    rst      : in  std_logic;  -- Reset aktif rendah
    pool_clr : in  std_logic;  -- Reset register maksimum ke 0
    pool_en  : in  std_logic;  -- Enable pembandingan
    fm_rdata : in  unsigned(7 downto 0);  -- Nilai dari memori peta fitur
    max_val  : out unsigned(7 downto 0)  -- Nilai maksimum blok
  );
end entity;

architecture rtl of pool_unit is
begin
  -- TODO: implementasi
end architecture;
