library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port(
        ADA   : in  std_logic_vector(3 downto 0);
        ADB   : in  std_logic_vector(3 downto 0);
        ADW   : in  std_logic_vector(3 downto 0);
        S   : out std_logic_vector(7 downto 0);
        SEL : in  std_logic_vector(2 downto 0);
        CAR : out std_logic;
        OVF : out std_logic;
        NEG : out std_logic;
        NUL : out std_logic
    );
end ALU;

ARCHITECTURE Behavior OF ALU IS
    SIGNAL result : std_logic_vector(8 DOWNTO 0); 
    SIGNAL car_out : std_logic;
    SIGNAL ovf_out : std_logic;
    SIGNAL neg_out : std_logic;
    SIGNAL nul_out : std_logic;
BEGIN

END Behavior;