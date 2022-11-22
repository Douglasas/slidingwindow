library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
  generic (
    IMAGE_WIDTH   : integer := 220; -- redefine-generic
    IMAGE_HEIGHT  : integer := 220; -- redefine-generic
    WINDOW_WIDTH  : integer := 3;   -- redefine-generic
    WINDOW_HEIGHT : integer := 3;   -- redefine-generic
    PIXEL_WIDTH   : integer := 8    -- redefine-generic
  );
  port (
    i_BTN_RST : in  std_logic;
    i_CLK     : in  std_logic;
    i_UART_RX : in  std_logic;
    o_UART_TX : out std_logic
  );
end entity;

architecture arch of top is

  signal w_RSTN : std_logic;

  signal w_UART_TREADY : std_logic;

  signal w_UART_RDONE  : std_logic;
  signal w_UART_RDATA  : std_logic_vector(7 downto 0);

  signal w_REC_FULL  : std_logic;
  signal w_REC_EMPTY : std_logic;
  signal w_REC_VALID : std_logic;
  signal w_REC_DATA  : std_logic_vector(7 downto 0);

  signal w_SW_VALID : std_logic;
  signal w_SW_DATA  : std_logic_vector(7 downto 0);

  signal w_SEND_EMPTY : std_logic;
  signal w_SEND_VALID : std_logic;
  signal w_SEND_DATA  : std_logic_vector(7 downto 0);

begin

  w_RSTN <= not i_BTN_RST;

  u_UART : entity work.uart
  port map (
    rstn_i     => w_RSTN,
    clk_i      => i_CLK,
    -- parameters
    baud_div_i => x"0364", -- 0x0364 @ 100 MHz
    parity_i   => '0',
    rtscts_i   => '0',
    -- transmit interface
    tready_o   => w_UART_TREADY,
    tstart_i   => w_SEND_VALID,
    tdata_i    => w_SEND_DATA,
    tdone_o    => open,
    -- receive interface
    rready_i   => '1',
    rdone_o    => w_UART_RDONE,
    rdata_o    => w_UART_RDATA,
    rerr_o     => open,
    -- external interface
    uart_rx_i  => i_UART_RX,
    uart_tx_o  => o_UART_TX,
    uart_cts_i => '1',
    uart_rts_o => open
  );

  u_REC_FIFO : entity work.fifo
  generic map (
    FIFO_SIZE  => IMAGE_WIDTH * IMAGE_HEIGHT,
    DATA_WIDTH => PIXEL_WIDTH
  )
  port map (
    write_i => w_UART_RDONE,
    data_i  => w_UART_RDATA,
    read_i  => not w_REC_EMPTY and not w_REC_VALID,
    clk_i   => i_CLK,
    rstn_i  => w_RSTN,
    full_o  => open,
    empty_o => w_REC_EMPTY,
    valid_o => w_REC_VALID,
    data_o  => w_REC_DATA
  );

  u_SLIDINGWINDOW_TOP : entity work.slidingwindow_top
  generic map (
    IMAGE_WIDTH   => IMAGE_WIDTH,
    IMAGE_HEIGHT  => IMAGE_HEIGHT,
    WINDOW_WIDTH  => WINDOW_WIDTH,
    WINDOW_HEIGHT => WINDOW_HEIGHT,
    PIXEL_WIDTH   => PIXEL_WIDTH
  )
  port map (
    i_VALID => w_REC_VALID,
    i_PIX   => w_REC_DATA,
    i_RSTN  => w_RSTN,
    i_CLK   => i_CLK,
    o_VALID => w_SW_VALID,
    o_PIX   => w_SW_DATA
  );


  u_SEND_FIFO : entity work.fifo
  generic map (
    FIFO_SIZE  => IMAGE_WIDTH * IMAGE_HEIGHT,
    DATA_WIDTH => PIXEL_WIDTH
  )
  port map (
    write_i => w_SW_VALID,
    data_i  => w_SW_DATA,
    read_i  => w_UART_TREADY and not w_SEND_EMPTY and not w_SEND_VALID,
    rstn_i  => w_RSTN,
    clk_i   => i_CLK,
    full_o  => open,
    empty_o => w_SEND_EMPTY,
    valid_o => w_SEND_VALID,
    data_o  => w_SEND_DATA
  );
  
end architecture;
