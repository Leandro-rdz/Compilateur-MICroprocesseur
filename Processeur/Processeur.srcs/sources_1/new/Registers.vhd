library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registers is
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
end registers;

ARCHITECTURE Behavior OF registers IS

BEGIN

END Behavior;