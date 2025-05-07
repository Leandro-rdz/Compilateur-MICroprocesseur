library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Test is
end Test;

architecture Behavioral of Test is

    signal CLK : std_logic := '0';

    -- Instance du processeur
    component processor
        Port (
            CLK : in std_logic
        );
    end component;

begin
    
    -- Instanciation de l'entité processor
    uut: processor
        port map (
            CLK => CLK
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
