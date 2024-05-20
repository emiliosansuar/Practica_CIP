--Máquina de estados

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_block is
  port
  (
    clock : in std_logic;     --validación de la lectura
    reset : in std_logic;

    init_enable :in std_logic;

    --MEMORIA
    --entradas i salidas para escritura
    WADDR : out std_logic_vector(31 downto 0);   --dirección donde escribir
    WDATA : out std_logic_vector(31 downto 0);   --dato a escribir
    WAVALID : out std_logic;     --validación de la dirección de escritura
    WDATAV : out std_logic;      --validación del dato

    WRESP : in std_logic_vector(1 downto 0);  --respuesta de la escritura
    WRESPV : in std_logic;     --validación de la escritura

    --entradas i salidas para lectura
    RADDR : out std_logic_vector(31 downto 0);   --dirección donde leer
    RAVALID : out std_logic;     --validacion de la dirección de lectura

    RDATA : in std_logic_vector(31 downto 0);   --dato leido
    RRESP : in std_logic_vector(1 downto 0);  --respuesta de la lectura
    RDATAV : in std_logic;     --validación de la lectura

    --Banc de registres
    BankReg_read_not_write : out std_logic;
    BankReg_input : out std_logic_vector(15 downto 0);
    BankReg_output : in std_logic_vector(15 downto 0);
    BankReg_address : out std_logic_vector(3 downto 0);
    BankReg_reset : out std_logic;

    --Decoder
    op_code : in std_logic_vector(3 downto 0);
    address_rd : in std_logic_vector(5 downto 0);
    address_rs : in std_logic_vector(5 downto 0);
    address_rt : in std_logic_vector(5 downto 0);
    const_imm  : in std_logic_vector(7 downto 0);

    --Alu
    out_alu : in std_logic_vector(15 downto 0);

    --oper registers
    oper_1 : out std_logic_vector(15 downto 0);
    oper_1_enable : out std_logic;
    oper_2 : out std_logic_vector(15 downto 0);
    oper_2_enable : out std_logic;

    --instructuin register
    Enable_Instruction_Reg : out std_logic;

    --Buffer register
    Buffer_in : out std_logic_vector(15 downto 0);
    Buffer_enable : out std_logic;
    Buffer_out : in std_logic_vector(15 downto 0)
  );
end entity control_unit_block;

architecture arch_control_unit of control_unit_block is

  type estadoTipo is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25);
  signal currentState : estadoTipo;
  signal nextState : estadoTipo;

  signal PC : unsigned(5 downto 0) := "000000";

begin

  process(clock, reset) begin
      if (reset = '1') then
			  currentState <= s0;
		  elsif (rising_edge(clock)) then
			  currentState <= nextState;
		  end if;
	end process;

  process(currentState)

    begin
      case currentState is
        when s0 =>
          PC <= "000000";
          
          WADDR <= "00000000000000000000000000000000";
          WDATA <= "00000000000000000000000000000000";
          WAVALID <= '0';
          WDATAV <= '0';
          
          RADDR <= "00000000000000000000000000000000";
          RAVALID <= '0';

          BankReg_read_not_write <= '1';
          BankReg_input <= "0000000000000000";
          BankReg_address <= "0000";
          BankReg_reset <= '1';

          oper_1 <= "0000000000000000";
          oper_2 <= "0000000000000000";
          oper_1_enable <= '0';
          oper_2_enable <= '0';

          Enable_Instruction_reg <= '0';

          Buffer_in <= '0000000000000000';
          Buffer_enable <= '0';

          if (init_enable = '1') then
            currentState <= S1;
          else
            currentState <= s0;
          end if;

        when s1 =>
          RADDR <= PC;
          PAVALID <= '1';
          Enable_Intruction_Reg <= '1';
          BankReg_reset <= '0';

          if ((RDATAV = '1') and (RRESP = "00")) then
            currentState <= s2;
          else
            currentState <= s1;
          end if;
         
        when s2 =>
          currentState <= s3;
          
        when s3 =>
          Enable_Intrusction_Reg <= '0';
          RAVALID <= '0';

          currentState <= s4;
        when s4 =>
          PC <= PC + 1;
          currentState <= s5;

        when s5 =>
          BankReg_address <= address_rs;
          Oper_1_enable <= '1';
          Oper_2_enable <= '1';
          Buffer_enable <= '1'
          
          if(op_code = "1000" or op_code = "0111") then
            currentState <= s19;
          else
            currentState <= s6;
          end if;

        when s6 =>
          oper_1 <= BankReg_output;
          Buffer_enable <= '0';

          if(op_code = "0001") then
            currentState <= s17;
          elsif (op_code = "0110") then
            currentState <= s9;
          else
            currentState <= s7;
          end if;

        when s7 =>
          BankReg_address <= addres_rt;
          oper_1_enable <= '0';
          oper_2_enable <= '1';

          currentState <= s8;

        when s8 =>
          oper_2 <= BankReg_output;

          currentState <= s9;
        
        when s9 =>
          oper_1_enable = '0';
          oper_2_enable = '0';

          currentState <= s10;

        when s10 =>
          if (op_code = "1100" or) then

          elsif () then

          else
            
          end if;

        when s11 =>

        when s12 =>

        when s13 =>

        when s14 =>

        when s15 =>

        when s16 =>

        when s17 =>

        when s18 =>

        when s19 =>

        when s20 =>

        when s21 =>

        when s22 =>

        when s23 =>

        when s24 =>

        when s25 =>


        when others =>
          nextstate <= s0;

      end case;
  end process;
end arch_control_unit; 
