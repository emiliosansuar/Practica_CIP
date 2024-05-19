-- 3 registros para operaciones. 2 de valores y 1 de reultados 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  port
  (
    clock : in std_logic;     --validación de la lectura
    reset : in std_logic;
    init_enable  : in std_logic;
   
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
    RDATAV : in std_logic     --validación de la lectura
    
  );
end entity cpu;

architecture arch_cpu of cpu is

  component register_block is
		generic(
      data_size : integer := 5
    ); 

   	port(
      data_in : in std_logic_vector((data_size - 1) downto 0);
      enable  : in std_logic;
      clock   : in std_logic;

      data_out : out std_logic_vector((data_size - 1) downto 0)
    );
	end component;

  component alu is
		port(
			oper_1      : in std_logic_vector (15 downto 0);
      oper_2      : in std_logic_vector (15 downto 0);
      decoder_out : in std_logic_vector (3 downto 0);
      clock       : in std_logic;

      out_alu     : out std_logic_vector (15 downto 0)
		);
	end component;

  component decoder is
		port(
      instruction : in std_logic_vector(31 downto 0); 
      opCode      : out std_logic_vector(3 downto 0);
      address_rd  : out std_logic_vector(5 downto 0);
      address_rs  : out std_logic_vector(5 downto 0);
      address_rt  : out std_logic_vector(5 downto 0);
      const_imm   : out std_logic_vector(7 downto 0);
		);
	end component;

  component control_unit is
		port(
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
      RDATAV : in std_logic     --validación de la lectura
		);
	end component;

  component bank_register is
		port(
      reg_in_value      : in std_logic_vector(15 downto 0); --operacion de escritura
      read_not_write    : in std_logic; -- entrada para saber si leemos o escribimos en un register del banco 
      dataOut           : out std_logic_vector(15 downto 0); --lo que irá conectado a los dos registros de los opers
      address_register  : in std_logic_vector(3 downto 0);
      clock             : in std_logic     --validación de la lectura
		);
	end component;

  signal oper_1_in : std_logic_vector(15 downto 0);
  signal oper_1_out : std_logic_vector(15 downto 0);

  signal oper_2_in : std_logic_vector(15 downto 0);
  signal oper_2_out : std_logic_vector(15 downto 0);

  signal output_alu : std_logic_vector(15 downto 0);

  signal op_code : std_logic_vector(3 downto 0);

  signal rd_address : std_logic_vector(5 downto 0);
  signal rt_address : std_logic_vector(5 downto 0);
  signal rs_address : std_logic_vector(5 downto 0);

  signal constant_data : std_logic_vector(7 downto 0);

  signal IR_in : std_logic_vector(31 downto 0);
  signal IR_out : std_logic_vector(31 downto 0);
  signal IR_enable : std_logic;

  signal bank_register_address : std_logic_vector(3 downto 0);
  signal bank_register_input : std_logic_vector(15 downto 0);
  signal bank_register_output : std_logic_vector(15 downto 0);
  signal bank_register_read_not_write : std_logic;

begin

    oper_1_register : register_block
    generic map(
        data_size => 16
    )
    port map(
      data_in => oper_1_in,
      enable => '1',
      clock => clock,

      data_out => oper_1_out
    );

    oper_2_register : register_block
    generic map(
        data_size => 16
    )
    port map(
      data_in => oper_2_in,
      enable => '1',
      clock => clock,

      data_out => oper_2_out
    );

    alu : alu
    port map(
      oper_1 => oper_1_out,
      oper_2 => oper_2_out,
      decoder_out => op_code,
      clock => clock,

      out_alu => output_alu
    );

    decoder : decoder
    port map(
      instruction => IR_out,
      opCode => op_code,
      address_rd => rd_address,
      address_rs => rs_address,
      address_rt => rt_address,
      const_imm => constant_data
    );

    instruction_register : register_block
    generic map(
        data_size => 32
    )
    port map(
      data_in => IR_in,
      enable => IR_enable,
      clock => clock,

      data_out => IR_out,
    );

    bank_register : bank_register
    port map(
      reg_in_value => bank_register_input,
      read_not_write => bank_register_read_not_write,
      dataOut => bank_register_output,
      address_register => bank_register_address,
      clock => clock
    );

    control_unit : control_unit
    port map(
      clock => clock,
      reset => reset,
      init_enable => init_enable,
  
      --MEMORIA
      --entradas i salidas para escritura
      WADDR => WADDR,
      WDATA => WDATA,
      WAVALID => WAVALID,
      WDATAV => WDATAV,
      WRESP => WRESP, 
      WRESPV => WRESPV,
  
      --entradas i salidas para lectura
      RADDR => RADDR,
      RAVALID => RAVALID,
      RDATA => RDATA,
      RRESP => RRESP,
      RDATAV => RDATAV,

      --Banc de registres
      BankReg_read_not_write => bank_register_read_not_write,
      BankReg_input => bank_register_input,
      BankReg_output => bank_register_output,
      BankReg_address => address_register,

      --Decoder
      op_code => op_code,
      address_rd => rd_address,
      address_rs => rs_address,
      address_rt => rt_address,
      const_imm => constant_data,

      --Alu
      out_alu => output_alu,

      --oper registers
      oper_1 => oper_1_in,
      oper_2 => oper_2_in

    );

    
end;
