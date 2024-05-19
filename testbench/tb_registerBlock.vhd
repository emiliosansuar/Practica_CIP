library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_registerBlock is
end entity;


architecture arch1_registerBlock of tb_registerBlock is

	component registerBlock is
		generic(
        		data_size : integer := 5
    		); 

   		port(
        		data_in  : in unsigned((data_size - 1) downto 0);
        		enable   : in std_logic;
        		clock    : in std_logic;
        		data_out : out unsigned((data_size - 1) downto 0)
    		);
	end component;

	constant data_size_tb : integer := 4;
	--constant data_size_tb : integer := 1; --Descomentar en caso de querer comprobar con otro ejemplo
    	signal data_in_tb  : unsigned((data_size_tb - 1) downto 0);
    	signal enable_tb   : std_logic;
    	signal clock_tb    : std_logic := '1';
    	signal data_out_tb : unsigned((data_size_tb - 1) downto 0);

begin	

	tb_registerBlock : registerBlock
	generic map (
        	data_size => data_size_tb
    	)
	port map(
		data_in => data_in_tb,
		enable => enable_tb,
		clock => clock_tb,
		data_out => data_out_tb
	);

	clock_tb <= not clock_tb after 20 ns;

	stim_p : process
	begin
		data_in_tb <= "0100";
		--data_in_tb <= "1"; --Descomentar en caso de querer comprobar con otro ejemplo
		enable_tb <= '0';
		wait for 50 ns;

		data_in_tb <= "0001";
		--data_in_tb <= "1"; --Descomentar en caso de querer comprobar con otro ejemplo
		enable_tb <= '1';
		wait for 30 ns;

		data_in_tb <= "1000";
		--data_in_tb <= "0"; --Descomentar en caso de querer comprobar con otro ejemplo
		enable_tb <= '1';
		wait for 30 ns;
		wait;
	end process;
end arch1_registerBlock;