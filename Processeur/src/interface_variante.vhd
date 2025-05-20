library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interface_variant is
    Port (
        a_in  : in  std_logic_vector(7 downto 0);
        b_in  : in  std_logic_vector(7 downto 0);
        c_in  : in  std_logic_vector(7 downto 0);
        op_in : in  std_logic_vector(7 downto 0);

        a_out  : out std_logic_vector(7 downto 0);
        b_out  : out std_logic_vector(7 downto 0);
        c_out  : out std_logic_vector(7 downto 0);
        op_out : out std_logic_vector(7 downto 0);
        clk    : in std_logic;
        flg    : out std_logic
    );
end interface_variant;

architecture Behavioral of interface_variant is
    signal first_jump_flag : std_logic := '0';
    signal second_jump_flag : std_logic := '0';
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
            if first_jump_flag = '0' and second_jump_flag = '0' then
                a_out_reg  <= a_in;
                b_out_reg  <= b_in;
                c_out_reg  <= c_in;
                op_out_reg <= op_in;
            elsif  first_jump_flag ='1' then
                a_out_reg  <= "00000000";
                b_out_reg  <= "00000000";
                c_out_reg  <= "00000000";
                op_out_reg <= "00000000";
                first_jump_flag <='0';
                second_jump_flag <= '1';
            else 
                a_out_reg  <= "00000000";
                b_out_reg  <= "00000000";
                c_out_reg  <= "00000000";
                op_out_reg <= "00000000";
                second_jump_flag <= '0';
            end if;
            if (op_in = "00100010" or op_in = "00100011") then
                first_jump_flag <= '1';
            end if;
        end if;    
    end process;
    flg <= second_jump_flag or first_jump_flag;
end Behavioral;
