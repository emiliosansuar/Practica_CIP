library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_memoria is
end entity tb_memoria;

architecture arc_tbMem of tb_memoria is
   
    component memoria
        port (
            clock : in std_logic;
            WADDR : in std_logic_vector(5 downto 0);
            WDATA : in std_logic_vector(31 downto 0);
            WAVALID : in std_logic;
            WDATAV : in std_logic;
            WRESP : out std_logic_vector(1 downto 0);
            WRESPV : out std_logic;
            RADDR : in std_logic_vector(5 downto 0);
            RAVALID : in std_logic;
            RDATA : out std_logic_vector(31 downto 0);
            RRESP : out std_logic_vector(1 downto 0);
            RDATAV : out std_logic
        );
    end component;

    signal clock_tb : std_logic := '0';
    signal WADDR_tb : std_logic_vector(5 downto 0) := (others => '0');
    signal WDATA_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal WAVALID_tb : std_logic := '0';
    signal WDATAV_tb : std_logic := '0';
    signal WRESP_tb : std_logic_vector(1 downto 0);
    signal WRESPV_tb : std_logic;
    signal RADDR_tb : std_logic_vector(5 downto 0) := (others => '0');
    signal RAVALID_tb : std_logic := '0';
    signal RDATA_tb : std_logic_vector(31 downto 0);
    signal RRESP_tb : std_logic_vector(1 downto 0);
    signal RDATAV_tb : std_logic;

begin

    UUT : memoria
        port map (
            clock => clock_tb,
            WADDR => WADDR_tb,
            WDATA => WDATA_tb,
            WAVALID => WAVALID_tb,
            WDATAV => WDATAV_tb,
            WRESP => WRESP_tb,
            WRESPV => WRESPV_tb,
            RADDR => RADDR_tb,
            RAVALID => RAVALID_tb,
            RDATA => RDATA_tb,
            RRESP => RRESP_tb,
            RDATAV => RDATAV_tb
        );

	clock_tb <= not clock_tb after 10 ns;
    stim_proc: process
    begin
        -- Escritura en la memoria
        WAVALID_tb <= '1';
        WDATAV_tb <= '1';
        WADDR_tb <= "000001";
        WDATA_tb <= "11110000111100001111000011110000"; -- Ejemplo de prueba
        wait for 25 ns;

        -- Lectura de la memoria
        RAVALID_tb <= '1';
        RADDR_tb <= "000001";
        wait for 30 ns;
	
	-- Escritura en la memoria
        WAVALID_tb <= '1';
        WDATAV_tb <= '1';
        WADDR_tb <= "000011";
        WDATA_tb <= "01010101010101010101010101010101"; -- Ejemplo de prueba
        wait for 25 ns;

        -- Lectura de la memoria
        RAVALID_tb <= '1';
        RADDR_tb <= "000011";
        wait for 30 ns;
        wait;
    end process;
end architecture arc_tbMem;
