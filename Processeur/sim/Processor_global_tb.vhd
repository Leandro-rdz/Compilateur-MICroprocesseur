library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Test is
end Test;

architecture Behavioral of Test is

    signal CLK : std_logic := '0';

    signal contr_ld1, contr_ld2 :std_logic_vector(7 downto 0) := "00000010";
    signal contr_itr1 : std_logic_vector(7 downto 0) := "00001010"; --10 donc 0xA
    signal contr_itr2 : std_logic_vector(7 downto 0) := "00000110"; -- 0x6
    signal contr_btn : std_logic_vector(4 downto 0) := (others => '0');

    -- Instance du processeur
    component processor
        Port (
            CLK : in std_logic;
            contr_ld1   : out std_logic_vector(7 downto 0); -- contraintes board FPGA
            contr_ld2   : out std_logic_vector(7 downto 0); -- contraintes board FPGA
            contr_itr1  : in std_logic_vector(7 downto 0);  -- contraintes board FPGA
            contr_itr2  : in std_logic_vector(7 downto 0);  -- contraintes board FPGA
            contr_btn   : in std_logic_vector(4 downto 0)   -- contraintes board FPGA
        );
    end component;

begin
    
    -- Instanciation de l'entité processor
    uut: processor
        port map (
            CLK => CLK,
            contr_ld1  => contr_ld1,
            contr_ld2  => contr_ld2,
            contr_itr1 => contr_itr1,
            contr_itr2 => contr_itr2,
            contr_btn  => contr_btn
        );
    -- Processus de génération de l'horloge
    clk_process : process
    begin
        while now < 1 ms loop
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

end Behavioral;
