-- =============================================================================
-- Modul     : kernel_reg
-- Pemilik   : Anggota A
-- Deskripsi : Register file 9 x 8 bit bertanda. Counter tulis k_cnt (0-8), flag k_full saat 9 byte terisi.
-- Kontrak   : Tabel 2.5 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kernel_reg is
  port (
    clk     : in  std_logic;  -- Clock sistem
    rst     : in  std_logic;  -- Reset aktif rendah
    k_we    : in  std_logic;  -- Enable tulis dari FSM
    rx_data : in  std_logic_vector(7 downto 0);  -- Data kernel dari UART RX
    k_addr  : in  unsigned(3 downto 0);  -- Alamat baca bobot (0-8)
    k_val   : out signed(7 downto 0);  -- Bobot pada k_addr
    k_full  : out std_logic  -- Flag 9 byte kernel terisi
  );
end entity;

architecture rtl of kernel_reg is
begin
  -- TODO: implementasi
end architecture;
