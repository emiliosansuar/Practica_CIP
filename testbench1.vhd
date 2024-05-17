--Testbench 1 Fibonaci

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench1 is
end testbench1;

architecture arch_testbench1 of testbench1 is
    --component
    component top is
        port(
            clock           : in std_logic;
            reset           : in std_logic;
            init/!Run_mode  : in std_logic;
    
            WADDR_init : out std_logic_vector(5 downto 0);   --dirección donde escribir
            WDATA_init : out std_logic_vector(31 downto 0);   --dato a escribir
            WAVALID_init : out std_logic;     --validación de la dirección de escritura
            WDATAV_init : out std_logic;      --validación del dato
        );
    end component;

    --ports 
    signal clock_s : std_logic;
    signal reset_s : std_logic;
    signal init/!Run_mode_s : std_logic;
    signal WADDR_init_s :  std_logic_vector(5 downto 0);   --dirección donde escribir
    signal WDATA_init_s : std_logic_vector(31 downto 0);   --dato a escribir
    signal WAVALID_init_s : std_logic;     --validación de la dirección de escritura
    signal WDATAV_init_s : std_logic;      --validación del dato
  

  process(clock, reset)
	begin
    if (reset = '1') then
			currentState <= i;
		elsif (rising_edge(clock)) then
			currentState <= nextState;
		end if;
	end process;

  -- rs = x // rt = y // rd = z // constat = C
  -- "00000000zzzzzz000000yyyyyyxxxxxx" -> ADD operation                RRR
  -- "00010000zzzzzzxxxxxx0000CCCCCCCC" -> ADD inmediate operation      RRImm
  -- "00100000zzzzzz000000yyyyyyxxxxxx" -> Substract operation          RRR
  -- "00110000zzzzzz000000yyyyyyxxxxxx" -> Or operation                 RRR
  -- "01000000zzzzzz000000yyyyyyxxxxxx" -> Xor operation                RRR
  -- "01010000zzzzzz000000yyyyyyxxxxxx" -> And operation                RRR
  -- "01100000zzzzzz000000yyyyyy000000" -> Not operation                RR
  -- "01110000zzzzzz000000yyyyyy000000" -> Load operation               RR
  -- "10000000zzzzzz000000yyyyyy000000" -> Store operation              RR
  -- "10010000zzzzzz000000yyyyyyxxxxxx" -> Compare operation            RRR
  -- "10100000zzzzzz000000yyyyyyxxxxxx" -> Shift left operation         RRR
  -- "10110000zzzzzz000000yyyyyyxxxxxx" -> Shift right operation        RRR
  -- "11000000zzzzzz000000000000000000" -> Jumpt/branch operation       R
  -- "11010000zzzzzz000000yyyyyyxxxxxx" -> Jump/branch conditional operation  RRR
  

  process(currentState) -- Result??? --Register_Value_Read??? , currentState, WRESP, WRESPV, RDATA, RDATAV, RRESP
	variable opCode_aux: std_logic_vector(3 downto 0) := (others=>'0');
	variable res_aux: std_logic_vector(15 downto 0) := (others=>'0'); -- Los registros son de 16 bits
	variable op1_aux: std_logic_vector(15 downto 0) := (others=>'0');
	variable op2_aux: std_logic_vector(15 downto 0) := (others=>'0');
	variable reg_aux: std_logic_vector(15 downto 0);
	variable data_bus_aux : std_logic_vector (31 downto 0) := x"00000000";

	begin
		case currentState is
			when i =>
				PCaux <= PC;
				--RADDR <= x"00000000";
				WADDR <= "000000"; --posicion 0 de a memoria
				WDATA <= "00010000000000000000000000100000"; --R0 = R0 + 32
				WAVALID <= '1';
				WDATAV <= '1';
				nextState <= i2;

			when i2 =>
				if(WRESPV = '1') then
					WAVALID <= '0'; --Limpiamos los flags para la próxima vez
					WDATAV <= '0';
					nextState <= i3;
				end if;

      when i3 =>
				WADDR <= "000001"; --direccion 1
				WDATA  <= "00010000000001000001000000100001"; --R1 = R1 + 33
				WAVALID <= '1';
				WDATAV <= '1';
				nextState <= i4;

			when i4 =>
				if(WRESPV = '1') then
					WAVALID <= '0';
					WDATAV <= '0';
					nextState <= i5;
				end if;

      when i5 =>
				WADDR <= "000010"; --direccion 2
				WDATA  <= "01110000000010000000000000000000"; --load en R2 de 0x(R0)
				WAVALID <= '1';
				WDATAV <= '1';
				nextState <= i6;

			when i6 =>
				if(WRESPV = '1') then
					WAVALID <= '0';
					WDATAV <= '0';
					nextState <= i7;
				end if;

        when i5 =>
          WADDR <= "000011"; --direccion 3
          WDATA  <= "01110000000011000000000001000000"; --load en R3 de 0x(R1)             
          WAVALID <= '1';
          WDATAV <= '1';
          nextState <= i6;

			when i6 =>
				if(WRESPV = '1') then
					WAVALID <= '0';
					WDATAV <= '0';
					nextState <= i7;
				end if;



        

      when i8 =>
        WADDR <= "100010"; --direccion 34
        WDATA  <= out_alu; -- 
        WAVALID <= '1';
        WDATAV <= '1';
        nextState <= i9;
        
     

    end case;
  end process;
end arch_testbench1; 
