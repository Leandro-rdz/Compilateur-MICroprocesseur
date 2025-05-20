----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2025 10:41:28 AM
-- Design Name: 
-- Module Name: IO - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IO is
    Port (
        LD1   : out std_logic_vector(7 downto 0);  -- contrainte board
        LD2   : out std_logic_vector(7 downto 0);  -- contrainte board
        
        INT1  : in std_logic_vector(7 downto 0);   -- contrainte board
        INT2  : in std_logic_vector(7 downto 0);   -- contrainte board
        BTN   : in std_logic_vector(4 downto 0);   -- contrainte board
        
        CLK         : in std_logic;
        OP          : in std_logic_vector(7 downto 0); -- pour détecter si y'a écriture
        Input_addr  : in std_logic_vector(7 downto 0);
        Output_addr : in std_logic_vector(7 downto 0);
        Output      : out std_logic_vector(7 downto 0);
        Input       : in std_logic_vector(7 downto 0)
    );
end IO;

architecture Behavioral of IO is
    signal reg_LD1, reg_LD2 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_out : std_logic_vector(7 downto 0) := (others => '0');
begin
    LD1 <= reg_LD1;
    LD2 <= reg_LD2;
    
    process(CLK)
    begin
        if falling_edge(CLK) then
            if OP = "00100100" then     -- on écrit si OP=PRI
                case Input_addr is
                    when "00000001" =>  reg_LD1<=Input; -- LED1 
                    when "00000010" =>  reg_LD2<=Input; -- LED2
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    process(Output_addr, OP, INT1, INT2, BTN)
    begin
        case Output_addr is
            when "00000011" =>  reg_out<=INT1; -- Interrupteur 1
            when "00000100" =>  reg_out<=INT2; -- Interrupteur 2
            when "00000101" =>  reg_out<="000" & BTN;  -- BUTTONS
            when others => null;
        end case;
    end process;
    Output <= reg_out;
end Behavioral;
