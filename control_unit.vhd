--Máquina de estados

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
  port
  (
    clock : in std_logic;     --validación de la lectura
    reset : in std_logic;

    --MEMORIA
    --entradas i salidas para escritura
    WADDR : out std_logic_vector(5 downto 0);   --dirección donde escribir
    WDATA : out std_logic_vector(31 downto 0);   --dato a escribir
    WAVALID : out std_logic;     --validación de la dirección de escritura
    WDATAV : out std_logic;      --validación del dato

    WRESP : in std_logic_vector(1 downto 0);  --respuesta de la escritura
    WRESPV : in std_logic;     --validación de la escritura

    --entradas i salidas para lectura
    RADDR : out std_logic_vector(5 downto 0);   --dirección donde leer
    RAVALID : out std_logic;     --validacion de la dirección de lectura

    RDATA : in std_logic_vector(31 downto 0);   --dato leido
    RRESP : in std_logic_vector(1 downto 0);  --respuesta de la lectura
    RDATAV : in std_logic     --validación de la lectura

    --BANK REGISTER
    --read_not_write : out std_logic; -- para saber si leemos o escribimos en un register del banco 
    --address_register : out std_logic_vector(3 downto 0)

    --ALU
    --oper_1      : out std_logic_vector (15 downto 0);
    --oper_2      : out std_logic_vector (15 downto 0)
    

  );
end entity control_unit;

architecture arch_control_unit of control_unit is
  type estadoTipo is (i, i2, i3, i4, i5, i6, i7, i8, i9, i10, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
  signal currentState : estadoTipo;
  signal nextState : estadoTipo;
  signal InstructionReg : std_logic_vector(31 downto 0);
  signal PC : unsigned(5 downto 0) := "000000";
  signal PCaux : unsigned(5 downto 0) := "000000";
  signal out_alu : std_logic_vector (15 downto 0);

  process(clock, reset)
	begin
    if (reset = '1') then
			currentState <= i;
		elsif (rising_edge(clock)) then
			currentState <= nextState;
		end if;
	end process;

  -- rs = x // rt = y // rd = z // constat = C
  --  
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

        when i7 =>
          WADDR <= "000011"; --direccion 3
          WDATA  <= "01110000000011000000000001000000"; --load en R3 de 0x(R1)             
          WAVALID <= '1';
          WDATAV <= '1';
          nextState <= i8;

			when i8 =>
				if(WRESPV = '1') then
					WAVALID <= '0';
					WDATAV <= '0';
					nextState <= i9;
				end if;

    end case;
  end process;
end arch_control_unit; 
