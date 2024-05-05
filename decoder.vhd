entity decoder is
    Port (
        instruction : in std_logic_vector(31 downto 0); 
        opCode: out std_logic_vector(3 downto 0);
        address_rd: out std_logic_vector(5 downto 0);
        address_rs: out std_logic_vector(5 downto 0);
        address_rt: out std_logic_vector(5 downto 0);
        const_imm: : out std_logic_vector(7 downto 0);
        --ravalid :  out std_logic;
        -- mirar foto
    );
end decoder;

architecture Behavioral of decoder is
    begin
        process(instruction)
        begin
            opCode <= instruction(31 downto 28);
            
            case opCode is
                when "0000" | "0010" | "0011" | "0100" | "0101" | "1001" | "1010" | "1011" | "1101" =>
                    address_rd  <= instruction(23 downto 18);
                    address_rs  <= instruction(11 downto 6);
                    address_rt  <= instruction(5 downto 0);
                    const_imm <= (others => '0'); -- Por defecto, se establece a cero
                    type_oper <= "00"; --RRR

                when "0110" | "0111" | "1000" => 
                    address_rd  <= instruction(23 downto 18);
                    address_rs  <= instruction(11 downto 6);
                    type_oper <= "01"; --RR
                    
                when "1101" => 
                    address_rd  <= instruction(23 downto 18);
                    type_oper <= "10"; --R
                    
                when "0001" =>
                    address_rd  <= instruction(23 downto 18);
                    address_rs  <= instruction(17 downto 12);
                    const_imm  <= instruction(7 downto 0);
                    type_oper <= "11"; --RRimm

                when others =>
                    -- En caso de un código de operación no reconocido, puedes realizar alguna acción, como lanzar un error o establecer algún valor predeterminado.
                    null;
            end case;
        end process;
    end Behavioral;
    