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
        RST : in std_logic;
        Addr_rst : in std_logic_vector(7 downto 0);
        Addr_out   : out std_logic_vector(7 downto 0);
        Alea : in std_logic 
    );
end Instr_counter;

architecture Behavioral of Instr_counter is
    signal count : std_logic_vector(7 downto 0) := (others => '0');

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                count <= Addr_rst-1;
            elsif Alea = '0' then
                count <= count + 1; 
            end if;
        end if;
    end process;
    Addr_out <= count when  Alea = '0' else count-1;
end Behavioral;