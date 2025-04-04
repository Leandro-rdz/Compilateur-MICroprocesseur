library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component ALU
    Port(
         A   : in  std_logic_vector(7 downto 0);
         B   : in  std_logic_vector(7 downto 0);
         S   : out std_logic_vector(7 downto 0);
         SEL : in  std_logic_vector(2 downto 0);
         CAR : out std_logic;
         OVF : out std_logic;
         NEG : out std_logic;
         NUL : out std_logic
        );
    end component;

    --Inputs
    signal A : std_logic_vector(7 downto 0) := (others => '0');
    signal B : std_logic_vector(7 downto 0) := (others => '0');
    signal SEL : std_logic_vector(2 downto 0) := (others => '0');

    --Outputs
    signal S : std_logic_vector(7 downto 0);
    signal CAR : std_logic;
    signal OVF : std_logic;
    signal NEG : std_logic;
    signal NUL : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ALU Port map (
          A => A,
          B => B,
          S => S,
          SEL => SEL,
          CAR => CAR,
          OVF => OVF,
          NEG => NEG,
          NUL => NUL
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Addition avec Carry (A + B > 255)
        A <= "10000001";  -- 129
        B <= "10000010";  -- 130
        SEL <= "000";  -- Addition
        wait for 100 ns; -- Attendre 100 ns pour voir les résultats

        -- Test case 2: Addition sans Carry (A + B <= 255)
        A <= "01000001";  -- 65
        B <= "01000001";  -- 65
        SEL <= "000";  -- Addition
        wait for 100 ns;

        -- Test case 3: Soustraction (A > B, A - B)
        A <= "00000100";  -- 4
        B <= "00000010";  -- 2
        SEL <= "001";  -- Soustraction
        wait for 100 ns;

        -- Test case 4: Soustraction avec résultat négatif (B > A)
        A <= "00000010";  -- 2
        B <= "00000100";  -- 4
        SEL <= "001";  -- Soustraction
        wait for 100 ns;

        -- Test case 5: Multiplication avec Overflow (A * B > 255)
        A <= "11100001";  -- 225
        B <= "10100000";  -- 160
        SEL <= "010";  -- Multiplication
        wait for 100 ns;

        -- Test case 6: Multiplication sans Overflow (A * B <= 255)
        A <= "00000011";  -- 3
        B <= "00000101";  -- 5
        SEL <= "010";  -- Multiplication
        wait for 100 ns;

        -- Test case 7: Division entiere (B != 0)
        A <= "11100001";  -- 225
        B <= "11100001";  -- 225
        SEL <= "100";  -- Division
        wait for 100 ns;
        
        -- Test case 8: Division non entiere (B != 0)
        A <= "11100001";  -- 225
        B <= "00000111";  -- 7
        SEL <= "100";  -- Division
        wait for 100 ns;
        
        
        -- Test case 9: Division par 0 (B = 0)
        A <= "11100001";  -- 225
        B <= "00000000";  -- 5
        SEL <= "100";  -- Division
        wait for 100 ns;
        
        -- Test case 10: AND
        A <= "00001111";  -- 15
        B <= "11110000";  -- 240
        SEL <= "011";  -- AND
        wait for 100 ns;

        -- Test case 11: OR
        A <= "00001111";  -- 15
        B <= "11110000";  -- 240
        SEL <= "111";  -- OR
        wait for 100 ns;

        -- Test case 12: XOR
        A <= "00001111";  -- 15
        B <= "11110000";  -- 240
        SEL <= "101";  -- XOR
        wait for 100 ns;

        -- Test case 13: NOT A
        A <= "00001111";  -- 15
        SEL <= "110";  -- NOT A
        wait for 100 ns;
        
        wait;
    end process;

end Behavioral;
