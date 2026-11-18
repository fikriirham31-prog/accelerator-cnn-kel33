-- =============================================================================
-- Modul     : image_mem
-- Pemilik   : Anggota A
-- Deskripsi : Memori citra 64 x 8 bit tanpa tanda, baca sinkron (data muncul 1 siklus setelah alamat). Counter tulis img_cnt (0-63).
-- Kontrak   : Tabel 2.6 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity image_mem is
  port (
    clk      : in  std_logic;  -- Clock sistem
    rst      : in  std_logic;  -- Reset aktif rendah
    img_we   : in  std_logic;  -- Enable tulis dari FSM
    rx_data  : in  std_logic_vector(7 downto 0);  -- Data piksel dari UART RX
    pix_addr : in  unsigned(5 downto 0);  -- Alamat baca piksel (0-63)
    pix_val  : out unsigned(7 downto 0);  -- Piksel pada pix_addr
    img_full : out std_logic  -- Flag 64 byte citra terisi
  );
end entity;

architecture rtl of image_mem is
begin
  -- TODO: implementasi
end architecture;
