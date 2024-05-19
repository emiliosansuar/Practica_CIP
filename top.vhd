
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port(
        clock_top           : in std_logic;
        reset_top           : in std_logic;
        Run_mode  : in std_logic; -- init = 1 / execute = 0

        WADDR_init : in std_logic_vector(31 downto 0);   --dirección donde escribir
        WDATA_init : in std_logic_vector(31 downto 0);   --dato a escribir
        WAVALID_init : in std_logic;     --validación de la dirección de escritura
        WDATAV_init : in std_logic;      --validación del dato

        WRESP_init : out std_logic_vector(1 downto 0);  --respuesta de la escritura
        WRESPV_init : out std_logic
    );

end entity;

architecture top_arch of top is
    
    component control_unit is

        port(
            clock : in std_logic;     --validación de la lectura
            reset : in std_logic;
            
            --MEMORIA
            --entradas i salidas para escritura
            WADDR : out std_logic_vector(31 downto 0);   --dirección donde escribir
            WDATA : out std_logic_vector(31 downto 0);   --dato a escribir
            WAVALID : out std_logic;     --validación de la dirección de escritura
            WDATAV : out std_logic;      --validación del dato
        
            WRESP : in std_logic_vector(1 downto 0);  --respuesta de la escritura
            WRESPV : in std_logic;     --validación de la escritura
        
            --entradas i salidas para lectura
            RADDR : out std_logic_vector(31 downto 0);   --dirección donde leer
            RAVALID : out std_logic;     --validacion de la dirección de lectura
        
            RDATA : in std_logic_vector(31 downto 0);   --dato leido
            RRESP : in std_logic_vector(1 downto 0);  --respuesta de la lectura
            RDATAV : in std_logic     --validación de la lectura
        );
    end component;

    component memoria is
        port
        (
            clock : in std_logic;     --validación de la lectura

            --entradas i salidas para escritura
            WADDR : in std_logic_vector(5 downto 0);   --dirección donde escrivir
            WDATA : in std_logic_vector(31 downto 0);   --dato a escrivir
            WAVALID : in std_logic;     --validacion de la dirección de escritura
            WDATAV : in std_logic;      --validacion del dato

            WRESP : out std_logic_vector(1 downto 0);  --respuesta de la escritura
            WRESPV : out std_logic;     --validación de la escritura

            --entradas i salidas para lectura
            RADDR : in std_logic_vector(5 downto 0);   --dirección donde leer
            RAVALID : in std_logic;     --validacion de la dirección de lectura

            RDATA : out std_logic_vector(31 downto 0);   --dato leido
            RRESP : out std_logic_vector(1 downto 0);  --respuesta de la lectura
            RDATAV : out std_logic     --validación de la lectura
        );
    end component;

    signal WADDR_control_unit   : std_logic_vector(31 downto 0);
    signal WDATA_control_unit   : std_logic_vector(31 downto 0);
    signal WAVALID_control_unit : std_logic;
    signal WDATAV_control_unit  : std_logic;

    signal WRESP_control_unit   : std_logic_vector(1 downto 0);
    signal WRESPV_control_unit  : std_logic;

    signal RADDR_control_unit   : std_logic_vector(31 downto 0);   --dirección donde leer
    signal RAVALID_control_unit : std_logic;     --validacion de la dirección de lectura

    signal RDATA_control_unit   : std_logic_vector(31 downto 0);   --dato leido
    signal RRESP_control_unit   : std_logic_vector(1 downto 0);  --respuesta de la lectura
    signal RDATAV_control_unit  : std_logic;

    signal WADDR_mux   : std_logic_vector(31 downto 0);
    signal WDATA_mux   : std_logic_vector(31 downto 0);
    signal WAVALID_mux : std_logic;
    signal WDATAV_mux  : std_logic;

    signal WRESP_mux   : std_logic_vector(1 downto 0);
    signal WRESPV_mux  : std_logic;

begin
    
    bloque_control_unit : control_unit
    port map(
        clock => clock_top,
        reset => reset_top,

        --entradas i salidas para escritura
        WADDR => WADDR_control_unit,
        WDATA => WDATA_control_unit,
        WAVALID => WAVALID_control_unit,
        WDATAV => WDATAV_control_unit,
    
        WRESP => WRESP_control_unit,
        WRESPV => WRESPV_control_unit,
    
        --entradas i salidas para lectura
        RADDR => RADDR_control_unit,
        RAVALID => RAVALID_control_unit,
    
        RDATA => RDATA_control_unit,
        RRESP => RRESP_control_unit,
        RDATAV => RDATAV_control_unit
    );

    bloque_memoria : memoria
    port map(
        clock => clock_top,

        --entradas i salidas para escritura
        WADDR => WADDR_mux(5 downto 0),
        WDATA => WDATA_mux,
        WAVALID => WAVALID_mux,
        WDATAV => WDATAV_mux,
    
        WRESP => WRESP_mux,
        WRESPV => WRESPV_mux,
    
        --entradas i salidas para lectura
        RADDR => RADDR_control_unit(5 downto 0),
        RAVALID => RAVALID_control_unit,
    
        RDATA => RDATA_control_unit,
        RRESP => RRESP_control_unit,
        RDATAV => RDATAV_control_unit
    );


    WADDR_mux   <=  WADDR_control_unit when Run_mode = '0' else
                    WADDR_init;

    WDATA_mux   <=  WDATA_control_unit when Run_mode = '0' else
                    WDATA_init;

    WAVALID_mux <=  WAVALID_control_unit when Run_mode = '0' else
                    WAVALID_init;

    WDATAV_mux  <=  WDATAV_control_unit when Run_mode = '0' else
                    WDATAV_init;

    WRESP_init  <=  "00" when Run_mode = '0' else
                    WRESP_mux;

    WRESPV_init  <= '0' when Run_mode = '0' else
                    WRESPV_mux;

end architecture;