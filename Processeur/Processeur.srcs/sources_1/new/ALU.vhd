library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port(
        A   : in  std_logic_vector(7 downto 0);
        B   : in  std_logic_vector(7 downto 0);
        S   : out std_logic_vector(7 downto 0);
        SEL : in  std_logic_vector(7 downto 0);
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
    PROCESS (A, B, SEL)
    variable sum : unsigned(8 downto 0);
    BEGIN
        CASE SEL IS
            WHEN "00010000" => -- Addition
                sum := unsigned('0' & A) + unsigned('0' & B);
                result <= std_logic_vector(sum);
                
                -- Détection du Carry
                if sum > 255 then
                    car_out <= '1';
                else
                    car_out <= '0';
                end if;
                if sum = 0 then
                    nul_out <= '1';
                else
                    nul_out <= '0';
                end if;
                ovf_out  <= '0';
                neg_out  <= '0';
            WHEN "00010001" => -- Soustraction
                if ( unsigned(A) < unsigned (B)) then
                    neg_out <=  '1';
                else 
                    neg_out <= '0'; 
               end if;
               car_out    <= '0';
               ovf_out   <= '0';
               result   <= std_logic_vector(('0' & unsigned(A)) - ('0' & unsigned(B)));
               if (unsigned(A) = unsigned(B)) then
                    nul_out <= '1';
                else
                    nul_out <= '0';
                end if;
            WHEN "00010010" => -- Multiplication
                result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),9)) ;
                if (unsigned(A) * unsigned(B) > 255) then 
                ovf_out <= '1';
                else 
                ovf_out <= '0';
                end if;
                car_out    <= '0';
                neg_out   <= '0';
                if (unsigned(A) = 0 or unsigned(B)=0) then
                    nul_out <= '1';
                else
                    nul_out <= '0';
                end if;
            WHEN "00010011" => --DIV
                if (unsigned(B) =0) then 
                     nul_out <= '1';
                     car_out <= '1';
                     neg_out <= '1';
                     ovf_out <= '1';
                     result <= (OTHERS => '0');
                else     
                     result <= std_logic_vector(to_unsigned((to_integer(unsigned(A))/ to_integer(unsigned(B))),9)) ;
                     nul_out <= '0';
                     car_out <= '0';
                     neg_out <= '0';
                     ovf_out <= '0';
                end if;
            WHEN "00010100" => -- AND
                result <= ('0' & A) AND ('0' & B);
                car_out  <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
           WHEN "00010101" => -- OR
                result<= ('0' & A) OR ('0' & B);
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN "00010110" => -- XOR
                result        <= ('0' & A) XOR ('0' & B);
                car_out  <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                 nul_out <= '0';
            WHEN "00010111" => -- NOT A
                result        <= NOT ('0' & A);
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                 nul_out <= '0';
            WHEN "00011000" => -- INF
                IF ('0' & A) < ('0' & B) THEN
                    result <= (others => '0');
                    result(0) <= '1';
                ELSE
                    result <= (others => '0');  -- "faux"
                END IF;
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN "00011001" => -- INFE
                IF ('0' & A) <= ('0' & B) THEN
                    result <= (others => '0');
                    result(0) <= '1';
                ELSE
                    result <= (others => '0');  -- "faux"
                END IF;
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN "00011010" => -- SUP
                IF ('0' & A) > ('0' & B) THEN
                    result <= (others => '0');
                    result(0) <= '1';
                ELSE
                    result <= (others => '0');  -- "faux"
                END IF;
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN "00011011" => -- SUPE
                IF ('0' & A) >= ('0' & B) THEN
                    result <= (others => '0');
                    result(0) <= '1';
                ELSE
                    result <= (others => '0');  -- "faux"
                END IF;
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN "00011100" => -- EQU
                IF ('0' & A) = ('0' & B) THEN
                    result <= (others => '0');
                    result(0) <= '1';
                ELSE
                    result <= (others => '0');  -- "faux"
                END IF;
                car_out    <= '0';
                ovf_out <= '0';
                neg_out   <= '0';
                nul_out <= '0';
            WHEN OTHERS => -- Défaut
                result        <= (OTHERS => '0');
                car_out <= '0';
                ovf_out <= '0';
                nul_out <= '0';
                neg_out   <= '0';
        END CASE;
    END PROCESS;
    S <= result(7 DOWNTO 0);
    NUL <= nul_out;
    NEG <= neg_out;
    CAR <= car_out;
    OVF <= ovf_out;
END Behavior;