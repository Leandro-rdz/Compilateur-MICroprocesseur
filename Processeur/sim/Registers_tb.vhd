library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Registers_tb is
end Registers_tb;

architecture Behavioral of Registers_tb is
    component registers is
        Port(
            ADA   : in  std_logic_vector(3 downto 0);
            ADB   : in  std_logic_vector(3 downto 0);
            ADW   : in  std_logic_vector(3 downto 0);
            W     : in  std_logic;
            Data  : in  std_logic_vector(7 downto 0);
            RST   : in  std_logic;
            CLK   : in  std_logic;
            QA    : out std_logic_vector(7 downto 0);
            QB    : out std_logic_vector(7 downto 0)
        );
    end component;

    signal ADA, ADB, ADW : std_logic_vector(3 downto 0);
    signal W             : std_logic;
    signal Data          : std_logic_vector(7 downto 0);
    signal RST           : std_logic;
    signal CLK           : std_logic := '0';
    signal QA, QB        : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: registers
        port map (
            ADA => ADA,
            ADB => ADB,
            ADW => ADW,
            W   => W,
            Data => Data,
            RST => RST,
            CLK => CLK,
            QA => QA,
            QB => QB
        );

    clk_process : process
    begin
        while now < 500 ns loop
            CLK <= '0';
            wait for clk_period / 2;
            CLK <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;


    stim_proc : process
    begin
        W     <= '0';
        RST   <= '1';
        ADA   <= (others => '0');
        ADB   <= (others => '0');
        ADW   <= (others => '0');
        Data  <= (others => '0');

        wait for 100 ns;
        
        -- Appliquer un reset
        RST <= '0';
        wait for clk_period;
        RST <= '1';
        wait for clk_period;

        -- Écriture dans le registre 3 avec 0xAA
        ADW  <= "0011";        -- Adresse 3
        Data <= x"AA";
        W    <= '1';
        wait for clk_period;

        -- Désactivation écriture
        W <= '0';

        -- Lecture du registre 3 sur QA, 0 sur QB
        ADA <= "0011";         -- QA ← R3
        ADB <= "0000";         -- QB ← R0 (devrait être 0x00)
        wait for 100 ns;         -- Temps pour lecture combinatoire

        assert QA = x"AA" report "Erreur: lecture R3 incorrecte" severity error;
        assert QB = x"00" report "Erreur: lecture R0 incorrecte" severity error;

        -- Lecture double : R3 et R3 (les deux doivent être 0xAA)
        ADA <= "0011";
        ADB <= "0011";
        wait for 100 ns;
        assert QA = x"AA" and QB = x"AA" report "Erreur: lecture double incorrecte" severity error;

        -- Test bypass : écriture et lecture sur même registre
        ADW  <= "0101";        -- Registre 5
        ADA  <= "0101";        -- Lecture A sur même registre
        Data <= x"55";
        W    <= '1';
        wait for 1 ns;         -- court délai pour tester combinatoire
        wait for clk_period;

        -- Lecture après écriture, bypass devrait forcer QA ← 0x55 directement
        W <= '0';
        wait for 100 ns;

        assert QA = x"55" report "Erreur: bypass D->QA non fonctionnel" severity error;

        wait;

    end process;

end Behavioral;
