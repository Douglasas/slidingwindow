------------------------------------------------
-- Design: Sliding Window
-- Entity: slidingwindow_tb
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 04/30/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;

entity slidingwindow_tb is
  generic (
    IN_IMG        : string  := "img/img.dat";
    OUT_IMG       : string  := "img_out.dat";
    IMG_WIDTH     : integer := 5;
    IMG_HEIGHT    : integer := 5;
    WINDOW_WIDTH  : integer := 3;
    WINDOW_HEIGHT : integer := 3;
    PIXEL_WIDTH   : integer := 8
  );
end entity;

architecture arch of slidingwindow_tb is
  constant PERIOD : time := 10 ns;
  signal i_RSTN : std_logic := '0';
  signal i_CLK : std_logic := '1';

  constant OUT_IMG_SIZE : integer := (IMG_WIDTH - (WINDOW_WIDTH - 1)) * (IMG_HEIGHT - (WINDOW_HEIGHT - 1));

  file i_FILE : text;
  file o_FILE : text;

  signal i_VALID : std_logic := '0';
  signal i_PIX   : std_logic_vector(PIXEL_WIDTH-1 downto 0);
  
  signal o_VALID : std_logic;
  signal o_PIX : std_logic_vector(PIXEL_WIDTH-1 downto 0);
begin

  i_CLK <= not i_CLK after PERIOD/2;
  i_RSTN <= '1' after PERIOD/2;

  p_INPUT : process
    variable v_line : line;
    variable v_data : std_logic_vector(PIXEL_WIDTH-1 downto 0);
  begin
    wait until i_RSTN = '1';
    -- open input image file
    file_open(i_FILE, IN_IMG, READ_MODE);
    -- define valid input to block
    i_VALID <= '1';
    -- while file is not over
    while not endfile(i_FILE) loop
      -- read line of file
      readline(i_FILE, v_LINE);
      -- read pixel from line
      read(v_LINE, v_data);
      -- attribute pixel read from file to pixel input
      i_PIX <= v_data;
      -- keep pixel value for 1 clock cycle
      wait for PERIOD;
    end loop;
    -- image sent, stop sending
    i_VALID <= '0';
    wait;
  end process;

  p_RESULT : process
    variable v_line : line;
  begin
    -- open output file to be created
    file_open(o_FILE, OUT_IMG, WRITE_MODE);
    -- loop while image has not finished processing
    for pix_count in 0 to OUT_IMG_SIZE-1 loop
      -- wait until rising edge of clock and valid pixel output
      wait until rising_edge(i_CLK) and o_VALID = '1';
      -- report pixel 
      report "out pixel: " & integer'image(pix_count) & " = " & to_hstring(o_PIX);
      -- write pixel output to line
      write(v_line, o_PIX);
      -- write line to file
      writeline(o_FILE, v_line);
    end loop;
    -- wait for 1 more clock cycle
    wait for PERIOD;
    -- stop simulation
    std.env.finish;
    wait;
  end process;
  
  u_SLIDINGWINDOW_TOP : entity work.slidingwindow_top
  generic map (
    IMAGE_WIDTH   => IMG_WIDTH,
    IMAGE_HEIGHT  => IMG_HEIGHT,
    WINDOW_WIDTH  => WINDOW_WIDTH,
    WINDOW_HEIGHT => WINDOW_HEIGHT,
    PIXEL_WIDTH   => PIXEL_WIDTH
  )
  port map (
    i_VALID => i_VALID,
    i_PIX   => i_PIX,

    i_RSTN  => i_RSTN,
    i_CLK   => i_CLK,

    o_VALID => o_VALID,
    o_PIX   => o_PIX
  );

end architecture;
