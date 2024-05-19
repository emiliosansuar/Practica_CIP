library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    port(
        clock_top           : in std_logic;
        reset_top           : in std_logic;
        init/!Run_mode  : in std_logic;

        WADDR_init : out std_logic_vector(31 downto 0);   --dirección donde escribir
        WDATA_init : out std_logic_vector(31 downto 0);   --dato a escribir
        WAVALID_init : out std_logic;     --validación de la dirección de escritura
        WDATAV_init : out std_logic;      --validación del dato
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
            clock : in std_logic     --validación de la lectura

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


begin

    signal WADDR_control_unit   : std_logic_vector(5 downto 0);
    signal WDATA_control_unit   : std_logic_vector(31 downto 0);
    signal WAVALID_control_unit : std_logic;
    signal WDATAV_control_unit  : std_logic;

    signal WRESP_control_unit   : std_logic_vector(1 downto 0);
    signal WRESPV_control_unit  : std_logic;
    
    bloque_control_unit : control_unit
    port map(
        clock => clock_top;
        reset => reset_top;

        --entradas i salidas para escritura
        WADDR => WADDR_control_unit;
        WDATA => WDATA_control_unit;
        WAVALID => WAVALID_control_unit;
        WDATAV => WDATAV_control_unit;
    
        WRESP => WRESP_control_unit;
        WRESPV => WRESPV_control_unit
    
        --entradas i salidas para lectura
        RADDR => 
        RAVALID
    
        RDATA
        RRESP
        RDATAV
    );


end architecture;