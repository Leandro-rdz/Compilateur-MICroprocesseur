library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hazard_detection is
    Port(
        CLK    : in  std_logic;
        RST : in std_logic;
        ALEA : out std_logic;
        A2 : in std_logic_vector(7 downto 0);
        B2 : in std_logic_vector(7 downto 0);
        C2 : in std_logic_vector(7 downto 0);
        OP2: in std_logic_vector(7 downto 0);
        A3 : in std_logic_vector(7 downto 0);
        B3 : in std_logic_vector(7 downto 0);
        C3 : in std_logic_vector(7 downto 0);
        OP3: in std_logic_vector(7 downto 0);
        A4 : in std_logic_vector(7 downto 0);
        B4 : in std_logic_vector(7 downto 0);
        OP4: in std_logic_vector(7 downto 0);
        A5 : in std_logic_vector(7 downto 0);
        B5 : in std_logic_vector(7 downto 0);
        OP5: in std_logic_vector(7 downto 0)
    );
end hazard_detection;

architecture Behavioral of hazard_detection is
    constant OP_NOP   : std_logic_vector(7 downto 0) := "00000000";
    constant OP_COP   : std_logic_vector(7 downto 0) := "00100000";
    constant OP_AFC   : std_logic_vector(7 downto 0) := "00100001";
    constant OP_JMP   : std_logic_vector(7 downto 0) := "00100010";
    constant OP_JMPF  : std_logic_vector(7 downto 0) := "00100011";
    constant OP_LOAD  : std_logic_vector(7 downto 0) := "00100101";
    constant OP_STORE : std_logic_vector(7 downto 0) := "00100110";

begin
    process(A2,B2,C2,OP2,A3,B3,C3,OP3,A4,B4,OP4,A5,B5,OP5)
    begin
            -- Détection d'aléa 
            if (
            ((OP2(7 downto 4) = "0001" or OP2 = OP_COP or OP2 = OP_STORE)
             and (
             (OP3 /= OP_NOP and OP3 /= OP_JMP and OP3 /= OP_JMPF and OP3 /= OP_STORE and (A3 = B2 or A3 = C2)) or
             (OP4 /= OP_NOP and OP4 /= OP_JMP and OP4 /= OP_JMPF and OP4 /= OP_STORE and (A4 = B2 or A4 = C2)) or
             (OP5 /= OP_NOP and OP5 /= OP_JMP and OP5 /= OP_JMPF and OP5 /= OP_STORE and (A5 = B2 or A5 = C2))
              ) 
             )) 
             or OP3 = OP_JMP or OP4 = OP_JMP or OP3 = OP_JMPF or OP4 = OP_JMPF 
             then
                ALEA <= '1';

            -- Aucun aléa détecté

            else
                ALEA <= '0';
            end if;
    end process;


end Behavioral;