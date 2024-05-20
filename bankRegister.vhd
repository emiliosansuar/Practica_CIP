library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bankRegister is
    Port (
        reg_in_value : in std_logic_vector(15 downto 0);    -- Entrada de datos
        read_not_write : in std_logic;                      -- Entrada que determinará si es una operación de lectura o escritura (read = 1 / write = 0)
        dataOut : out std_logic_vector(15 downto 0);        -- Salida de datos
        address_register : in std_logic_vector(3 downto 0); -- Dirección del registro a leer o escribir
        clock : in std_logic;                                -- Reloj
        reset : in std_logic
    );
end bankRegister;

architecture arch_bankRegister of bankRegister is

    -- Declaramos de un tipo de array para representar los 16 posibles registros del banco de registro.
    type banc_regi is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 registros de 16 bits cada uno
    signal registers : banc_regi := (
        others => (others => '0')  -- Inicializaremos todos los registros a cero
    );
   
begin

    seq_comb_state : process(clock, reset)
    begin
        -- Comprobaremos si el reset está activo
        if reset = '1' then
            registers <= (others => (others => '0')); -- Reset todos los registros a cero
        elsif rising_edge(clock) then
            -- Comprobamos si queremos hacer una lectura o escritura.
            if read_not_write = '1' then 
                -- Leemos el valor del registro en la dirección indicada y lo asignamos a la salida
                dataOut <= registers(to_integer(unsigned(address_register)));
            elsif read_not_write = '0' then 
                -- Escribimos el valor introducido en el registro en la dirección indicada
                registers(to_integer(unsigned(address_register))) <= reg_in_value;
            end if;
        end if;
    end process;

end arch_bankRegister;