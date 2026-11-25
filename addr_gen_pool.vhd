-- =============================================================================
-- Modul     : addr_gen_pool
-- Pemilik   : Anggota B
-- Deskripsi : Generator alamat max pooling 2x2 pada peta fitur 6x6 menjadi hasil 3x3.
--             Mengatur counter blok (pool_p, pool_q), counter siklus (pool_cnt 0-5),
--             alamat baca peta fitur (fm_raddr), alamat tulis hasil (res_waddr),
--             dan sinyal selesai (pool_done).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr_gen_pool is
  port (
    clk       : in  std_logic;            -- Clock sistem 50 MHz
    rst       : in  std_logic;            -- Reset aktif rendah (rst = '0')
    pool_en   : in  std_logic;            -- Aktif saat state pooling berjalan
    pool_step : in  std_logic;            -- Pulsa maju satu siklus pada jadwal POOL
    fm_raddr  : out unsigned(5 downto 0); -- Alamat baca memori peta fitur (0..35)
    res_waddr : out unsigned(3 downto 0); -- Alamat tulis memori hasil (0..8)
    pool_cnt  : out unsigned(2 downto 0); -- Counter siklus per blok (0..5)
    pool_done : out std_logic             -- Aktif 1 siklus setelah blok ke-9 selesai
  );
end entity;

architecture rtl of addr_gen_pool is
  -- Indeks blok baris (0..2) dan kolom (0..2) untuk grid hasil 3x3
  signal pool_p : unsigned(1 downto 0) := (others => '0');
  signal pool_q : unsigned(1 downto 0) := (others => '0');

  -- Pencacah siklus dalam satu blok pooling (0 s.d. 5)
  signal cnt_r  : unsigned(2 downto 0) := (others => '0');

  -- Alamat dasar piksel kiri-atas blok pada grid 6x6: (2*pool_p)*6 + 2*pool_q = 12*pool_p + 2*pool_q
  signal base_addr : unsigned(5 downto 0);
  signal raddr_int : unsigned(5 downto 0);
  signal waddr_int : unsigned(3 downto 0);
begin

  -- Hitung alamat kiri-atas blok 2x2 pada peta fitur 6x6
  base_addr <= resize(pool_p * 12 + pool_q * 2, 6);

  -- Hitung alamat baca 4 piksel dalam blok 2x2 berdasarkan cnt_r:
  -- cnt_r = 0 atau 1: baris atas blok -> base_addr + (0 atau 1)
  -- cnt_r = 2 atau 3: baris bawah blok -> base_addr + 6 + (0 atau 1)
  process(base_addr, cnt_r)
    variable row_off : unsigned(5 downto 0);
    variable col_off : unsigned(5 downto 0);
  begin
    if cnt_r(1) = '1' then
      row_off := to_unsigned(6, 6);
    else
      row_off := (others => '0');
    end if;

    if cnt_r(0) = '1' then
      col_off := to_unsigned(1, 6);
    else
      col_off := (others => '0');
    end if;

    raddr_int <= base_addr + row_off + col_off;
  end process;

  -- Alamat tulis pada result_mem (0..8): pool_p * 3 + pool_q
  waddr_int <= resize(pool_p * 3 + pool_q, 4);

  fm_raddr  <= raddr_int;
  res_waddr <= waddr_int;
  pool_cnt  <= cnt_r;

  -- Proses pembaruan pencacah siklus (0..5), koordinat blok (pool_p, pool_q), dan pool_done
  proc_pool_seq : process(clk, rst)
  begin
    if rst = '0' then
      pool_p    <= (others => '0');
      pool_q    <= (others => '0');
      cnt_r     <= (others => '0');
      pool_done <= '0';
    elsif rising_edge(clk) then
      -- pool_done dibuat berupa pulsa 1 siklus clock
      pool_done <= '0';

      if pool_en = '1' and pool_step = '1' then
        if cnt_r < 5 then
          cnt_r <= cnt_r + 1;
        else
          cnt_r <= (others => '0');

          -- Cek apakah ini blok terakhir (2,2) -> blok ke-9
          if pool_p = 2 and pool_q = 2 then
            pool_p    <= (others => '0');
            pool_q    <= (others => '0');
            pool_done <= '1';
          elsif pool_q < 2 then
            pool_q <= pool_q + 1;
          else
            pool_q <= (others => '0');
            pool_p <= pool_p + 1;
          end if;
        end if;
      end if;
    end if;
  end process proc_pool_seq;

end architecture rtl;