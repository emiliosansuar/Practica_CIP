--TO DO: Máquina de estados (unidad de control), ALU, Banco de registro , Decoder


-- 3 registros para operaciones. 2 de valores y 1 de reultados 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  port
  (
    --entradas y salidas 
    
  );
end entity cpu;

architecture arch_cpu of cpu is
  type register_banc is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 direcciones con 16 bits cada una.
  signal banc_register : register_banc := (
    others => (others => '0') -- Inicializa todas las direcciones con ceros
  );  




    -- SIGNALS --------------------------------------
  
  
  
    -- Componentes -----------------------------------
  
  
  
  begin
    -- Instanciacion de componentes  ----------------------------
  
    
  
    -- PROCESOS --------------------------------------------------
  
  end;
