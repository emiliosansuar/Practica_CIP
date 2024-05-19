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
            const_imm => const_imm_tb
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: RRimm
        instruction_tb <= "00010000000000000000000000100000"; --R0 = R0 + 32
        wait for 10 ns;
--        assert opCode_tb = "0000" report "Test failed for opCode 0000" severity error;
--        assert address_rd_tb = "000000" report "Test failed for address_rd with opCode 0000" severity error;
--        assert address_rs_tb = "000000" report "Test failed for address_rs with opCode 0000" severity error;
--        assert address_rt_tb = "000000" report "Test failed for address_rt with opCode 0000" severity error;

        -- Test case 2: RRimm
        instruction_tb <= "00010000000001000001000000000001"; --R1 = R1 + 1
        wait for 10 ns;
--        assert opCode_tb = "0010" report "Test failed for opCode 0010" severity error;
--        assert address_rd_tb = "000000" report "Test failed for address_rd with opCode 0010" severity error;
--        assert address_rs_tb = "000000" report "Test failed for address_rs with opCode 0010" severity error;
--        assert address_rt_tb = "000000" report "Test failed for address_rt with opCode 0010" severity error;

        -- Test case 3: RR
        instruction_tb <= "01110000000010000000000000000000"; --load en R2 de 0x(R0)
        wait for 10 ns;
--        assert opCode_tb = "0110" report "Test failed for opCode 0110" severity error;
--        assert address_rd_tb = "000000" report "Test failed for address_rd with opCode 0110" severity error;
--        assert address_rs_tb = "000000" report "Test failed for address_rs with opCode 0110" severity error;

        -- Test case 4: RRR
        instruction_tb <= "00000000000011000000000001000010";  -- R3 = R1 + R2 
        wait for 10 ns;
--        assert opCode_tb = "1101" report "Test failed for opCode 1101" severity error;
--        assert address_rd_tb = "000000" report "Test failed for address_rd with opCode 1101" severity error;

        -- Test case 5: R
        instruction_tb <= "11000000000001000000000000000000";  -- Jump: PC = R1
        wait for 10 ns;
--        assert opCode_tb = "0001" report "Test failed for opCode 0001" severity error;
--        assert address_rd_tb = "000000" report "Test failed for address_rd with opCode 0001" severity error;
--        assert address_rs_tb = "000000" report "Test failed for address_rs with opCode 0001" severity error;
--        assert const_imm_tb = "00000000" report "Test failed for const_imm with opCode 0001" severity error;

        wait;
    end process;
end arch_tb_decoder;
