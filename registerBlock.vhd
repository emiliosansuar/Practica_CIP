library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBlock is
    generic(
        data_size : integer := 4 -- Tamaño del vector de datos (en este caso le hemos indicado 4)
    );
    port(
        data_in : in std_logic_vector((data_size - 1) downto 0);  -- Entrada de datos
        enable  : in std_logic;                                   -- Entrada de habilitación
        clock   : in std_logic;                                   -- Reloj
        data_out : out std_logic_vector((data_size - 1) downto 0) -- Salida de datos
    );
end entity;

architecture arch of registerBlock is
    -- Señal interna para almacenar el último cambio de datos
    signal last_data_change : std_logic_vector((data_size - 1) downto 0);

begin
    process(clock)
    begin
        -- Comprobamos si el flanco del reloj es de subida
        if rising_edge(clock) then
            -- Miramos si la señal de habilitación está activa
            if enable = '1' then
                -- Actualizamos la señal last_data_change con los datos que hemos introducido
                last_data_change <= data_in;
            end if;
        end if;
    end process;

    -- Asignamos al puerto de salida data_out el valor de la señal last_data_change
    data_out <= last_data_change;
end architecture;
