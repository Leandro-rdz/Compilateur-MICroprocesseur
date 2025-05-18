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
    signal a_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal b_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal c_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal op_out_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    a_out <= a_out_reg;
    b_out <= b_out_reg;
    c_out <= c_out_reg;
    op_out <= op_out_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            a_out_reg  <= a_in;
            b_out_reg  <= b_in;
            c_out_reg  <= c_in;
            op_out_reg <= op_in;
        end if;
    end process;
end Behavioral;
