entity mux_op is
    Port (
        Input_A : in std_logic_vector(31 downto 0); -- Entrada A de 32 bits
        --Input_B : in std_logic_vector(31 downto 0); -- Entrada B de 32 bits
        Selector : in std_logic_vector(5 downto 0); -- Selector de 6 bits
        Output : out std_logic -- Salida de 1 bit
    );
end mux_op;

architecture Behavioral of mux_op is
begin
    begin
        process (Input_A, Selector)
        begin
            Output <= '0';  -- Valor predeterminado
    
            for i in 0 to 31 loop
                if to_integer(unsigned(Selector)) = i then
                    Output <= Input_A(i);
                end if;
            end loop;
        end process;
end Behavioral;

entity mux_op is
    Port (
        Input_mux : in std_logic_vector(15 downto 0); -- es la salida del banco de registros y al mismo tiempo la entrada de los muxes.
        Selector : in std_logic_vector(5 downto 0); -- Selector de 6 bits
        Output : out std_logic -- Salida de 1 bit
    );
end mux_op;

architecture Behavioral of mux_op is

    type banc_regi is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 posiciones de 16 bits cada una, es decir tendremos 16 registros con 16 bits cada uno.
    signal data_regi : banc_regi := (
        others => (others => '0')  -- Inicializa todas las posiciones a 16 bits a '0'
    );

    signal rs std_logic_vector(5 downto 0);
    signal rt std_logic_vector(5 downto 0);
    signal data_op1 std_logic_vector(15 downto 0);

    begin
    process (Input_mux, rs)
    begin

        case rs is
            when "000000" =>
                data_op1 <= banc_regi(000000);
            when "000001" =>
                Output <= Input_mux(1);
            when "000010" =>
                Output <= Input_mux(2);
            when "000000" =>
                Output <= Input_mux(3);
            when "000001" =>
                Output <= Input_mux(4);
            when "000010" =>
                Output <= Input_mux(5);
                when "000000" =>
                Output <= Input_mux(6);
            when "000001" =>
                Output <= Input_mux(7);
            when "000010" =>
                Output <= Input_mux(8);
            when "000000" =>
                Output <= Input_mux(9);
            when "000001" =>
                Output <= Input_mux(10);
            when "000010" =>
                Output <= Input_mux(2);
                when "000000" =>
                Output <= Input_mux(0);
            when "000001" =>
                Output <= Input_mux(1);
            when "000010" =>
                Output <= Input_mux(2);
            when "000000" =>
                Output <= Input_mux(0);
            when "000001" =>
                Output <= Input_mux(1);
            when "000010" =>
                Output <= Input_mux(2);




            when others =>
                Output <= '0'; -- manejo de error, puede ser 0 o cualquier otro valor dependiendo de tus requerimientos
        end case;
    end process;
end Behavioral;







