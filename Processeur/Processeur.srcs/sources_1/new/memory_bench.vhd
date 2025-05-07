-- Data Memory (8-bit wide, 8-bit address)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
  port(
    Addr     : in  std_logic_vector(7 downto 0);  -- Address input
    Data_In  : in  std_logic_vector(7 downto 0);  -- Data input for write
    RW       : in  std_logic;                     -- Read/Write control: '1'=Read, '0'=Write
    RST      : in  std_logic;                     -- Synchronous reset: initialize all to 0x00
    CLK      : in  std_logic;                     -- Clock
    Data_Out : out std_logic_vector(7 downto 0)   -- Data output for read
  );
end entity;

architecture Behavioral of Data_Memory is
  type mem_array is array (0 to 2**8-1) of std_logic_vector(7 downto 0);
  signal mem     : mem_array := (others => (others => '0'));
  signal out_reg : std_logic_vector(7 downto 0);
begin
  process(CLK)
  begin
    if rising_edge(CLK) then

      if RST = '1' then
        for i in mem'range loop
          mem(i) <= (others => '0');
        end loop;
        out_reg <= (others => '0');

      elsif RW = '0' then
        -- Write operation
        mem(to_integer(unsigned(Addr))) <= Data_In;
      elsif RW = '1' then
        -- Read operation
        out_reg <= mem(to_integer(unsigned(Addr)));
      end if;
    end if;
  end process;

  -- Output driver
  Data_Out <= out_reg;
end architecture;


-- Instruction Memory (32-bit wide, 8-bit address, read-only)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instr_Memory is
  port(
    Addr      : in  std_logic_vector(7 downto 0);   -- Address input
    CLK       : in  std_logic;                      -- Clock (synchronous read)
    Instr_Out : out std_logic_vector(31 downto 0)   -- Instruction output
  );
end entity;

architecture Behavior of Instr_Memory is
  type mem_array is array (0 to 2**8-1) of std_logic_vector(31 downto 0);
  -- Preload your program here via initialization or via a file read at elaboration
  constant rom : mem_array := (
    0 => x"21010001",  -- AFC R1, 1
    1 => x"21020002",  -- AFC R2, 2
    2 => x"10030102",  -- ADD R3, R1, R2
    others => (others => '0')
  );
  signal out_reg : std_logic_vector(31 downto 0);
begin
  -- Synchronous read on rising edge
  process(CLK)
  begin
    if rising_edge(CLK) then
      out_reg <= rom(to_integer(unsigned(Addr)));
    end if;
  end process;

  Instr_Out <= out_reg;
end architecture;