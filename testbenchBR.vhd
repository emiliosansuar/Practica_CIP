library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbenchBR is
end testbenchBR;

architecture tb_arch of testbenchBR is
    signal reg_in_value_tb : std_logic_vector(15 downto 0);
    signal read_not_write_tb : std_logic;
    signal dataOut_tb : std_logic_vector(15 downto 0);
    signal address_register_tb : std_logic_vector(3 downto 0);
    signal clock_tb : std_logic := '0';

    component bank_register
        port(
            reg_in_value : in std_logic_vector(15 downto 0);
            read_not_write : in std_logic;
            dataOut : out std_logic_vector(15 downto 0);
            address_register : in std_logic_vector(3 downto 0);
            clock : in std_logic
        );
    end component;

    

begin
    DUT_bank_register : bank_register
        port map (
            reg_in_value => reg_in_value_tb,
            read_not_write => read_not_write_tb,
            dataOut => dataOut_tb,
            address_register => address_register_tb,
            clock => clock_tb
        );

     -- Generamos una señal de reloj clock que cambia de estado de alto a bajo y viceversa cada 50 ns.  
    clock_tb <= not clock_tb after 50 ns; 

    stim_process: process 

    begin
        -- Write to register 0
        reg_in_value_tb <= "0000000000000001"; -- 1
        address_register_tb <= "0000";
        read_not_write_tb <= '0';
        wait for clk_period;

        -- Write to register 1
        reg_in_value_tb <= "0000000000000100"; -- 4
        address_register_tb <= "0001";
        read_not_write_tb <= '0';
        wait for 200 ns;

        -- Read from register 0
        address_register_tb <= "0000";
        read_not_write_tb <= '1';
        wait for 200 ns;

        -- Read from register 1
        address_register_tb <= "0001";
        read_not_write_tb <= '1';
        wait for 200 ns;


        -- Write to register 0 again
        reg_in_value_tb <= x"0000000000010000"; -- 16
        address_register_tb <= "0000";
        read_not_write_tb <= '0';
        wait for 200 ns;

        -- Read from register 0
        address_register_tb <= "0000";
        read_not_write_tb <= '1';
        wait for 200 ns;
        
        wait;
    end process;
end tb_arch;




