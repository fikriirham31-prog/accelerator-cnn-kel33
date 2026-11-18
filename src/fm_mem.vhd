-- =============================================================================
-- Modul     : fm_mem
-- Pemilik   : Anggota B
-- Deskripsi : Memori peta fitur 36 x 8 bit.
-- Kontrak   : Tabel 2.10 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fm_mem is
  port (
    clk      : in  std_logic;  -- Clock sistem
    fm_we    : in  std_logic;  -- Enable tulis dari FSM
    fm_waddr : in  unsigned(5 downto 0);  -- Alamat tulis (0-35)
    relu_out : in  unsigned(7 downto 0);  -- Data tulis
    fm_raddr : in  unsigned(5 downto 0);  -- Alamat baca (0-35)
    fm_rdata : out unsigned(7 downto 0)  -- Data baca
  );
end entity;

architecture rtl of fm_mem is
begin
  -- TODO: implementasi
end architecture;
