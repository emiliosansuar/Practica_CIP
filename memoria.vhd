-- Códgio de memoria definido en el enunciado de la práctica.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
  port
  (
    --entradas y salidas 
    
  );
end entity memoria;

architecture arch_memoria of memoria is
    type memory_type is array(0 to 9) of std_logic_vector(31 downto 0); -- AUMENTAR LUEGO HASTA 64
    signal memory : memoria_type := (
        others => (others => '0') -- Inicializa todas las direcciones con ceros
    );



    -- SIGNALS --------------------------------------
  
  
  
    -- Componentes -----------------------------------
  
  
  
  begin
    -- Instanciacion de componentes  ----------------------------
  
    
  
    -- PROCESOS --------------------------------------------------
  
  end;
