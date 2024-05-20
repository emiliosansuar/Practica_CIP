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

  signal PC : std_logic_vector(5 downto 0) := "000000";

begin

  process(clock, reset) 
  begin
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

          Buffer_in <= "0000000000000000";
          Buffer_enable <= '0';

          if (init_enable = '1') then
            nextState <= S1;
          else
            nextState <= s0;
          end if;

        when s1 =>
          RADDR <= std_logic_vector(resize(signed(PC), RADDR'length));
          RAVALID <= '1';
          Enable_Instruction_Reg <= '1';
          BankReg_reset <= '0';

          if ((RDATAV = '1') and (RRESP = "00")) then
            nextState <= s2;
          else
            nextState <= s1;
          end if;
         
        when s2 =>
          nextState <= s3;
          
        when s3 =>
          Enable_Instruction_Reg <= '0';
          RAVALID <= '0';

          nextState <= s4;
        when s4 =>
          PC <= std_logic_vector(to_signed(to_integer(signed(PC)) + 1, 6));
          nextState <= s5;

        when s5 =>
          BankReg_address <= address_rs(3 downto 0);
          Oper_1_enable <= '1';
          Oper_2_enable <= '1';
          Buffer_enable <= '1';
          
          if(op_code = "1000" or op_code = "0111") then
            nextState <= s19;
          else
            nextState <= s6;
          end if;

        when s6 =>
          oper_1 <= BankReg_output;
          Buffer_enable <= '0';

          if(op_code = "0001") then
            nextState <= s17;
          elsif (op_code = "0110") then
            nextState <= s9;
          else
            nextState <= s7;
          end if;

        when s7 =>
          BankReg_address <= address_rt(3 downto 0);
          oper_1_enable <= '0';
          oper_2_enable <= '1';

          nextState <= s8;

        when s8 =>
          oper_2 <= BankReg_output;

          nextState <= s9;
        
        when s9 =>
          oper_1_enable <= '0';
          oper_2_enable <= '0';

          nextState <= s10;

        when s10 =>
          if (op_code = "1100" or (op_code = "1101" and out_alu = "0000000000000001")) then
            nextState <= s14;
          elsif (op_code = "1101" and out_alu = "0000000000000000") then
            nextState <= s16;
          else
            nextState <= s11;
          end if;

        when s11 =>
          BankReg_input <= out_alu;
          Bankreg_read_not_write <= '0';
          BankReg_address <= address_rd(3 downto 0);
          
          nextState <= s12;

        when s12 =>
          nextState <= s13;

        when s13 =>
          BankReg_read_not_write <= '1';

          nextState <= s1;

        when s14 =>
          BankReg_address <= address_rd(3 downto 0);
          BankReg_read_not_write <= '1';

          nextState <= s15;

        when s15 =>
          PC <= BankReg_output(5 downto 0);

          nextState <= s1;

        when s16 =>
          nextState <= s1;

        when s17 =>
          oper_1_enable <= '0';
          oper_2_enable <= '0';
          
          nextState <= s18;

        when s18 =>
          oper_2 <= std_logic_vector(resize(signed(const_imm), oper_2'length));

          nextState <= s9;

        when s19 =>
          Buffer_in <= BankReg_output;
          oper_1_enable <= '0';
          oper_2_enable <= '0';

          nextState <= s20;

        when s20 =>
          Buffer_enable <= '0';
          BankReg_address <= address_rd(3 downto 0);

          if (op_code = "0111") then
            nextState <= s21;
          else
            nextState <= s24;
          end if;

        when s21 =>
          RADDR <= std_logic_vector(resize(signed(Buffer_out), RADDR'length));
          RAVALID <= '1';
          BankReg_read_not_write <= '0';

          if (RDATAV = '1') then
            nextState <= s22;
          else
            nextState <= s21;
          end if;

        when s22 =>
          BankReg_input <= RDATA(15 downto 0);

          nextState <= s23;

        when s23 =>
          BankReg_read_not_write <= '1';
          RAVALID <= '0';

          nextState <= s1;

        when s24 =>
          WADDR <= std_logic_vector(resize(signed(address_rd), WADDR'length));
          WDATA <= std_logic_vector(resize(signed(Buffer_out), WDATA'length));
          WAVALID <= '1';
          WDATAV <= '1';

          if(WRESPV = '1') then
            nextState <= s25;
          else
            nextState <= s24;
          end if;

        when s25 =>
          WAVALID <= '0';
          WDATAV <= '0';

          nextState <= s1;

        when others =>
          nextState <= s0;

      end case;
  end process;
end arch_control_unit; 