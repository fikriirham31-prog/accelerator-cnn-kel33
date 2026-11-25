-- =============================================================================
-- Modul     : display_unit
-- Pemilik   : Anggota B
-- Deskripsi : Unit tampilan 7-segment termultipleks dan indikator status.
--             Mencakup debounce 20 ms, edge detector tombol indeks (0..8),
--             pemecah digit desimal, scanner 1 kHz, LUT 7-segment, dan LED RX.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_unit is
  generic (
    CLK_FREQ_HZ : integer := 50_000_000; -- Frekuensi clock sistem (50 MHz)
    DEBOUNCE_MS : integer := 20;         -- Waktu debounce tombol (20 ms)
    SCAN_HZ     : integer := 1_000       -- Frekuensi scan digit tampilan (1 kHz)
  );
  port (
    clk      : in  std_logic;            -- Clock sistem 50 MHz
    rst      : in  std_logic;            -- Reset aktif rendah (rst = '0')
    btn_next : in  std_logic;            -- Tombol ganti indeks hasil (0..8)
    rx_ready : in  std_logic;            -- Sinyal data UART siap / diterima
    done_all : in  std_logic;            -- Indikator proses akselerator selesai
    res_val  : in  unsigned(7 downto 0); -- Nilai piksel hasil (0..255) pada indeks idx
    idx      : out unsigned(3 downto 0); -- Indeks aktif yang ditampilkan (0..8)
    seg7     : out std_logic_vector(6 downto 0); -- Segmen a..g (aktif rendah)
    an       : out std_logic_vector(3 downto 0); -- Pilih digit aktif (aktif rendah)
    led_rx   : out std_logic;            -- Indikator LED penerimaan UART
    led_done : out std_logic             -- Indikator LED proses selesai
  );
end entity;

architecture rtl of display_unit is
  constant DEBOUNCE_MAX : integer := (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
  constant SCAN_MAX     : integer := CLK_FREQ_HZ / SCAN_HZ;

  -- Sinyal debounce dan edge detector tombol
  signal btn_sync_0, btn_sync_1 : std_logic := '0';
  signal deb_cnt                : integer range 0 to DEBOUNCE_MAX := 0;
  signal btn_stable             : std_logic := '0';
  signal btn_prev               : std_logic := '0';
  signal btn_rise               : std_logic;

  -- Indeks tampilan (0..8) dan LED RX
  signal idx_reg                : unsigned(3 downto 0) := (others => '0');
  signal led_rx_reg             : std_logic := '0';

  -- Digit desimal (ratusan, puluhan, satuan) dari nilai 8-bit (0..255)
  signal val_int                : integer range 0 to 255;
  signal dig_hundreds           : integer range 0 to 9;
  signal dig_tens               : integer range 0 to 9;
  signal dig_ones               : integer range 0 to 9;

  -- Scanner multipleksing digit
  signal scan_cnt               : integer range 0 to SCAN_MAX := 0;
  signal scan_sel               : unsigned(1 downto 0) := (others => '0');
  signal active_digit           : integer range 0 to 9 := 0;
  signal seg_pattern            : std_logic_vector(6 downto 0);
begin

  idx      <= idx_reg;
  led_rx   <= led_rx_reg;
  led_done <= done_all;

  -- 1. Sinkronisasi, debounce 20 ms, dan deteksi tepi naik (rising edge) tombol
  proc_debounce_edge : process(clk, rst)
  begin
    if rst = '0' then
      btn_sync_0 <= '0';
      btn_sync_1 <= '0';
      deb_cnt    <= 0;
      btn_stable <= '0';
      btn_prev   <= '0';
    elsif rising_edge(clk) then
      btn_sync_0 <= btn_next;
      btn_sync_1 <= btn_sync_0;

      if btn_sync_1 = btn_stable then
        deb_cnt <= 0;
      else
        if deb_cnt < DEBOUNCE_MAX then
          deb_cnt <= deb_cnt + 1;
        else
          btn_stable <= btn_sync_1;
          deb_cnt    <= 0;
        end if;
      end if;

      btn_prev <= btn_stable;
    end if;
  end process proc_debounce_edge;

  btn_rise <= '1' when (btn_stable = '1' and btn_prev = '0') else '0';

  -- 2. Pembaruan indeks piksel hasil (0..8) dan latch LED RX
  proc_idx_status : process(clk, rst)
  begin
    if rst = '0' then
      idx_reg    <= (others => '0');
      led_rx_reg <= '0';
    elsif rising_edge(clk) then
      if rx_ready = '1' then
        led_rx_reg <= '1';
      end if;

      if btn_rise = '1' then
        if idx_reg < 8 then
          idx_reg <= idx_reg + 1;
        else
          idx_reg <= (others => '0');
        end if;
      end if;
    end if;
  end process proc_idx_status;

  -- 3. Pemecah digit desimal (ratusan, puluhan, satuan) dari res_val (0..255)
  val_int      <= to_integer(res_val);
  dig_hundreds <= val_int / 100;
  dig_tens     <= (val_int / 10) mod 10;
  dig_ones     <= val_int mod 10;

  -- 4. Scanner multipleksing digit (1 kHz per langkah)
  proc_scanner : process(clk, rst)
  begin
    if rst = '0' then
      scan_cnt <= 0;
      scan_sel <= (others => '0');
    elsif rising_edge(clk) then
      if scan_cnt < SCAN_MAX - 1 then
        scan_cnt <= scan_cnt + 1;
      else
        scan_cnt <= 0;
        scan_sel <= scan_sel + 1;
      end if;
    end if;
  end process proc_scanner;

  -- Pilih digit dan anoda aktif berdasarkan scan_sel (4 digit: [3]=indeks, [2]=ratusan, [1]=puluhan, [0]=satuan)
  process(scan_sel, idx_reg, dig_hundreds, dig_tens, dig_ones)
  begin
    case scan_sel is
      when "00" =>
        an           <= "1110";
        active_digit <= dig_ones;
      when "01" =>
        an           <= "1101";
        active_digit <= dig_tens;
      when "10" =>
        an           <= "1011";
        active_digit <= dig_hundreds;
      when others =>
        an           <= "0111";
        active_digit <= to_integer(idx_reg);
    end case;
  end process;

  -- 5. LUT 7-segment (aktif rendah: '0' menyala, urutan bit "abcdefg")
  process(active_digit)
  begin
    case active_digit is
      when 0      => seg_pattern <= "0000001";
      when 1      => seg_pattern <= "1001111";
      when 2      => seg_pattern <= "0010010";
      when 3      => seg_pattern <= "0000110";
      when 4      => seg_pattern <= "1001100";
      when 5      => seg_pattern <= "0100100";
      when 6      => seg_pattern <= "0100000";
      when 7      => seg_pattern <= "0001111";
      when 8      => seg_pattern <= "0000000";
      when 9      => seg_pattern <= "0000100";
      when others => seg_pattern <= "1111111";
    end case;
  end process;

  seg7 <= seg_pattern;

end architecture rtl;