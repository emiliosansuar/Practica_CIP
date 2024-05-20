
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

        WADDR_init_tb <= "00000000000000000000000000100000";
        WDATA_init_tb <= "00000000000000000000000000001001"; --8
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
        WADDR_init_tb <= "00000000000000000000000000000000";
        WDATA_init_tb <= "00010000000001000001000000100000";
        wait for 10 ns;

        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        WADDR_init_tb <= "00000000000000000000000000000001";
        WDATA_init_tb <= "00010000000010000010000000100001";
        wait for 10 ns;

        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------

        WADDR_init_tb <= "00000000000000000000000000000010";
        WDATA_init_tb <= "00000000000011000000000010000001";
        wait for 10 ns;

        WAVALID_init_tb <= '1';
        WDATAV_init_tb <= '1';
        wait for 20 ns;

        WAVALID_init_tb <= '0';
        WDATAV_init_tb <= '0';
        wait for 10 ns;
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        

        Run_mode_tb <= '1';
        reset_top_tb <= '0';
        wait for 30 ns;
        wait;
    end process;

end architecture;

-- rs = x // rt = y // rd = z // constat = C
    --  
    -- "00000000zzzzzz000000yyyyyyxxxxxx" -> ADD operation                RRR
    -- "00010000zzzzzzxxxxxx0000CCCCCCCC" -> ADD inmediate operation      RRImm   ++++
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