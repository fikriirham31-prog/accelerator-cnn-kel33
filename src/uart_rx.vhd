-- =============================================================================
-- Modul     : uart_rx
-- Pemilik   : Anggota A
-- Deskripsi : UART receiver 8N1 115200 bps: sync double FF, FSM lokal IDLE/START/DATA/STOP, sampling di tengah bit.
-- Kontrak   : Tabel 2.4 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
  generic (
    CLKS_PER_BIT : integer := 434
  );
  port (
    clk       : in  std_logic;  -- Clock sistem 50 MHz
    rst       : in  std_logic;  -- Reset aktif rendah
    rx_serial : in  std_logic;  -- Jalur serial dari PC
    rx_data   : out std_logic_vector(7 downto 0);  -- Byte paralel hasil konversi
    rx_ready  : out std_logic  -- Pulsa 1 siklus: byte valid
  );
end entity;

architecture rtl of uart_rx is
begin
  -- TODO: implementasi
end architecture;
