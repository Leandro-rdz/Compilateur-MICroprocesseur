library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interface_element is
    Port (
        a_in  : in  std_logic_vector(7 downto 0);
        b_in  : in  std_logic_vector(7 downto 0);
        c_in  : in  std_logic_vector(7 downto 0);
        op_in : in  std_logic_vector(7 downto 0);

        a_out  : out std_logic_vector(7 downto 0);
        b_out  : out std_logic_vector(7 downto 0);
        c_out  : out std_logic_vector(7 downto 0);
        op_out : out std_logic_vector(7 downto 0);
        clk    : in std_logic
    );
end interface_element;

architecture Behavioral of interface_element is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            a_out  <= a_in;
            b_out  <= b_in;
            c_out  <= c_in;
            op_out <= op_in;
        end if;
    end process;
end Behavioral;
