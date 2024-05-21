
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_top is
end entity;


architecture arch1 of tb_top is

    component top is
        port(
            clock_top           : in std_logic;
            reset_top           : in std_logic;
            Run_mode  : in std_logic; -- init = 0 / execute = 1

            WADDR_init : in std_logic_vector(31 downto 0);   --dirección donde escribir
            WDATA_init : in std_logic_vector(31 downto 0);   --dato a escribir
            WAVALID_init : in std_logic;     --validación de la dirección de escritura
            WDATAV_init : in std_logic;      --validación del dato

            WRESP_init : out std_logic_vector(1 downto 0);  --respuesta de la escritura
            WRESPV_init : out std_logic
        );

    end component;

    signal clock_top_tb    : std_logic := '0';
    signal reset_top_tb    : std_logic;
    signal Run_mode_tb     : std_logic; -- init = 0 / execute = 1

    signal WADDR_init_tb   : std_logic_vector(31 downto 0);   --dirección donde escribir
    signal WDATA_init_tb   : std_logic_vector(31 downto 0);   --dato a escribir
    signal WAVALID_init_tb : std_logic;     --validación de la dirección de escritura
    signal WDATAV_init_tb  : std_logic;      --validación del dato

    signal WRESP_init_tb   : std_logic_vector(1 downto 0);  --respuesta de la escritura
    signal WRESPV_init_tb  : std_logic;

begin

    top_block : top
    port map(
        clock_top => clock_top_tb,
        reset_top => reset_top_tb,
        Run_mode  => Run_mode_tb,

        WADDR_init => WADDR_init_tb,
        WDATA_init => WDATA_init_tb,
        WAVALID_init => WAVALID_init_tb,
        WDATAV_init => WDATAV_init_tb,

        WRESP_init => WRESP_init_tb,
        WRESPV_init => WRESPV_init_tb
    );

    clock_top_tb <= not clock_top_tb after 5 ns;

    process
    begin
        Run_mode_tb <= '0';
        reset_top_tb <= '1';
	    WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';

        wait for 20 ns;

        WADDR_init_tb <= "00000000000000000000000000100000"; -- dirección del contenido
        WDATA_init_tb <= "00000000000000000000000000001000"; -- contenido de la memoria (8)
        wait for 10 ns;

        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------

        WADDR_init_tb <= "00000000000000000000000000100001";
        WDATA_init_tb <= "00000000000000000000000000001010";--10
        wait for 10 ns;

        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000000"; --instrucción 1
        WDATA_init_tb <= "00010000000001000001000000100000"; -- bank_rg(1) + 32 => bank_reg(1)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000001"; --instrucción 2
        WDATA_init_tb <= "00010000000010000010000000000010"; -- bank_rg(2) + 2 => bank_reg(2)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000010"; --instrucción 3
        WDATA_init_tb <= "01110000000011000000000001000000"; -- load de la posicion 32 de memorio (8) => bank_reg(3)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000011"; --instrucción 4
        WDATA_init_tb <= "00000000000100000000000001000011"; -- bank_reg(1)[32] + bank_reg(3)[8] => bank_reg(4)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000100"; --instrucción 5
        WDATA_init_tb <= "10000000000100000000000100000000"; -- store en la posicion 40 de (8 + 32)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000101"; --instrucción 6
        WDATA_init_tb <= "11010000001000000000000010000001"; -- jump conditional sin jump
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000110"; --instrucción 7
        WDATA_init_tb <= "11010000000011000000000001000001"; -- jump conditional con jump
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000111"; --instrucción 8
        WDATA_init_tb <= "10110000000101000000000011000010"; -- shift right (2 posiciones)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000001000"; --instrucción 9
        WDATA_init_tb <= "10100000000110000000000011000011"; -- shift left (8 posiciones)
                          
        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        


        


        

        Run_mode_tb <= '1';
        reset_top_tb <= '0';
        wait for 30 ns;
        wait;
    end process;

end architecture;

-- rs = y // rt = x // rd = z // constat = C
    --  
    -- "00000000zzzzzz000000yyyyyyxxxxxx" -> ADD operation                RRR
    -- "00010000zzzzzzxxxxxx0000CCCCCCCC" -> ADD inmediate operation      RRImm
    -- "00100000zzzzzz000000yyyyyyxxxxxx" -> Substract operation          RRR
    -- "00110000zzzzzz000000yyyyyyxxxxxx" -> Or operation                 RRR
    -- "01000000zzzzzz000000yyyyyyxxxxxx" -> Xor operation                RRR
    -- "01010000zzzzzz000000yyyyyyxxxxxx" -> And operation                RRR
    -- "01100000zzzzzz000000yyyyyy000000" -> Not operation                RR
    -- "01110000zzzzzz000000yyyyyy000000" -> Load operation               RR
    -- "10000000zzzzzz000000yyyyyy000000" -> Store operation              RR
    -- "10010000zzzzzz000000yyyyyyxxxxxx" -> Compare operation            RRR
    -- "10100000zzzzzz000000yyyyyyxxxxxx" -> Shift left operation         RRR
    -- "10110000zzzzzz000000yyyyyyxxxxxx" -> Shift right operation        RRR
    -- "11000000zzzzzz000000000000000000" -> Jumpt/branch operation       R
    -- "11010000zzzzzz000000yyyyyyxxxxxx" -> Jump/branch conditional operation  RRR