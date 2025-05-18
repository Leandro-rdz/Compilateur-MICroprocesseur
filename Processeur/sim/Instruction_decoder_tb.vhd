library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;

entity Instruction_decoder_tb is
end Instruction_decoder_tb;

architecture Behavioral of Instruction_decoder_tb is
  component Instruction_decoder
    port (
      Instruction : in std_logic_vector(31 downto 0);
      A : out std_logic_vector(7 downto 0);
      B : out std_logic_vector(7 downto 0);
      C : out std_logic_vector(7 downto 0);
      OP : out std_logic_vector(3 downto 0)
    );
  end component;

  signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
  signal A, B, C : std_logic_vector(7 downto 0);
  signal OP : std_logic_vector(3 downto 0);

begin

  uut: Instruction_decoder
    port map (
      Instruction => Instruction,
      A => A,
      B => B,
      C => C,
      OP => OP
    );

  stimulus: process
  begin
    -- Test 1 : "0B0E0E0F" = x"0B0E0E0F"
    Instruction <= x"0B0E0E0F";
    wait for 100 ns;

    -- Test 2 : OP=F, A=10, B=20, C=30 -> F ignoré
    Instruction <= x"F102030F";  -- derniers bits ignorés
    wait for 100 ns;

    -- Test 3 : OP=A, A=FF, B=00, C=55 -> A ignoré
    Instruction <= x"AFF0055A";
    wait for 100 ns;

    -- Test 4 : OP=5, A=AA, B=BB, C=CC -> D ignoré
    Instruction <= x"5AABBCCD";
    wait for 100 ns;

    wait;
  end process;

end Behavioral;
