library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IO_tb is
-- Entité vide pour un banc de test
end IO_tb;

architecture behavior of IO_tb is

    -- Composant à tester
    component IO
        Port (
            CLK         : in std_logic;
            OP          : in std_logic_vector(7 downto 0);
            Input_addr  : in std_logic_vector(7 downto 0);
            Output_addr : in std_logic_vector(7 downto 0);
            Output      : out std_logic_vector(7 downto 0);
            Input       : in std_logic_vector(7 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal CLK         : std_logic := '0';
    signal OP          : std_logic_vector(7 downto 0) := (others => '0');
    signal Input_addr  : std_logic_vector(7 downto 0) := (others => '0');
    signal Output_addr : std_logic_vector(7 downto 0) := (others => '0');
    signal Output      : std_logic_vector(7 downto 0);
    signal Input       : std_logic_vector(7 downto 0) := (others => '0');

    -- Constante pour l'opération d'écriture
    constant PRI : std_logic_vector(7 downto 0) := "00100100";

begin

    -- Instanciation du composant
    uut: IO port map (
        CLK         => CLK,
        OP          => OP,
        Input_addr  => Input_addr,
        Output_addr => Output_addr,
        Output      => Output,
        Input       => Input
    );

    -- Génération de l'horloge : période de 10 ns
    clock_process : process
    begin
        while now < 200 ns loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus de test
    stim_proc: process
    begin
        -- Écriture dans l'element 3
        Input_addr  <= x"03";
        Input       <= x"AA";
        OP          <= PRI;
        wait for 10 ns; -- attendre un front montant

        -- Écriture dans le registre 7
        Input_addr  <= x"07";
        Input       <= x"55";
        OP          <= PRI;
        wait for 10 ns;

        -- Désactiver l'écriture
        OP <= (others => '0');

        -- Lecture du registre 3
        Output_addr <= x"03";
        wait for 10 ns;

        -- Lecture du registre 7
        Output_addr <= x"07";
        wait for 10 ns;

        -- Lecture d'une case non écrite (par ex. 0x0A)
        Output_addr <= x"0A";
        wait for 10 ns;

        wait;
    end process;

end behavior;
