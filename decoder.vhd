library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Decoder_Block is
    Port (
        instruction : in std_logic_vector(31 downto 0); 
        opCode: out std_logic_vector(3 downto 0);
        address_rd: out std_logic_vector(5 downto 0);
        address_rs: out std_logic_vector(5 downto 0);
        address_rt: out std_logic_vector(5 downto 0);
	    clock : in std_logic;
	--type_oper: out std_logic_vector(1 downto 0);
        const_imm : out std_logic_vector(7 downto 0)
    );
end Decoder_Block;

architecture arch_decoder of Decoder_Block is

	signal opCode_aux: std_logic_vector(3 downto 0);

    begin
        process(instruction)
        begin
	    if (rising_edge(clock)) then
		--wait until all rising(instruction); -- Espera a que todos los bits se estabilicen
            	opCode_aux <= instruction(31 downto 28);
            	--RECORDAR, seaRRR o RR o R. Oper1 es siempre rs y Oper2 es rt
            	case opCode_aux is
                	when "0000" | "0010" | "0011" | "0100" | "0101" | "1001" | "1010" | "1011" | "1101" =>
                    	address_rd  <= instruction(23 downto 18);
                    	address_rs  <= instruction(11 downto 6);
                    	address_rt  <= instruction(5 downto 0);
                    	--const_imm <= (others => '0'); -- Por defecto, se establece a cero
                    	--type_oper <= "00"; --RRR
		    	opCode <= opCode_aux;

                	when "0110" | "0111" | "1000" => 
                    	address_rd  <= instruction(23 downto 18);
                    	address_rs  <= instruction(11 downto 6);
                    	--type_oper <= "01"; --RR
		    	opCode <= opCode_aux;
                    
                	when "1100" => 
                    	address_rd  <= instruction(23 downto 18);
                    	--type_oper <= "10"; --R
		    	opCode <= opCode_aux;
                    
                	when "0001" =>
                    	address_rd  <= instruction(23 downto 18);
                    	address_rs  <= instruction(17 downto 12);
                    	const_imm  <= instruction(7 downto 0);
                    	--type_oper <= "11"; --RRimm
		    	opCode <= opCode_aux;

                	when others =>
                    	-- En caso de un código de operación no reconocido, puedes realizar alguna acción, como lanzar un error o establecer algún valor predeterminado.
                    	null;
            	end case;

	    end if; 
        end process;
	    
end arch_decoder;
