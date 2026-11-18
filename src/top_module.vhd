-- =============================================================================
-- Modul     : top_module
-- Pemilik   : Anggota C (integrator)
-- Deskripsi : Menghubungkan seluruh blok datapath dan FSM global.
--             Seluruh instansiasi di bawah mengikuti kontrak port Bab II.
-- Status    : Kerangka koneksi siap, tergantung isi modul lain.
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_module is
  generic (
    CLKS_PER_BIT : integer := 434   -- 50 MHz / 115200 bps
  );
  port (
    clk_50mhz : in  std_logic;                        -- Clock board 50 MHz
    rst_btn   : in  std_logic;                        -- Tombol RESET (aktif rendah)
    next_btn  : in  std_logic;                        -- Tombol NEXT (aktif rendah)
    rx_serial : in  std_logic;                        -- UART RX dari PC
    led_rx    : out std_logic;                        -- Indikator penerimaan data
    led_done  : out std_logic;                        -- Indikator proses selesai
    an        : out std_logic_vector(3 downto 0);     -- Pemilih digit (aktif rendah)
    seg       : out std_logic_vector(6 downto 0)      -- Segmen a-g (aktif rendah)
  );
end entity;

architecture rtl of top_module is
  -- Reset sistem (keluaran debounce tombol RESET dari display_unit)
  signal sys_rst   : std_logic;

  -- UART dan penyimpanan
  signal rx_data   : std_logic_vector(7 downto 0);
  signal rx_ready  : std_logic;
  signal k_full    : std_logic;
  signal img_full  : std_logic;
  signal k_we      : std_logic;
  signal img_we    : std_logic;

  -- Konvolusi
  signal conv_run  : std_logic;
  signal conv_done : std_logic;
  signal mac_cnt   : unsigned(3 downto 0);
  signal pix_addr  : unsigned(5 downto 0);
  signal k_addr    : unsigned(3 downto 0);
  signal pix_val   : unsigned(7 downto 0);
  signal k_val     : signed(7 downto 0);
  signal acc_clr   : std_logic;
  signal acc_en    : std_logic;
  signal acc       : signed(19 downto 0);
  signal relu_out  : unsigned(7 downto 0);
  signal fm_waddr  : unsigned(5 downto 0);
  signal fm_we     : std_logic;

  -- Pooling
  signal pool_run  : std_logic;
  signal pool_done : std_logic;
  signal pool_cnt  : unsigned(2 downto 0);
  signal fm_raddr  : unsigned(5 downto 0);
  signal fm_rdata  : unsigned(7 downto 0);
  signal pool_clr  : std_logic;
  signal pool_en   : std_logic;
  signal max_val   : unsigned(7 downto 0);
  signal res_waddr : unsigned(3 downto 0);
  signal res_we    : std_logic;

  -- Tampilan
  signal idx       : unsigned(3 downto 0);
  signal res_val   : unsigned(7 downto 0);

  -- Kontrol umum
  signal clr_all   : std_logic;
begin

  U_UART : entity work.uart_rx
    generic map (CLKS_PER_BIT => CLKS_PER_BIT)
    port map (clk => clk_50mhz, rst => sys_rst, rx_serial => rx_serial,
              rx_data => rx_data, rx_ready => rx_ready);

  U_KREG : entity work.kernel_reg
    port map (clk => clk_50mhz, rst => sys_rst, k_we => k_we, rx_data => rx_data,
              k_addr => k_addr, k_val => k_val, k_full => k_full);

  U_IMG : entity work.image_mem
    port map (clk => clk_50mhz, rst => sys_rst, img_we => img_we, rx_data => rx_data,
              pix_addr => pix_addr, pix_val => pix_val, img_full => img_full);

  U_AGC : entity work.addr_gen_conv
    port map (clk => clk_50mhz, rst => sys_rst, clr_all => clr_all, conv_run => conv_run,
              mac_cnt => mac_cnt, pix_addr => pix_addr, k_addr => k_addr,
              fm_waddr => fm_waddr, conv_done => conv_done);

  U_MAC : entity work.mac_unit
    port map (clk => clk_50mhz, rst => sys_rst, acc_clr => acc_clr, acc_en => acc_en,
              pix_val => pix_val, k_val => k_val, acc => acc);

  U_RELU : entity work.relu_sat
    port map (acc => acc, relu_out => relu_out);

  U_FM : entity work.fm_mem
    port map (clk => clk_50mhz, fm_we => fm_we, fm_waddr => fm_waddr, relu_out => relu_out,
              fm_raddr => fm_raddr, fm_rdata => fm_rdata);

  U_AGP : entity work.addr_gen_pool
    port map (clk => clk_50mhz, rst => sys_rst, clr_all => clr_all, pool_run => pool_run,
              pool_cnt => pool_cnt, fm_raddr => fm_raddr, res_waddr => res_waddr,
              pool_done => pool_done);

  U_POOL : entity work.pool_unit
    port map (clk => clk_50mhz, rst => sys_rst, pool_clr => pool_clr, pool_en => pool_en,
              fm_rdata => fm_rdata, max_val => max_val);

  U_RES : entity work.result_mem
    port map (clk => clk_50mhz, res_we => res_we, res_waddr => res_waddr,
              max_val => max_val, idx => idx, res_val => res_val);

  U_DISP : entity work.display_unit
    port map (clk => clk_50mhz, next_btn => next_btn, rst_btn => rst_btn, res_val => res_val,
              rx_ready => rx_ready, img_full => img_full, idx => idx, rst => sys_rst,
              an => an, seg => seg, led_rx => led_rx);

  U_FSM : entity work.fsm_global
    port map (clk => clk_50mhz, rst => sys_rst, rx_ready => rx_ready, k_full => k_full,
              img_full => img_full, conv_done => conv_done, pool_done => pool_done,
              mac_cnt => mac_cnt, pool_cnt => pool_cnt, clr_all => clr_all,
              k_we => k_we, img_we => img_we, acc_clr => acc_clr, acc_en => acc_en,
              fm_we => fm_we, pool_clr => pool_clr, pool_en => pool_en, res_we => res_we,
              conv_run => conv_run, pool_run => pool_run, led_done => led_done);

end architecture;
