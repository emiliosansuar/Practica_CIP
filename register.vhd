library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_block is

    generic(
        data_size : integer := 4
    );

    port(
        data_in : in std_logic_vector((data_size - 1) downto 0);
        enable  : in std_logic;
        clock   : in std_logic;

        data_out : out std_logic_vector((data_size - 1) downto 0)
    );

end entity;

architecture arch of register_block is

    signal last_data_change : std_logic_vector((data_size - 1) downto 0);

begin

    last_data_change <= data_in when (clock = '1' and clock'event and enable = '1') else
                        last_data_change;

    data_out <= last_data_change;


end arch;