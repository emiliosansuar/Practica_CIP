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

	--signal opCode_aux: std_logic_vector(3 downto 0);

begin
        process(clock)
        begin
	    if (rising_edge(clock)) then
		--wait until all rising(instruction); -- Espera a que todos los bits se estabilicen
            	--opCode_aux <= instruction(31 downto 28);
            	--RECORDAR, seaRRR o RR o R. Oper1 es siempre rs y Oper2 es rt

            	case instruction(31 downto 28) is
                	when "0000" | "0010" | "0011" | "0100" | "0101" | "1001" | "1010" | "1011" | "1101" =>
			opCode <= instruction(31 downto 28); --RRR
                    	address_rd  <= instruction(23 downto 18); 
                    	address_rs  <= instruction(11 downto 6);
                    	address_rt  <= instruction(5 downto 0);
						const_imm   <= (others => '0');
		    	

                	when "0110" | "0111" | "1000" => 
			opCode <= instruction(31 downto 28); --RR
                    	address_rd  <= instruction(23 downto 18); 
                    	address_rs  <= instruction(11 downto 6);
						address_rt  <= (others => '0');
						const_imm   <= (others => '0');
                    
                	when "1100" => 
			opCode <= instruction(31 downto 28); --R
                    	address_rd  <= instruction(23 downto 18);
						address_rs  <= (others => '0');
						address_rt  <= (others => '0');
						const_imm   <= (others => '0');
		    	
                    
                	when "0001" =>
			opCode <= instruction(31 downto 28); --RRimm
                    	address_rd  <= instruction(23 downto 18);
                    	address_rs  <= instruction(17 downto 12);
                    	const_imm  <= instruction(7 downto 0);
						address_rt  <= (others => '0');

                	when others =>
                    	-- En caso de un código de operación no reconocido, puedes realizar alguna acción, como lanzar un error o establecer algún valor predeterminado.
                    	--null;
            	end case;

	    end if; 
        end process;
	    
end arch_decoder;
