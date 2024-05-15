entity bank_register is
    Port (
        reg_in_value : in std_logic_vector(15 downto 0); --operacion de escritura
        read_not_write : in std_logic; -- entrada para saber si leemos o escribimos en un register del banco 
        dataOut : out std_logic_vector(15 downto 0) --lo que irá conectado a los dos registros de los opers
        address_register : in std_logic_vector(3 downto 0);
        clock : in std_logic     --validación de la lectura
    );
end bank_register;

architecture arch_bank_register of bank_register is

    type banc_regi is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 posiciones de 16 bits cada una, es decir tendremos 16 registros con 16 bits cada uno.
    signal registers : banc_regi := (
        others => (others => '0')  -- Inicializamos todas las posiciones a 16 bits a '0'
    );
   
    begin

        seq_comb_state : process(read_not_write, address_register, reg_in_value, clock) 
           -- if(rising_edge(clock)) then
                if read_not_write = '1' then -- Operación de lectura
                    dataOut <= registers(to_integer(unsigned address_register));
                elsif read_not_write = '0' then -- Operación de escritura
                    registers(to_integer(unsigned address_register)) <= reg_in_value;
                end if;
           -- end if;
        end process;

end arch_bank_register;


