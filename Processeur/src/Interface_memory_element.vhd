library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interface_memory is
    Port (
        a_in  : in  std_logic_vector(7 downto 0);
        b_in  : in  std_logic_vector(7 downto 0);
        c_in  : in  std_logic_vector(7 downto 0);
        op_in : in  std_logic_vector(7 downto 0);
   
        a_out  : out std_logic_vector(7 downto 0);
        b_out  : out std_logic_vector(7 downto 0);
        c_out  : out std_logic_vector(7 downto 0);
        op_out : out std_logic_vector(7 downto 0);
        Alea  :  in std_logic;
        clk    : in std_logic
    );
end interface_memory;

architecture Behavioral of interface_memory is
    signal a_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal b_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal c_out_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal op_out_reg : std_logic_vector(7 downto 0) := (others => '0');
    
    signal a_mem  : std_logic_vector(7 downto 0) := (others => '0');
    signal b_mem  : std_logic_vector(7 downto 0) := (others => '0');
    signal c_mem  : std_logic_vector(7 downto 0) := (others => '0');
    signal op_mem : std_logic_vector(7 downto 0) := (others => '0');
    signal alea_raised : std_logic := '0';
begin
    a_out <= a_out_reg ;
    b_out <= b_out_reg ;
    c_out <= c_out_reg ;
    op_out <= op_out_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            if Alea = '0' then
                if alea_raised = '0' then
                    a_out_reg  <= a_in;
                    b_out_reg  <= b_in;
                    c_out_reg  <= c_in;
                    op_out_reg <= op_in;
                else
                    a_out_reg  <= a_mem;
                    b_out_reg  <= b_mem;
                    c_out_reg  <= c_mem;
                    op_out_reg <= op_mem;
                    alea_raised <= '0';
                end if;
            else
                if alea_raised = '0' then
                    a_mem  <= a_in;
                    b_mem <= b_in;
                    c_mem  <= c_in;
                    op_mem <= op_in;
                    alea_raised <='1';
                end if;
                    a_out_reg  <= "00000000";
                    b_out_reg  <= "00000000";
                    c_out_reg  <= "00000000";
                    op_out_reg <= "00000000";
            end if;
        end if;
    end process;
end Behavioral;
