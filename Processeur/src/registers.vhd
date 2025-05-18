library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity registers is
    Port(
        ADA   : in  std_logic_vector(7 downto 0);
        ADB   : in  std_logic_vector(7 downto 0);
        ADW   : in  std_logic_vector(7 downto 0);
        W     : in  std_logic;
        Data  : in  std_logic_vector(7 downto 0);
        RST   : in  std_logic;
        CLK   : in  std_logic;
        QA    : out std_logic_vector(7 downto 0);
        QB    : out std_logic_vector(7 downto 0) 
    );
end registers;

Architecture Behavior of registers is
    -- 16 registres de 8 bits initialisés à 0
    type reg_array is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal regfile : reg_array := (others => (others => '0'));
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                regfile <= (others => (others => '0'));
            elsif W = '1' then
                -- on écrit si W=1
                regfile(to_integer(unsigned(ADW))) <= Data;
            end if;
        end if;
    end process;

    process(ADA, ADB, ADW, W, Data, regfile)
    begin
    if to_integer(unsigned(ADA))<16 and to_integer(unsigned(ADB))<16 then 
        -- Lecture port A avec bypass
        if W = '1' and ADA = ADW then
            QA <= Data;
        else
            QA <= regfile(to_integer(unsigned(ADA)));
        end if;

        -- Lecture port B avec bypass
        if W = '1' and ADB = ADW then
            QB <= Data;
        else
            QB <= regfile(to_integer(unsigned(ADB)));
        end if;
    end if;
    end process;

end Behavior;


