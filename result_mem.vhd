-- =============================================================================
-- Modul     : result_mem
-- Pemilik   : Anggota B
-- Deskripsi : Memori hasil 9 x 8 bit (peta fitur akhir 3x3).
-- Kontrak   : Tabel 2.13 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : IMPLEMENTASI LENGKAP
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity result_mem is
  port (
    clk       : in  std_logic;            -- Clock sistem
    res_we    : in  std_logic;            -- Enable tulis dari FSM
    res_waddr : in  unsigned(3 downto 0); -- Alamat tulis (0-8)
    max_val   : in  unsigned(7 downto 0); -- Data tulis
    idx       : in  unsigned(3 downto 0); -- Indeks baca dari unit tampilan
    res_val   : out unsigned(7 downto 0)  -- Nilai hasil pada idx
  );
end entity;

architecture rtl of result_mem is
  -- Array memori hasil max pooling berukuran 9 elemen x 8-bit (peta fitur akhir 3x3)
  type res_mem_t is array (0 to 8) of unsigned(7 downto 0);
  signal mem : res_mem_t := (others => (others => '0'));
begin

  -- Proses penulisan sinkron pada rising edge clock saat res_we aktif
  -- Menulis nilai maksimum blok pooling (max_val) ke alamat res_waddr (0..8)
  proc_write : process(clk)
  begin
    if rising_edge(clk) then
      if res_we = '1' then
        if to_integer(res_waddr) < 9 then
          mem(to_integer(res_waddr)) <= max_val;
        end if;
      end if;
    end if;
  end process proc_write;

  -- Proses pembacaan nilai hasil berdasarkan indeks tampilan (idx)
  -- Menyediakan nilai piksel hasil (0..8) ke display_unit
  proc_read : process(mem, idx)
  begin
    if to_integer(idx) < 9 then
      res_val <= mem(to_integer(idx));
    else
      res_val <= (others => '0');
    end if;
  end process proc_read;

end architecture rtl;