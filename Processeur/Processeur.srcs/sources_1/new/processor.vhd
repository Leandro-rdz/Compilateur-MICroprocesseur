library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor is
    Port (
        ADA  : in std_logic_vector(3 downto 0);  -- Adresse lecture A
        ADB  : in std_logic_vector(3 downto 0);  -- Adresse lecture B
        ADW  : in std_logic_vector(3 downto 0);  -- Adresse écriture
        W    : in std_logic;                    -- Signal d'écriture
        RST  : in std_logic;                    -- Reset
        CLK  : in std_logic;                    -- Horloge
        SEL  : in std_logic_vector(2 downto 0); -- Sélection d'opération ALU
        S    : out std_logic_vector(7 downto 0);-- Résultat ALU
        CAR  : out std_logic;
        OVF  : out std_logic;
        NEG  : out std_logic;
        NUL  : out std_logic
    );
end processor;

architecture Behavioral of processor is

    -- Signaux internes pour liaison entre les modules
    signal QA, QB, QC : std_logic_vector(7 downto 0);
    signal OP : std_logic_vector(3 downto 0);
    signal result : std_logic_vector(7 downto 0);

begin

    -- Instanciation du banc de registres
    regfile_inst : entity work.registers
        port map (
            ADA   => ADA,
            ADB   => ADB,
            ADW   => ADW,
            W     => W,
            Data  => result,  -- Résultat ALU à écrire
            RST   => RST,
            CLK   => CLK,
            QA    => QA,
            QB    => QB
        );

    -- Instanciation de l'ALU
    alu_inst : entity work.ALU
        port map (
            A   => QA,
            B   => QB,
            S   => result, -- Résultat à écrire et à renvoyer
            SEL => SEL,
            CAR => CAR,
            OVF => OVF,
            NEG => NEG,
            NUL => NUL
        );

    -- Propagation du résultat vers l'extérieur
    S <= result;

end Behavioral;