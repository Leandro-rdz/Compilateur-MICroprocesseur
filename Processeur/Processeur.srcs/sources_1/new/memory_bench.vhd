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
  signal out_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
  process(CLK)
  begin
    if rising_edge(CLK) then

      if RST = '0' then
        for i in mem'range loop
          mem(i) <= (others => '0');
        end loop;
        out_reg <= (others => '0');

      elsif RW = '1' then
        -- Write operation
        mem(to_integer(unsigned(Addr))) <= Data_In;
      elsif RW = '0' then
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
    --ADD
    0 => x"00000000",   -- NOP
    1 => x"21000100",  -- AFC R0, 1
    2 => x"21010400",  -- AFC R1, 4
    3 => x"10020001",  -- ADD R2,R1,R0
    --SOU
    4 => x"21031000",  -- AFC R3, 16
    5 => x"21040400",  -- AFC R4, 4
    6 => x"11050304",  -- SOU R5,R3,R4
    --MUL
    7 => x"21061200",  -- AFC R6, 18
    8 => x"21070200",  -- AFC R7, 2
    9 => x"12080706",  -- MUL R8,R7,R6
    --DIV
    10  => x"21090800",  -- AFC R9, 8
    11 => x"210A5000",  -- AFC R10, 80
    12 => x"130B0A09",  -- DIV R11,R10,R9
    others => (others => '0')
  );
  signal out_reg : std_logic_vector(31 downto 0);
begin
  Instr_Out <= rom(to_integer(unsigned(Addr)));
end architecture;