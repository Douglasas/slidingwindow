library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity fifo is
  generic (
    FIFO_SIZE  : integer;
    DATA_WIDTH : integer
  );
  port (
    write_i     : in std_logic;
    data_i      : in std_logic_vector(DATA_WIDTH-1 downto 0);
    read_i      : in std_logic;

    clk_i       : in std_logic;
    rstn_i      : in std_logic;

    full_o      : out std_logic;
    empty_o     : out std_logic;
    valid_o     : out std_logic;
    data_o      : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end fifo;

architecture arch_fifo of fifo is

  type fifo_t is array(natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal fifo_r  : fifo_t(FIFO_SIZE-1 downto 0);

  constant FIFO_ADDR_WIDTH : integer := integer(ceil(log2(real(FIFO_SIZE))));
  constant FIFO_LAST_ADDR  : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(FIFO_SIZE-1, FIFO_ADDR_WIDTH));

  signal first_addr_r  : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);
  signal insert_addr_r : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);
  signal size_r        : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);

  signal next_first_addr_w  : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);
  signal next_insert_addr_w : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);

  signal full_w  : std_logic;
  signal empty_w : std_logic;

begin

  next_first_addr_w  <= std_logic_vector(unsigned(first_addr_r)+1)  when first_addr_r  /= FIFO_LAST_ADDR else (others => '0');
  next_insert_addr_w <= std_logic_vector(unsigned(insert_addr_r)+1) when insert_addr_r /= FIFO_LAST_ADDR else (others => '0');

  p_MAIN : process(clk_i, rstn_i)
    variable new_size_v : std_logic_vector(FIFO_ADDR_WIDTH-1 downto 0);
  begin
    if rstn_i = '0' then
      first_addr_r  <= (others => '0');
      insert_addr_r <= (others => '0');
      size_r        <= (others => '0');
      valid_o       <= '0';

    elsif rising_edge(clk_i) then

      new_size_v := size_r;

      if read_i = '1' and empty_w = '0' then
        valid_o <= '1';
        data_o  <= fifo_r(to_integer(unsigned(first_addr_r)));
        first_addr_r <= next_first_addr_w;
        new_size_v := std_logic_vector(unsigned(new_size_v) - 1);
      else
        valid_o <= '0';
      end if;

      if write_i = '1' and full_w = '0' then
        fifo_r(to_integer(unsigned(insert_addr_r))) <= data_i;
        insert_addr_r <= next_insert_addr_w;
        new_size_v := std_logic_vector(unsigned(new_size_v) + 1);
      end if;

      size_r <= new_size_v;

    end if;
  end process;

  empty_w       <= '1' when to_integer(unsigned(size_r)) = 0         else '0';
  full_w        <= '1' when to_integer(unsigned(size_r)) = FIFO_SIZE else '0';

  empty_o <= empty_w;
  full_o  <= full_w;

end arch_fifo;
