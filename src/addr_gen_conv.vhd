-- =============================================================================
-- Modul     : addr_gen_conv
-- Pemilik   : Anggota A
-- Deskripsi : Counter out_r, out_c (0-5) dan mac_cnt (0-10). pix_addr = out_r*8 + out_c + offset(m), offset = 0,1,2,8,9,10,16,17,18 (LUT). fm_waddr = out_r*6 + out_c.
-- Kontrak   : Tabel 2.7 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr_gen_conv is
  port (
    clk       : in  std_logic;  -- Clock sistem
    rst       : in  std_logic;  -- Reset aktif rendah
    clr_all   : in  std_logic;  -- Kosongkan seluruh counter
    conv_run  : in  std_logic;  -- Enable counter (state CONV)
    mac_cnt   : out unsigned(3 downto 0);  -- Urutan siklus dalam satu posisi (0-10)
    pix_addr  : out unsigned(5 downto 0);  -- Alamat piksel
    k_addr    : out unsigned(3 downto 0);  -- Alamat bobot
    fm_waddr  : out unsigned(5 downto 0);  -- Alamat tulis peta fitur
    conv_done : out std_logic  -- Flag 36 posisi selesai
  );
end entity;

architecture rtl of addr_gen_conv is
begin
  -- TODO: implementasi
end architecture;
