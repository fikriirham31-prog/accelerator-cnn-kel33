-- =============================================================================
-- Modul     : mac_unit
-- Pemilik   : Anggota A
-- Deskripsi : 1 pengali + 1 akumulator 20 bit bertanda. Piksel u8 diperluas ke 9 bit bertanda, hasil kali 17 bit, sign-extend ke 20 bit. acc_clr diprioritaskan atas acc_en.
-- Kontrak   : Tabel 2.8 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac_unit is
  port (
    clk     : in  std_logic;  -- Clock sistem
    rst     : in  std_logic;  -- Reset aktif rendah
    acc_clr : in  std_logic;  -- Reset akumulator ke 0
    acc_en  : in  std_logic;  -- Akumulasi hasil kali
    pix_val : in  unsigned(7 downto 0);  -- Piksel dari memori citra
    k_val   : in  signed(7 downto 0);  -- Bobot dari register kernel
    acc     : out signed(19 downto 0)  -- Hasil akumulasi satu posisi
  );
end entity;

architecture rtl of mac_unit is
begin
  -- TODO: implementasi
end architecture;
