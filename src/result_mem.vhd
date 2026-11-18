-- =============================================================================
-- Modul     : result_mem
-- Pemilik   : Anggota B
-- Deskripsi : Memori hasil 9 x 8 bit (peta fitur akhir 3x3).
-- Kontrak   : Tabel 2.13 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity result_mem is
  port (
    clk       : in  std_logic;  -- Clock sistem
    res_we    : in  std_logic;  -- Enable tulis dari FSM
    res_waddr : in  unsigned(3 downto 0);  -- Alamat tulis (0-8)
    max_val   : in  unsigned(7 downto 0);  -- Data tulis
    idx       : in  unsigned(3 downto 0);  -- Indeks baca dari unit tampilan
    res_val   : out unsigned(7 downto 0)  -- Nilai hasil pada idx
  );
end entity;

architecture rtl of result_mem is
begin
  -- TODO: implementasi
end architecture;
