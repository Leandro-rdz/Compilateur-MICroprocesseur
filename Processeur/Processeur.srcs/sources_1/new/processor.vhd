library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor is
    Port (
        CLK : in std_logic
    );
end processor;

architecture Behavioral of processor is

    -- Signaux internes pour liaison entre les modules
    signal instruction_pointer : std_logic_vector(7 downto 0) := (others => '0');
    signal instruction_selected : std_logic_vector(31 downto 0) := (others => '0');                                 -- post fetch
    signal A1, B1, C1, OP1 : std_logic_vector(7 downto 0);                                                          -- post decode
    signal A2, B2_select_in, B2_select_out, B2_mux, C2_in, C2_out, OP2 : std_logic_vector(7 downto 0);              -- banc de registre
    signal A3, B3_alu_in, B3_alu_out, B3_mux, C3, OP3 : std_logic_vector(7 downto 0);                               -- UAL
    signal A4, B4_in, B4_mux1, B4_out, B4_mux2, OP4 : std_logic_vector(7 downto 0);                                 -- Memoire des données
    signal A5, B5, OP5 : std_logic_vector(7 downto 0);                                                              -- Avant écriture dans les bancs de registres 
    signal RW_LC, W_LC : std_logic := '0';
    
    -- signaux ignorés pour l'instant genre les FLAG de l'ALU on s'en fiche pour l'instant 
    signal IGNORED_1, IGNORED_6, IGNORED_7 : std_logic_vector(7 downto 0) := (others => '0');
    signal IGNORED_2, IGNORED_3, IGNORED_4, IGNORED_5 : std_logic := '0';
begin
    -- Instanciation de la mémoire des instructions
    instruction_counter_inst : entity work.Instr_counter
        port map (
            CLK         =>  CLK,
            Addr        =>  instruction_pointer
        );
        
    -- Instanciation de la mémoire des instructions
    instruction_memory_inst : entity work.Instr_Memory
        port map (
            Addr        =>  instruction_pointer,
            CLK         =>  CLK,
            Instr_Out   =>  instruction_selected
        );
        
    -- Instanciation du décoder d'instruction
    instruction_decoder_inst : entity work.Instruction_decoder
        port map (
          Instruction => instruction_selected,
          A => A1,
          B => B1,
          C => C1,
          OP => OP1
        );
        
    -- Instanciation de LI/DI
    li_di_inst : entity work.interface_element
        port map (
            a_in   => A1,
            b_in   => B1,
            c_in   => C1,
            op_in  => OP1,
            a_out  => A2,
            b_out  => B2_select_in,
            c_out  => C2_in,
            op_out => OP2,
            CLK    => CLK
        );

    -- Instanciation du banc de registres
    regfile_inst : entity work.registers
        port map (
            ADA   => B2_select_in,
            ADB   => C2_in,
            ADW   => A5,
            W     => W_LC, -- donner OP5 si ça correspond bien au OPCODE d'écriture dans les registres
            Data  => B5,
            RST   => '1', -- TODO ?
            CLK   => CLK,
            QA    => B2_select_out,
            QB    => C2_out
        );
       
        
    -- Instanciation de DI/EX
    di_ex_inst : entity work.interface_element
        port map (
            a_in   => A2,
            b_in   => B2_mux, -- on a B2_select_out ou B2_select_in à donner à manger ici (b_in) selon le OP2 
            c_in   => C2_out,
            op_in  => OP2,
            a_out  => A3,
            b_out  => B3_alu_in,
            c_out  => C3,
            op_out => OP3,
            CLK    => CLK
        );
        

    -- Instanciation de l'ALU
    alu_inst : entity work.ALU
        port map (
            A   => B3_alu_in,
            B   => C3,
            S   => B3_alu_out,
            SEL => OP3,
            CAR => IGNORED_2, -- FLAG IGNORED
            OVF => IGNORED_3, -- FLAG IGNORED
            NEG => IGNORED_4, -- FLAG IGNORED
            NUL => IGNORED_5  -- FLAG IGNORED
        );
        
    -- Instanciation de EX/MEM
    ex_mem_inst : entity work.interface_element
        port map (
            a_in   => A3,
            b_in   => B3_mux, -- on a B3_alu_in ou B3_alu_out à donner à manger selon le OP3
            c_in   => (others => '0'),
            op_in  => OP3,
            a_out  => A4,
            b_out  => B4_in,
            c_out  => IGNORED_6,
            op_out => OP4,
            CLK    => CLK
        );
        
    memory_inst : entity work.Data_Memory
        port map (
        Addr     => B4_mux1,
        Data_In  => B4_mux1, -- on doit donner à mux1 soit B4_in soit A4 selon la situation
        RW       => RW_LC,     -- OP4 que si ça correspond au bon OPCODE
        RST      => '0',
        CLK      => CLK,
        Data_Out => B4_out
        );
    
    -- Instanciation de MEM/RE
    mem_re_inst : entity work.interface_element
        port map (
            a_in   => A4,
            b_in   => B4_mux2, -- on a B4_in ou B4_out donner à manger selon le OP4
            c_in   => (others => '0'),
            op_in  => OP4,
            a_out  => A5,
            b_out  => B5,
            c_out  => IGNORED_7,
            op_out => OP5,
            CLK    => CLK
        );

    -- MUX Banc de registre
    B2_mux <= B2_select_in when (OP2 = "00100001" or OP2 = "00100101") else B2_select_out; -- si AFC OR LOAD
    
    -- MUX UAL
    B3_mux <= B3_alu_out when (OP3(7 downto 4) = "0001") else B3_alu_in; -- si appartient à ALU ou non
    
    -- MUX1 Mémoire de donnée
    B4_mux1 <= B4_in when (OP4 = "00100101") else A4; -- si LOAD
    
    -- LC Mémoire de donnée
    RW_LC <= '1' when (OP4 = "00100110") else '0'; -- si STORE on écrit, tout le reste on écrit pas
    
    -- MUX2 Mémoire de donnée
    B4_mux2 <= B4_out when (OP4 = "00100101") else B4_in; -- si LOAD
    
    -- LC après Mem/RE
    W_LC <= '0' when (OP4 = "00100101") else '1'; -- on écrit dans le banc de registre sauf si on store
end Behavioral;