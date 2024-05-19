library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
  port
  (
    clock : in std_logic;     -- Reloj

    -- Entradas y salidas para escritura:
    WADDR : in std_logic_vector(5 downto 0);   -- Dirección donde escribiremos
    WDATA : in std_logic_vector(31 downto 0);  -- Dato a escribir
    WAVALID : in std_logic;    		       -- Validación de la dirección de escritura
    WDATAV : in std_logic;                     -- Validación del dato a escribir

    WRESP : out std_logic_vector(1 downto 0);  -- Respuesta de la escritura
    WRESPV : out std_logic;    		       -- Validación de la respuesta de escritura

    -- Entradas y salidas para lectura:
    RADDR : in std_logic_vector(5 downto 0);   -- Dirección donde leer
    RAVALID : in std_logic;                    -- Validación de la dirección de lectura

    RDATA : out std_logic_vector(31 downto 0); -- Dato leído
    RRESP : out std_logic_vector(1 downto 0);  -- Respuesta de la lectura
    RDATAV : out std_logic                     -- Validación de la respuesta de lectura
  );
end entity memoria;


architecture arch_memoria of memoria is
  -- Declaramos un tipo de dato para la memoria, que consiste en un array de 64 posiciones de 32 bits cada una
  type memory_type is array(0 to 63) of std_logic_vector(31 downto 0); 

  -- Señal que representa la memoria
  signal memory : memory_type := (
      others => (others => '0') -- Inicializaremos todo a ceros
  );

  -- Señales internas para validaciones de escritura y lectura
  signal valid_write_ok : std_logic;
  signal data_write_ok : std_logic;
  signal data_read_ok : std_logic;

begin
  -- La escritura será válida solo si tanto la dirección de escritura como el dato introducido son válidos.
  valid_write_ok <= WAVALID and WDATAV;

  -- Comprobamos que la dirección y el dato de escritura no son indeterminados, es decir que tengan el valor 'U' (desconocido)
  -- Si es indeterminadas data_write_ok = 0  
  -- Si NO son indeterminados data_write_ok = 1
  data_write_ok <= '1' when ((WADDR /= "UUUUUU") and (WDATA /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU")) else '0';

  -- Comprobamos que la dirección de lectura no es indeterminada
  data_read_ok <= '1' when (RADDR /= "UUUUUU") else '0';
  
  -- Proceso para gestionar la ESCRITURA de la memoria
  process(clock)
  begin 
    -- Si la escritura es válida
    if(valid_write_ok = '1') then
      -- Y los datos de escritura son válidos
      if (data_write_ok = '1') then
        -- Escribimos el dato en la dirección especificada 
        memory(to_integer(signed(WADDR))) <=  WDATA;
    
        -- Respuesta de escritura correcta
        WRESP <=  "00";
        WRESPV <= '1';
      else
        -- Respuesta de escritura incorrecta (dato inválido)
        WRESP <=  "01";
        WRESPV <= '1';
      end if;
    else
      -- Respuesta de escritura incorrecta (escritura no válida)
      WRESP <=  "01";
      WRESPV <= '0';
    end if;
  end process;

  -- Proceso para gestionar la LECTURA de la memoria
  process(clock)
  begin
    -- Si la lectura es válida
    if(RAVALID = '1') then
      -- Y la dirección de lectura es válida
      if (data_read_ok = '1') then
        -- Leemos el dato de la dirección especificada
        RDATA <= memory(to_integer(signed(RADDR)));
    
        -- Respuesta de lectura correcta
        RRESP <=  "00";
        RDATAV <= '1';
      else
        -- Respuesta de lectura incorrecta (dirección inválida)
        RRESP <=  "01";
        RDATAV <= '1';
      end if;
    else
      -- Respuesta de lectura incorrecta (lectura no válida)
      RRESP <=  "01";
      RDATAV <= '0';
    end if;
  end process;

end architecture;
