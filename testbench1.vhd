--Testbench 1 Fibonaci

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench1 is
end entity testbench1;

architecture arch_testbench1 of testbench1 is
    --component
    component top is
        port(
            clock           : in std_logic;
            reset           : in std_logic;
            init_notRunMode  : in std_logic;
    
            WADDR_init : out std_logic_vector(5 downto 0);   --dirección donde escribir
            WDATA_init : out std_logic_vector(31 downto 0);   --dato a escribir
            WAVALID_init : out std_logic;     --validación de la dirección de escritura
            WDATAV_init : out std_logic;      --validación del dato
            WRESP_init : in std_logic_vector(1 downto 0);  --respuesta de la escritura
            WRESPV_init : in std_logic     --validación de la escritura
        );
    end component;

    --ports del component
    signal clock_s : std_logic := '1';
    signal reset_s : std_logic;
    signal init_notRunMode_s : std_logic;
    signal WADDR_init_s :  std_logic_vector(5 downto 0);   --dirección donde escribir
    signal WDATA_init_s : std_logic_vector(31 downto 0);   --dato a escribir
    signal WAVALID_init_s : std_logic;     --validación de la dirección de escritura
    signal WDATAV_init_s : std_logic;      --validación del dato
    signal WRESP_init_s : std_logic_vector(1 downto 0);  --respuesta de la escritura
    signal WRESPV_init_s : std_logic;     --validación de la escritura

    --signals de la maquina de estados 
    type estadoTipo is (i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10 );
    signal currentState : estadoTipo;
    signal nextState : estadoTipo;
    --signal InstructionReg : std_logic_vector(31 downto 0);
    --signal PC : unsigned(5 downto 0) := "000000";
    --signal PCaux : unsigned(5 downto 0) := "000000";
    --signal out_alu : std_logic_vector (15 downto 0);

begin 
    DUT :  top 
    port map (
    clock => clock_s,
    reset => reset_s,
    init_notRunMode => init_notRunMode_s,
    WADDR_init => WADDR_init_s,
    WDATA_init => WDATA_init_s,
    WAVALID_init => WAVALID_init_s,
    WDATAV_init => WDATAV_init_s,
    WRESP_init => WRESP_init_s,
    WRESPV_init => WRESPV_init_s
    );

    -- Clock 
    clock_s <= not clock_s after 5 ns; --periodo 10ns

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

    --proceso reset maquina estados
    process(clock_s, reset_s)
	begin
      if (reset_s = '1') then
			  currentState <= i0;
		  elsif (rising_edge(clock_s)) then
			  currentState <= nextState;
		  end if;
	end process;

    --process que guarda instrucciones en la menmoria 
    process(currentState) 
    begin
      case currentState is
        when i0 =>
          WADDR_init_s <= "000000"; --posicion 0 de a memoria
          WDATA_init_s <= "00010000000000000000000000100000"; --R0 = R0 + 32
          WAVALID_init_s <= '1';
          WDATAV_init_s <= '1';
          nextState <= i2;

        when i2 =>
          if(WRESPV_init_s = '1') then
            WAVALID_init_s <= '0'; --Limpiamos los flags para la próxima vez
            WDATAV_init_s <= '0';
            nextState <= i3;
          end if;

        when i3 =>
          WADDR_init_s <= "000001"; --direccion 1
          WDATA_init_s  <= "00010000000001000001000000100001"; --R1 = R1 + 33
          WAVALID_init_s <= '1';
          WDATAV_init_s <= '1';
          nextState <= i4;

        when i4 =>
          if(WRESPV_init_s = '1') then
            WAVALID_init_s <= '0';
            WDATAV_init_s <= '0';
            nextState <= i5;
          end if;

        when i5 =>
          WADDR_init_s <= "000010"; --direccion 2
          WDATA_init_s  <= "01110000000010000000000000000000"; --load en R2 de 0x(R0)
          WAVALID_init_s <= '1';
          WDATAV_init_s <= '1';
          nextState <= i6;

        when i6 =>
          if(WRESPV_init_s = '1') then
            WAVALID_init_s <= '0';
            WDATAV_init_s <= '0';
            nextState <= i7;
          end if;

          when i7 =>
            WADDR_init_s <= "000011"; --direccion 3
            WDATA_init_s  <= "01110000000011000000000001000000"; --load en R3 de 0x(R1)             
            WAVALID_init_s <= '1';
            WDATAV_init_s <= '1';
            nextState <= i8;

        when i8 =>
          if(WRESPV_init_s = '1') then
            WAVALID_init_s <= '0';
            WDATAV_init_s <= '0';
            nextState <= i9;
          end if;


        when others =>
          nextState <= i0;

      end case;
      --wait; --no se si es necesario
    end process;

end arch_testbench1; 
