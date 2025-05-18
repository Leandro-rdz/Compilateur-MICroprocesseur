library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_decoder is
  port(
    Instruction : in std_logic_vector(31 downto 0);
    A : out std_logic_vector(7 downto 0);
    B : out std_logic_vector(7 downto 0);
    C : out std_logic_vector(7 downto 0);
    OP : out std_logic_vector(7 downto 0)
  );
end Instruction_decoder;

architecture Behavioral of Instruction_decoder is
begin

  -- Assign bits based on given format:
  -- Instruction(31 downto 28) -> OP
  -- Instruction(27 downto 20) -> A
  -- Instruction(19 downto 12) -> B
  -- Instruction(11 downto 4)  -> C
  -- Instruction(3 downto 0) is ignored

  OP <= Instruction(31 downto 24);
  A  <= Instruction(23 downto 16);
  B  <= Instruction(15 downto 8);
  C  <= Instruction(7 downto 0);

end Behavioral;
