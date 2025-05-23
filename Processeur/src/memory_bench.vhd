-- Data Memory (8-bit wide, 8-bit address)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
  port(
    Addr     : in  std_logic_vector(7 downto 0);  -- Address input
    Data_In  : in  std_logic_vector(7 downto 0);  -- Data input to write
    RW       : in  std_logic;                     -- Read/Write control: '1'=Read, '0'=Write
    RST      : in  std_logic;                     -- Synchronous reset: initialize all to 0x00
    CLK      : in  std_logic;                     -- Clock
    Data_Out : out std_logic_vector(7 downto 0)   -- Data output for read
  );
end entity;

architecture Behavioral of Data_Memory is
  type mem_array is array (0 to 2**8-1) of std_logic_vector(7 downto 0);
  signal mem     : mem_array := (others => (others => '0'));
  signal out_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(CLK, RW)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
              for i in mem'range loop
                mem(i) <= (others => '0');
              end loop;
              out_reg <= (others => '0');
            elsif RW = '0' then
              -- Write operation
              mem(to_integer(unsigned(Addr))) <= Data_In;
            end if;
            end if;
            
            if falling_edge(CLK) and RW = '1' then
              -- Read operation
            out_reg <= mem(to_integer(unsigned(Addr)));
        end if;
    end process;


  -- Output driver
  Data_Out <= out_reg;
end architecture;


-- Instruction Memory (32-bit wide, 8-bit address, read-only)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instr_Memory is
  port(
    Addr      : in  std_logic_vector(7 downto 0);   -- Address input
    CLK       : in  std_logic;                      -- Clock (synchronous read)
    Instr_Out : out std_logic_vector(31 downto 0)   -- Instruction output
  );
end entity;

architecture Behavior of Instr_Memory is
  type mem_array  is array (0 to 2**8-1) of std_logic_vector(31 downto 0);
  -- Preload your program here via initialization or via a file read at elaboration
  constant rom : mem_array := (
--    --ADD 
--     0 => x"00000000",   -- NOP        
--    1 => x"21000100",  -- AFC R0, 1   
--    2 => x"21010400",  -- AFC R1, 4   
--    3 => x"10020001",  -- ADD R2,R1,R0
--    --SOU                             
--    4 => x"21031000",  -- AFC R3, 16  
--    5 => x"21040400",  -- AFC R4, 4   
--    6 => x"11050304",  -- SOU R5,R3,R4
--    --MUL                             
--    7 => x"21061200",  -- AFC R6, 18  
--    8 => x"21070200",  -- AFC R7, 2   
--    9 => x"12080706",  -- MUL R8,R7,R6
--    --DIV                             
--    10 => x"21090800",  -- AFC R9, 8  
--    11 => x"210A5000",  -- AFC R10, 80
--    12 => x"130B0A09",  -- DIV R11,R10
--    --AND                             
--    13 => x"210C0800",  -- AFC R12, 8 
--    14 => x"210D0F00",  -- AFC R13, 15
--    15 => x"140E0D0C",  -- AND R14,R13
--    --OR                              
--    16 => x"21000800",  -- AFC R0, 8   
--    17 => x"21011000",  -- AFC R1, 16 
--    18 => x"15020100",  -- OR R2,R1,R0
--    --XOR                             
--    19 => x"21030800",  -- AFC R3, 8   
--    20 => x"21041800",  -- AFC R4, 24 
--    21 => x"16050403",  -- XOR R5,R4,R3
--    --NOT
--    22 => x"21060100",  -- AFC R6, 1   
--    23 => x"17070600",  -- NOT R7,R6
--    --INF                             
--    24 => x"21081000",  -- AFC R8, 16  
--    25 => x"21090800",  -- AFC R9, 8 
--    26 => x"180A0908",  -- INF R10,R9,R8
--    27 => x"180B0809",  -- INF R11,R8,R9
--    --INFE                             
--    28 => x"210C1000",  -- AFC R12, 16  
--    29 => x"210D0800",  -- AFC R13, 8 
--    30 => x"210E0800",  -- AFC R14, 8 
--    31 => x"190F0C0E",  -- INFE R15,R13,R12
--    32 => x"19000E0C",  -- INFE R0,R12,R13
--    33 => x"19010D0E",  -- INFE R1,R13,R12
--    --SUP                             
--    34 => x"21021100",  -- AFC R2, 17  
--    35 => x"21032800",  -- AFC R3, 40 
--    36 => x"1A040302",  -- SUP R10,R3,R2
--    37 => x"1A050203",  -- SUP R11,R2,R3
--    --SUPE                             
--    38 => x"21061100",  -- AFC R6, 17  
--    39 => x"21072800",  -- AFC R7, 40
--    40 => x"21082800",  -- AFC R8, 40 
--    41 => x"1B090607",   -- SUPE R9,R6,R7
--    42 => x"1B0A0706",  -- SUPE R10,R7,R6
--    43 => x"1B0B0708",  -- SUPE R11,R7,R8
--    --EQU                             
--    44 => x"210C2100",  -- AFC R12, 33  
--    45 => x"210D2800",  -- AFC R13, 40
--    46 => x"210E2800",  -- AFC R14, 40  
--    47 => x"1C0F0C0D",  -- EQU R15,R12,R13
--    48 => x"1C000D0E",  -- EQU R0,R13,R14
    
--    --COP
--    49 => x"200C0D00",  -- COP R1, R13

--    --LOAD et STORE                      
--    50 => x"00000000",   -- NOP        
--    51 => x"21021300",  -- AFC R2, 19   
--    52 => x"26100200",  -- STORE @10, R2
--    53 => x"25031000",  -- LOAD R3, @10
    
    
--    --JUMP ET JUMPF
--    --0 => x"00000000",   -- NOP
--    --1 => x"21000100",   -- AFC R0, 1
--    --2 => x"21010100",   -- AFC R1, 1
--    --3 => x"10000100",   -- ADD R0,R1,R0
--    --4 => x"22030000",   -- JUMP to instr 3
--    others => (others => '0')
    0 => x"00000000",
    1 => x"21000100",
    2 => x"26040000",
    3 => x"25000400",
    4 => x"23180000",
    5 => x"25000500",
    6 => x"29000300",
    7 => x"26050000",
    8 => x"25000500",
    9 => x"26010000",
    10 => x"25000500",
    11 => x"29000400",
    12 => x"26050000",
    13 => x"25000500",
    14 => x"26020000",
    15 => x"25000100",
    16 => x"25010200",
    17 => x"10020001",
    18 => x"26050200",
    19 => x"25000500",
    20 => x"26030000",
    21 => x"25000300",
    22 => x"24010000",
    23 => x"22010000",
    24 => x"21000000",
    25 => x"26050000",
    others => (others => '0')


  );
  --signal out_reg : std_logic_vector(31 downto 0);
begin
  Instr_Out <= rom(to_integer(unsigned(Addr)));
end architecture;