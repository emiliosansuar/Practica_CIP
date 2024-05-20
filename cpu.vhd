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

  component registerBlock is
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

  component ALU_block is
    port(
      oper_1      : in std_logic_vector (15 downto 0);
      oper_2      : in std_logic_vector (15 downto 0);
      decoder_out : in std_logic_vector (3 downto 0);
      clock       : in std_logic;

      out_alu     : out std_logic_vector (15 downto 0)
    );
  end component;

  component Decoder_Block is
    port(
      instruction : in std_logic_vector(31 downto 0); 
      opCode      : out std_logic_vector(3 downto 0);
      address_rd  : out std_logic_vector(5 downto 0);
      address_rs  : out std_logic_vector(5 downto 0);
      address_rt  : out std_logic_vector(5 downto 0);
      clock : in std_logic;
      const_imm   : out std_logic_vector(7 downto 0)
    );
  end component;

  component control_unit_block is 
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
      RDATAV : in std_logic;     --validación de la lectura

      --Banc de registres
      BankReg_read_not_write : out std_logic;
      BankReg_input : out std_logic_vector(15 downto 0);
      BankReg_output : in std_logic_vector(15 downto 0);
      BankReg_address : out std_logic_vector(3 downto 0);

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
  end component;

  component bankRegister is
     port(
      reg_in_value      : in std_logic_vector(15 downto 0); --operacion de escritura
      read_not_write    : in std_logic; -- entrada para saber si leemos o escribimos en un register del banco 
      dataOut           : out std_logic_vector(15 downto 0); --lo que irá conectado a los dos registros de los opers
      address_register  : in std_logic_vector(3 downto 0);
      reset : in std_logic;
      clock             : in std_logic     --validación de la lectura
     );
  end component;

  signal oper_1_in : std_logic_vector(15 downto 0);
  signal oper_1_enable : std_logic;
  signal oper_1_out : std_logic_vector(15 downto 0);

  signal oper_2_in : std_logic_vector(15 downto 0);
  signal oper_2_enable : std_logic;
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

  signal Buffer_in : std_logic_vector(15 downto 0);
  signal Buffer_out : std_logic_vector(15 downto 0);
  signal Buffer_enable : std_logic;

begin

    oper_1_register : registerBlock
    generic map(
        data_size => 16
    )
    port map(
      data_in => oper_1_in,
      enable => oper_1_enable,
      clock => clock,

      data_out => oper_1_out
    );

    oper_2_register : registerBlock
    generic map(
        data_size => 16
    )
    port map(
      data_in => oper_2_in,
      enable => oper_2_enable,
      clock => clock,

      data_out => oper_2_out
    );

    alu : ALU_block
    port map(
      oper_1 => oper_1_out,
      oper_2 => oper_2_out,
      decoder_out => op_code,
      clock => clock,

      out_alu => output_alu
    );

    decoder : Decoder_Block
    port map(
      instruction => IR_out,
      opCode => op_code,
      address_rd => rd_address,
      address_rs => rs_address,
      address_rt => rt_address,
      clock => clock,
      const_imm => constant_data
    );

    instruction_register : registerBlock
    generic map(
        data_size => 32
    )
    port map(
      data_in => RDATA,
      enable => IR_enable,
      clock => clock,

      data_out => IR_out
    );

    bank_register : bankRegister
    port map(
      reg_in_value => bank_register_input,
      read_not_write => bank_register_read_not_write,
      dataOut => bank_register_output,
      address_register => bank_register_address,
      reset => reset,
      clock => clock
    );

    control_unit : control_unit_block
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
      BankReg_address => bank_register_address,

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
      oper_1_enable => oper_1_enable,
      oper_2 => oper_2_in,
      oper_2_enable => oper_2_enable,

      --instructuin register
      Enable_Instruction_Reg => IR_enable,

      --Buffer register
      Buffer_in => Buffer_in,
      Buffer_enable => Buffer_enable,
      Buffer_out => Buffer_out
    );

    buffer_register : registerBlock
    generic map(
        data_size => 16
    )
    port map(
      data_in => Buffer_in,
      enable => Buffer_enable,
      clock => clock,

      data_out => Buffer_out
    );

    
end;
