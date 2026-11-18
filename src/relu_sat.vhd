-- =============================================================================
-- Modul     : relu_sat
-- Pemilik   : Anggota A
-- Deskripsi : Kombinasional: acc(19)=1 -> 0; acc(18 downto 8) /= 0 -> 255; selain itu acc(7 downto 0).
-- Kontrak   : Tabel 2.9 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relu_sat is
  port (
    acc      : in  signed(19 downto 0);  -- Hasil akumulasi dari MAC
    relu_out : out unsigned(7 downto 0)  -- Nilai terbatas 0-255
  );
end entity;

architecture rtl of relu_sat is
begin
  -- TODO: implementasi
end architecture;
