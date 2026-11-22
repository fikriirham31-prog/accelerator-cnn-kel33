-- =============================================================================
-- Modul     : kernel_reg
-- Pemilik   : Nichu
-- Deskripsi : Register file 9 x 8 bit bertanda. Counter tulis k_cnt (0-8), flag k_full saat 9 byte terisi.
-- Kontrak   : Tabel 2.5 (Bab II). Jangan ubah nama, lebar, atau tipe port tanpa kesepakatan seluruh anggota.
-- Status    : SKELETON - port saja, isi arsitektur belum ditulis.
-- Testbench : kernel_reg_tb
-- Menguji   : kernel_reg (tulis 9 byte, flag k_full, baca sinkron, reset, tulis berlebih, alamat di luar jangkauan)
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kernel_reg_tb is
end entity;

architecture sim of kernel_reg_tb is
  constant T_CLK : time := 20 ns;  -- 50 MHz

  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal k_we    : std_logic := '0';
  signal rx_data : std_logic_vector(7 downto 0) := (others => '0');
  signal k_addr  : unsigned(3 downto 0) := (others => '0');
  signal k_val   : signed(7 downto 0);
  signal k_full  : std_logic;
  signal done    : boolean := false;

  type vec_t is array (0 to 8) of integer;
  -- Kernel uji: mencakup batas -128 dan 127, -1, 0, dan nilai biasa
  constant KVEC : vec_t := (-128, 127, -1, 0, 1, -100, 100, -2, 55);
begin

  dut : entity work.kernel_reg
    port map (clk => clk, rst => rst, k_we => k_we, rx_data => rx_data,
              k_addr => k_addr, k_val => k_val, k_full => k_full);

  -- Pembangkit clock
  clk_gen : process
  begin
    while not done loop
      clk <= '0'; wait for T_CLK / 2;
      clk <= '1'; wait for T_CLK / 2;
    end loop;
    wait;
  end process;

  -- Stimulus dan pengecekan
  stim : process
    variable err : integer := 0;

    procedure check(cond : boolean; msg : string) is
    begin
      if not cond then
        report "GAGAL: " & msg severity error;
        err := err + 1;
      end if;
    end procedure;

    -- Tulis satu byte (1 siklus clock), lalu tunggu 1 ns agar keluaran stabil
    procedure tulis(v : integer) is
    begin
      rx_data <= std_logic_vector(to_signed(v, 8));
      k_we    <= '1';
      wait until rising_edge(clk);
      k_we    <= '0';
      wait for 1 ns;
    end procedure;

    -- Beri alamat, tunggu 1 clock (latensi baca), lalu cek nilai
    procedure baca(a : integer; expected : integer; msg : string) is
    begin
      k_addr <= to_unsigned(a, 4);
      wait until rising_edge(clk);
      wait for 1 ns;
      check(k_val = to_signed(expected, 8), msg);
    end procedure;

  begin
    -- 1. Reset awal
    rst <= '0';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait for 1 ns;
    check(k_full = '0', "k_full harus 0 saat reset");
    rst <= '1';

    -- 2. k_we = 0 tidak boleh menulis (data di rx_data diabaikan)
    rx_data <= x"55";
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait for 1 ns;
    check(k_full = '0', "k_full harus 0 tanpa penulisan");

    -- 3. Tulis 9 byte: k_full baru boleh 1 setelah byte ke-9
    for i in 0 to 8 loop
      tulis(KVEC(i));
      if i < 8 then
        check(k_full = '0', "k_full terlalu cepat aktif, byte ke-" & integer'image(i + 1));
      end if;
    end loop;
    check(k_full = '1', "k_full harus 1 setelah 9 byte");

    -- 4. Baca ulang semua isi register
    for i in 0 to 8 loop
      baca(i, KVEC(i), "isi register " & integer'image(i) & " salah");
    end loop;

    -- 5. Latensi baca: k_val belum berubah sebelum clock
    baca(0, KVEC(0), "baca alamat 0");
    k_addr <= to_unsigned(1, 4);
    wait for 1 ns;
    check(k_val = to_signed(KVEC(0), 8), "baca harus sinkron (latensi 1 siklus)");
    wait until rising_edge(clk);
    wait for 1 ns;
    check(k_val = to_signed(KVEC(1), 8), "nilai alamat 1 harus muncul 1 siklus kemudian");

    -- 6. Tulis berlebih setelah penuh harus diabaikan
    tulis(99);
    check(k_full = '1', "k_full tetap 1 setelah tulis berlebih");
    baca(0, KVEC(0), "tulis berlebih tidak boleh menimpa alamat 0");
    baca(8, KVEC(8), "tulis berlebih tidak boleh menimpa alamat 8");

    -- 7. Alamat di luar 0-8 mengembalikan 0
    baca(9,  0, "alamat 9 harus 0");
    baca(15, 0, "alamat 15 harus 0");

    -- 8. Reset membersihkan flag dan isi register
    rst <= '0';
    wait until rising_edge(clk);
    wait for 1 ns;
    rst <= '1';
    check(k_full = '0', "k_full harus 0 setelah reset");
    baca(0, 0, "register 0 harus 0 setelah reset");
    baca(8, 0, "register 8 harus 0 setelah reset");

    -- 9. Setelah reset bisa menulis lagi dari alamat 0
    tulis(5);
    check(k_full = '0', "k_full harus 0 setelah 1 byte");
    baca(0, 5, "byte pertama setelah reset harus masuk ke alamat 0");

    -- Ringkasan
    if err = 0 then
      report "SEMUA TES kernel_reg LULUS" severity note;
    else
      report integer'image(err) & " TES kernel_reg GAGAL" severity error;
    end if;
    done <= true;
    wait;
  end process;

end architecture;
