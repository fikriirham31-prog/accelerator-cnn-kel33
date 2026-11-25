-- =============================================================================
-- Modul     : fm_mem
-- Pemilik   : Anggota B
-- Deskripsi : Memori peta fitur 36 x 8 bit.
-- Kontrak   : Tabel 2.10 (Bab II). Jangan ubah nama, lebar, atau tipe port
--             tanpa kesepakatan seluruh anggota.
-- Status    : IMPLEMENTASI LENGKAP
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fm_mem is
  port (
    clk      : in  std_logic;            -- Clock sistem
    fm_we    : in  std_logic;            -- Enable tulis dari FSM
    fm_waddr : in  unsigned(5 downto 0); -- Alamat tulis (0-35)
    relu_out : in  unsigned(7 downto 0); -- Data tulis
    fm_raddr : in  unsigned(5 downto 0); -- Alamat baca (0-35)
    fm_rdata : out unsigned(7 downto 0)  -- Data baca
  );
end entity;

architecture rtl of fm_mem is
  -- Deklarasi array memori berkapasitas 36 elemen x 8-bit tak bertanda (peta fitur 6x6)
  type mem_array_t is array (0 to 35) of unsigned(7 downto 0);
  signal mem : mem_array_t := (others => (others => '0'));
begin

  -- Proses penulisan data ke memori peta fitur secara sinkron pada rising edge clock
  -- Menulis data dari keluaran ReLU/saturasi (relu_out) ke alamat fm_waddr saat fm_we aktif
  proc_write : process(clk)
  begin
    if rising_edge(clk) then
      if fm_we = '1' then
        -- Penjagaan batas alamat agar tidak terjadi out-of-range saat simulasi (0..35)
        if to_integer(fm_waddr) < 36 then
          mem(to_integer(fm_waddr)) <= relu_out;
        end if;
      end if;
    end if;
  end process proc_write;

  -- Proses pembacaan data secara sinkron pada rising edge clock (mengikuti pola baca sinkron memori proyek)
  -- Menyediakan data peta fitur pada fm_rdata sesuai alamat fm_raddr dari addr_gen_pool
  proc_read : process(clk)
  begin
    if rising_edge(clk) then
      if to_integer(fm_raddr) < 36 then
        fm_rdata <= mem(to_integer(fm_raddr));
      else
        fm_rdata <= (others => '0');
      end if;
    end if;
  end process proc_read;

end architecture rtl;