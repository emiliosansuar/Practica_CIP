library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_ALU is
end entity;


architecture arch_tbALU of tb_ALU is

	signal oper_1_tb      : std_logic_vector (15 downto 0);
    	signal oper_2_tb      : std_logic_vector (15 downto 0);
    	signal decoder_out_tb : std_logic_vector (3 downto 0);
    	signal clock_tb       : std_logic := '1';
    	signal out_alu_tb     : std_logic_vector (15 downto 0);

	component ALU is
		port(
			oper_1      : in std_logic_vector (15 downto 0);
    			oper_2      : in std_logic_vector (15 downto 0);
    			decoder_out : in std_logic_vector (3 downto 0);
    			clock       : in std_logic;
    			out_alu     : out std_logic_vector (15 downto 0)
		);
	end component;

begin	
	tb_ALU : ALU
	port map(
		oper_1 => oper_1_tb,
		oper_2 => oper_2_tb,
		decoder_out => decoder_out_tb,
		clock => clock_tb,
		out_alu => out_alu_tb
	);

	clock_tb <= not clock_tb after 10 ns;
	stim_p : process
	begin
		oper_1_tb <= "0000000000000111"; -- Valor 7
		oper_2_tb <= "0000000000001000"; -- Valor 8
		decoder_out_tb <= "0000"; -- Indicamos una suma (el resultado debería dar 15)
		wait for 25 ns;

		oper_1_tb <= "0000000000000111"; -- Valor 7
		oper_2_tb <= "0000000000000001"; -- Valor 1
		decoder_out_tb <= "0000"; -- Indicamos una suma (el resultado debería dar 8)
		wait for 30 ns;

		oper_1_tb <= "0000000000000110"; -- Valor 6
		oper_2_tb <= "0000000000000001"; -- Valor 1
		decoder_out_tb <= "0010";  -- Indicamos una resta (el resultado debería dar 5)
		wait for 30 ns;

		oper_1_tb <= "0000000000000110"; -- Valor 6
		oper_2_tb <= "0000000000000010"; -- Valor 2
		decoder_out_tb <= "0110";  -- Indicamos una not
		wait for 30 ns;

		oper_1_tb <= "0000000000000010"; -- Valor 2
		oper_2_tb <= "0000000000000001"; -- Valor 1
		decoder_out_tb <= "1001";  -- Indicamos una comparación (como op1 > op2 = 1)
		wait for 30 ns;

		oper_1_tb <= "0000000000000001"; -- Valor 1
		oper_2_tb <= "0000000000000011"; -- Valor 3
		decoder_out_tb <= "1001";  -- Indicamos una comparación (como op1 < op2 = 0)
		wait for 30 ns;
		wait;
	end process;
end arch_tbALU;