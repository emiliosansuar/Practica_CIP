--Testbench 1 Fibonaci

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench1 is
end entity testbench1;

architecture arch_testbench1 of testbench1 is
    --component
    component top is
        port(
            clock           : in std_logic;
            reset           : in std_logic;
            init/!Run_mode  : in std_logic;
    
            WADDR_init : out std_logic_vector(5 downto 0);   --dirección donde escribir
            WDATA_init : out std_logic_vector(31 downto 0);   --dato a escribir
            WAVALID_init : out std_logic;     --validación de la dirección de escritura
            WDATAV_init : out std_logic      --validación del dato
        );
    end component;

    --ports 
    signal clock_s : std_logic;
    signal reset_s : std_logic;
    signal init/!Run_mode_s : std_logic;
    signal WADDR_init_s :  std_logic_vector(5 downto 0);   --dirección donde escribir
    signal WDATA_init_s : std_logic_vector(31 downto 0);   --dato a escribir
    signal WAVALID_init_s : std_logic;     --validación de la dirección de escritura
    signal WDATAV_init_s : std_logic;      --validación del dato

  
    
end arch_testbench1; 
