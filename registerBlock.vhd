library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBlock is
    generic(
        data_size : integer := 4
    );
    port(
        data_in  : in unsigned((data_size - 1) downto 0);
        enable   : in std_logic;
        clock    : in std_logic;
        data_out : out unsigned((data_size - 1) downto 0)
    );
end entity;

architecture arch of registerBlock is
     signal last_data_change : unsigned((data_size - 1) downto 0);
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if enable = '1' then
                last_data_change <= data_in;
            end if;
        end if;
    end process;

    data_out <= last_data_change;
end architecture;
