----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2025 22:19:27
-- Design Name: 
-- Module Name: control_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    Port (
        CLK  : in std_logic;
        OP   : in std_logic_vector(7 downto 0);
        cond : in std_logic_vector(7 downto 0);
        RST  : out std_logic := '0'
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process (CLK)
    begin
        if falling_edge(CLK) then
            if OP = "00100010" then     -- JMP
                RST <= '1';
            elsif OP = "00100011" then  -- JMP IF
                if cond = "00000000" then
                    RST <= '1';
                else
                    RST <= '0';
                end if;
            else
                RST <= '0';
            end if;
        end if;
    end process;
end Behavioral;