-- Código de memoria definido en el enunciado de la práctica.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
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
end entity memoria;

architecture arch_memoria of memoria is

  type memory_type is array(0 to 63) of std_logic_vector(31 downto 0); -- AUMENTAR LUEGO HASTA 64

  signal memory : memory_type := (
      others => (others => '0') -- Inicializa todas las direcciones con ceros
  );


  signal valid_write_ok : std_logic;
  signal data_write_ok : std_logic;

  signal data_read_ok : std_logic;

begin
  valid_write_ok <= WAVALID and WDATAV;

  data_write_ok <= '1' when ((WADDR /= "UUUUUU") and (WDATA /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU")) else
	                 '0';

  data_read_ok <= '1' when (RADDR /= "UUUUUU") else
                  '0';
  
  --write process
  process(clock)
  begin 
    -- if(rising_edge(clock)) then
        if(valid_write_ok = '1') then

          if (data_write_ok = '1') then
            memory(to_integer(signed(WADDR))) <=  WDATA;
    
            WRESP <=  "00";

            WRESPV <= '1';
          else
            WRESP <=  "01";

            WRESPV <= '1';
          end if;

        else
          WRESP <=  "01";
          WRESPV <= '0';
        end if;
    -- end if;
  end process;

  --read process
  process(clock)
  begin
    -- if(rising_edge(clock)) then
        if(RAVALID = '1') then

          if (data_read_ok = '1') then
            RDATA <= memory(to_integer(signed(RADDR)));
    
            RRESP <=  "00";

            RDATAV <= '1';
          else
            RRESP <=  "01";

            RDATAV <= '1';
          end if;

        else
          RRESP <=  "01";
          RDATAV <= '0';
        end if;
    --end if;
  end process;

end;
