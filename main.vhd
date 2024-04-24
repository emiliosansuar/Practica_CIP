--TODO: CPU , Y MEMORIA 

--BLOQUE MEMORIA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Practica_CIP is
  port
  (
    --entradas y salidas 

  );
end entity Practica_CIP;

architecture arch_Practica_CIP of Practica_CIP is
  
  type memory_type is array(0 to 9) of std_logic_vector(31 downto 0); -- AUMENTAR LUEGO HASTA 64
  signal memory_type : memoria := ("00000000000000000000000000000000", 
  
  );
  -- SIGNALS --------------------------------------

begin
  

end;
-------------------------------------------   