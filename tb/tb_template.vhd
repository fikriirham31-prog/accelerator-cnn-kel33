-- =============================================================================
-- Template testbench. Salin ke tb_<modul>.vhd, ganti <modul>, tambah port dan stimulus.
-- Gunakan file ini sebagai pola: clock 50 MHz, reset aktif rendah di awal,
-- stimulus terstruktur, dan assert untuk membandingkan dengan nilai acuan.
-- Kasus batas wajib: lihat sheet 'Kasus Uji' di docs/Pembagian_Tugas_VHDL_Kelompok33.xlsx
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_template is
end entity;

architecture sim of tb_template is
  constant CLK_PERIOD : time := 20 ns;  -- 50 MHz
  signal clk  : std_logic := '0';
  signal rst  : std_logic := '0';       -- aktif rendah
  signal done : boolean   := false;
begin
  -- Pembangkit clock 50 MHz, berhenti saat simulasi selesai
  clk_gen : process
  begin
    while not done loop
      clk <= '0'; wait for CLK_PERIOD / 2;
      clk <= '1'; wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- DUT: instansiasi modul yang diuji di sini
  -- dut : entity work.<modul> port map (clk => clk, rst => rst, ...);

  stim : process
  begin
    rst <= '0';
    wait for 5 * CLK_PERIOD;
    rst <= '1';
    wait for 2 * CLK_PERIOD;

    -- TODO: stimulus + assert, contoh:
    -- assert hasil = nilai_acuan report "GAGAL: <kasus>" severity error;

    report "Simulasi selesai" severity note;
    done <= true;
    wait;
  end process;
end architecture;
