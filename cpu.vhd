--TO DO: Máquina de estados (unidad de control), ALU, Banco de registro , Decoder


-- 3 registros para operaciones. 2 de valores y 1 de reultados 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  port
  (
    --entradas y salidas 
    in_mem_to_cpu   : in std_logic_vector (31 downto 0);
    out_cpu_to_mem  : out std_logic_vector (31 downto 0);
    mem_address     : out std_logic_vector (5 downto 0);
    --Bus de escritura
    waddr           : out std_logic_vector (31 downto 0); --dirección de la data a escribir 
    wavalid         : out std_logic; --validacion de la dirección de escritura 
    wdata           : out std_logic_vector (31 downto 0); --data a escribir 
    wdatav          : out std_logic; --validacin de la data a escribir 
    wresp           : in std_logic_vector (1 downto 0); -- respuesta de la escritura 
    wrespv          : in std_logic; -- validacion de la respuesta de escritura 

    --Bus de escritura 
    raddr           : out std_logic_vector (31 downto 0); --direccion de la data a leer 
    ravalid         : out std_logic; --validacion de la dirección de lectura
    rdata           : in std_logic_vector (31 downto 0); --data a leer
    rdatav          : in std_logic; --validación de la data a leer
    rresp           : in std_logic_vector (1 downto 0); --respuesta de la leectura 
    clock           : in std_logic
    
  );
end entity cpu;

architecture arch_cpu of cpu is
  type register_banc is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 direcciones con 16 bits cada una.
  signal banc_register : register_banc := (
    others => (others => '0') -- Inicializa todas las direcciones con ceros
  );  

  signal decoder_in   : std_logic_vector(4 downto 0);
  signal decoder_out  : std_logic_vector(13 downto 0);


    -- SIGNALS --------------------------------------
  
  
  
    -- Componentes -----------------------------------
  
  
  
  begin

    with KEY(1 downto 0) select
    decoder_out <=  op_1 when "00",
                    op_2 when "01", 
                    op_3 when "10",
                    op_4 when "11",
                    "0000000000" when others;
    -- Instanciacion de componentes  ----------------------------
  
    
  
    -- PROCESOS --------------------------------------------------
  
  end;
