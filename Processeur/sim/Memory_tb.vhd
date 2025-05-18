-- Testbench for Data_Memory and Instr_Memory
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end entity;

architecture Behavioral of memory_tb is
  -- Signals for Data_Memory
  signal clk       : std_logic := '0';
  signal rst       : std_logic;
  signal rw        : std_logic;
  signal addr_d    : std_logic_vector(7 downto 0);
  signal data_in   : std_logic_vector(7 downto 0);
  signal data_out  : std_logic_vector(7 downto 0);

  -- Signals for Instr_Memory
  signal addr_i    : std_logic_vector(7 downto 0);
  signal instr_out : std_logic_vector(31 downto 0);
begin
  -- Instantiate Data_Memory
  DUT_Data: entity work.Data_Memory
    port map(
      Addr     => addr_d,
      Data_In  => data_in,
      RW       => rw,
      RST      => rst,
      CLK      => clk,
      Data_Out => data_out
    );

  -- Instantiate Instr_Memory
  DUT_Instr: entity work.Instr_Memory
    port map(
      Addr      => addr_i,
      CLK       => clk,
      Instr_Out => instr_out
    );

  -- Clock generation
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
    end loop;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Reset Data Memory
    rst <= '1'; rw <= '1'; addr_d <= (others => '0'); data_in <= (others => '0');
    wait for 20 ns;
    rst <= '0';

    -- Write 0xAA to address 3
    rw <= '0'; addr_d <= x"03"; data_in <= x"AA";
    wait for 10 ns;

    -- Read back from address 3
    rw <= '1'; addr_d <= x"03";
    wait for 10 ns;
    assert data_out = x"AA"
      report "Data_Memory read/write failed at address 03" severity error;

    -- Test Instr_Memory read sequence
    for i in 0 to 3 loop
      addr_i <= std_logic_vector(to_unsigned(i, 8));
      wait for 10 ns;
    end loop;

    wait;
  end process;
end architecture;
