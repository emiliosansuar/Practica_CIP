library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decoder is
end tb_decoder;

architecture arch_tb_decoder of tb_decoder is
    -- Component declaration for the unit under test (UUT)
    component decoder
        port (
            instruction : in std_logic_vector(31 downto 0);
            opCode : out std_logic_vector(3 downto 0);
            address_rd : out std_logic_vector(5 downto 0);
            address_rs : out std_logic_vector(5 downto 0);
            address_rt : out std_logic_vector(5 downto 0);
	    clock : in std_logic;
	    --type_oper: out std_logic_vector(1 downto 0);
            const_imm : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals for connecting to UUT
    signal instruction_tb : std_logic_vector(31 downto 0);
    signal opCode_tb : std_logic_vector(3 downto 0);
    signal address_rd_tb : std_logic_vector(5 downto 0);
    signal address_rs_tb : std_logic_vector(5 downto 0);
    signal address_rt_tb : std_logic_vector(5 downto 0);
    signal const_imm_tb : std_logic_vector(7 downto 0);
    signal clock_tb : std_logic := '0';
    --signal type_oper_tb : std_logic_vector(1 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    DUT : decoder
        port map (
            instruction => instruction_tb,
            opCode => opCode_tb,
            address_rd => address_rd_tb,
            address_rs => address_rs_tb,
            address_rt => address_rt_tb,
            const_imm => const_imm_tb,
	    clock => clock_tb
        );

	clock_tb <= not clock_tb after 5 ns; 

    -- Stimulus process
    stim_proc: process
    begin
	--wait for 2 ns;
        -- Test case 1: RRimm
        instruction_tb <= "00010000000000000000000000100000"; --R0 = R0 + 32
        wait for 10 ns;

        -- Test case 2: RRimm
        instruction_tb <= "00010000000001000001000000000001"; --R1 = R1 + 1
        wait for 10 ns;

        -- Test case 3: RR
        instruction_tb <= "01110000000010000000000000000000"; --load en R2 de 0x(R0)
        wait for 10 ns;

        -- Test case 4: RRR
        instruction_tb <= "00000000000011000000000001000010";  -- R3 = R1 + R2 
        wait for 10 ns;

        -- Test case 5: R
        instruction_tb <= "11000000000001000000000000000000";  -- Jump: PC = R1
        wait for 10 ns;

        wait;
    end process;
end arch_tb_decoder;
