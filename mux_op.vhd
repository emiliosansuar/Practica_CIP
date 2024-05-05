entity bank_register is
    Port (
        rd : in std_logic_vector(5 downto 0); 
        rs : in std_logic_vector(5 downto 0); 
        rt : in std_logic_vector(5 downto 0);
        type_oper : in std_logic_vector(1 downto 0);
        dataOut : out std_logic_vector(15 downto 0); --lo que irá conectado a los dos registros de los opers

    );
end bank_register;

architecture Behavioral of bank_register is

    type banc_regi is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 posiciones de 16 bits cada una, es decir tendremos 16 registros con 16 bits cada uno.
    signal data_regi : banc_regi := (
        others => (others => '0')  -- Inicializamos todas las posiciones a 16 bits a '0'
    );

    signal wenable_rs std_logic;
    signal wenable_rt std_logic;
    signal wenable_rd std_logic;


    
    begin
    process (rs, rt, rd)

        when type_oper == "00" -- RRR
            dataOut <= banc_regi(rd);
            wenable_rd <= '1';

        when type_oper == "01" -- RR

            dataOut <= banc_regi(rs); 

        when type_oper == "10" -- R
            dataOut <= banc_regi(rs); 

        when type_oper == "11" -- RRRimm
            dataOut <= banc_regi(rs); 





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







