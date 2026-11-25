-- =============================================================================
-- Modul     : pool_unit
-- Pemilik   : Anggota B
-- Deskripsi : Register maksimum 8 bit + komparator. pool_clr -> 0, pool_en -> bandingkan dan perbarui.
-- Kontrak   : Tabel 2.12 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : IMPLEMENTASI LENGKAP
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pool_unit is
  port (
    clk      : in  std_logic;            -- Clock sistem
    rst      : in  std_logic;            -- Reset aktif rendah
    pool_clr : in  std_logic;            -- Reset register maksimum ke 0
    pool_en  : in  std_logic;            -- Enable pembandingan
    fm_rdata : in  unsigned(7 downto 0); -- Nilai dari memori peta fitur
    max_val  : out unsigned(7 downto 0)  -- Nilai maksimum blok
  );
end entity;

architecture rtl of pool_unit is
  -- Register internal penyimpan nilai maksimum sementara pada blok 2x2 saat ini
  signal max_reg : unsigned(7 downto 0) := (others => '0');
begin

  -- Proses sinkron dengan reset aktif rendah (rst = '0')
  -- Prioritas: rst = '0' -> pool_clr = '1' -> pool_en = '1' (perbarui jika fm_rdata > max_reg)
  proc_max_pool : process(clk, rst)
  begin
    if rst = '0' then
      max_reg <= (others => '0');
    elsif rising_edge(clk) then
      if pool_clr = '1' then
        max_reg <= (others => '0');
      elsif pool_en = '1' then
        if fm_rdata > max_reg then
          max_reg <= fm_rdata;
        end if;
      end if;
    end if;
  end process proc_max_pool;

  -- Hubungkan register maksimum ke port keluaran max_val
  max_val <= max_reg;

end architecture rtl;