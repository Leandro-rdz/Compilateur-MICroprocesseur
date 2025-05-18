library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instr_counter is
 Port (
        CLK    : in  std_logic;
        Addr   : out std_logic_vector(7 downto 0)
    );
end Instr_counter;

architecture Behavioral of Instr_counter is
    signal count : std_logic_vector(7 downto 0) := (others => '0');
    signal prescaler: integer:=0;

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            prescaler <= prescaler + 1;
            if (prescaler = 5) then 
                prescaler <= 0;
                count <= count +1;
            end if;
        end if;
    end process;
    Addr <= count when prescaler = 0 else "00000000";
end Behavioral;