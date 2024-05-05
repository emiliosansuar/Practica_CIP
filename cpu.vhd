--TO DO: Máquina de estados (unidad de control), ALU, Banco de registro , Decoder


-- 3 registros para operaciones. 2 de valores y 1 de reultados 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
  port
  (
    --entradas y salidas 
    in_mem_to_cpu   : in std_logic_vector (31 downto 0);
    out_cpu_to_mem  : out std_logic_vector (31 downto 0);
    mem_address     : out std_logic_vector (5 downto 0);
    --Bus de escritura
    waddr           : out std_logic_vector (31 downto 0); --dirección de la data a escribir 
    wavalid         : out std_logic; --validacion de la dirección de escritura 
    wdata           : out std_logic_vector (31 downto 0); --data a escribir 
    wdatav          : out std_logic; --validacin de la data a escribir 
    wresp           : in std_logic_vector (1 downto 0); -- respuesta de la escritura 
    wrespv          : in std_logic; -- validacion de la respuesta de escritura 

    --Bus de escritura 
    raddr           : out std_logic_vector (31 downto 0); --direccion de la data a leer 
    ravalid         : out std_logic; --validacion de la dirección de lectura
    rdata           : in std_logic_vector (31 downto 0); --data a leer
    rdatav          : in std_logic; --validación de la data a leer
    rresp           : in std_logic_vector (1 downto 0); --respuesta de la leectura 
    clock           : in std_logic
    
  );
end entity cpu;

architecture arch_cpu of cpu is
  type register_banc is array (0 to 15) of std_logic_vector(15 downto 0); -- 16 direcciones con 16 bits cada una.
  signal banc_register : register_banc := (
    others => (others => '0') -- Inicializa todas las direcciones con ceros
  );  



    -- SIGNALS --------------------------------------
    signal oper_1: std_logic_vector (15 downto 0);
    signal oper_2: std_logic_vector (15 downto 0);
    signal out_alu: std_logic_vector (15 downto 0);
    signal decoder_in: std_logic_vector (31 downto 0); --DATO
    signal decoder_out: std_logic_vector (13 downto 0);
    signal prog_count: std_logic_vector (5 downto 0);
    signal instruct_reg: std_logic_vector (31 downto 0);
    


  ---DECODER PARA LO DE LAS OPERACIONES:
  --32 BITS  --- LOS TROCEAMOS Y LOS 4 PRIMEROS OPCODE.
  --EN FUNCIÓN DE ESOS 4 SE TE ACTIVA UNO DE LOS 16 BITS .
  
    -- Componentes -----------------------------------
  
  
  
  begin
    -- Instanciacion de componentes  ----------------------------

    --  inicio ALU
    process(clock)
      variable Add_op : std_logic_vector (15 downto 0);
      variable Substract_op : std_logic_vector (15 downto 0);
      variable Or_op : std_logic_vector (15 downto 0);
      variable Xor_op : std_logic_vector (15 downto 0);
      variable And_op : std_logic_vector (15 downto 0);
      variable Not_op : std_logic_vector (15 downto 0);
      variable Compare_op : std_logic_vector (15 downto 0);
      variable Shift_left_op : std_logic_vector (15 downto 0);
      variable Shift_right_op : std_logic_vector (15 downto 0);
      variable Jump_conditionallly_op : std_logic_vector (15 downto 0);
    begin
      Add_op := std_logic_vector(signed(oper_1) + signed(oper_2));         --Add y Add Immediate
      
      Substract_op := std_logic_vector(signed(oper_1) - signed(oper_2));   --Substract
      
      Or_op := oper_1 or oper_2;  --Or
      
      Xor_op := oper_1 xor oper_2;  --Xor
      
      And_op := oper_1 and oper_2;      --And
      
      Not_op := not oper_1;      --Not
            --Load  -> pasamos oper_1 a out_alu directament
            --Store -> pasamos oper_1 a out_alu directament
      
      if (signed(oper_1) > signed(oper_2)) then
 	      Compare_op := "0000000000000001";
      else
	      Compare_op := "0000000000000000";
      end if;
      
      Shift_left_op := std_logic_vector(shift_left(unsigned(oper_1), to_integer(unsigned(oper_2))));      --Shift Left   shift_left(oper_1, to_integer(unsigned(oper_2)))
      
      Shift_right_op := std_logic_vector(shift_right(unsigned(oper_1), to_integer(unsigned(oper_2))));      --Shift Right
            --Jump/Branch  -> pasamos oper_1 a out_alu directament

      if (oper_1 = oper_2) then
 	      Jump_conditionallly_op := "1111111111111111";
      else
	      Jump_conditionallly_op := "1010101010101010";
      end if;



      case decoder_out is
        when "10000000000000" =>
        out_alu <=  Add_op;
        when "01000000000000" =>
        out_alu <=  Add_op;
        when "00100000000000" =>
        out_alu <=  Substract_op;
        when "00010000000000" =>
        out_alu <=  Or_op;
        when "00001000000000" =>
        out_alu <=  Xor_op;
        when "00000100000000" =>
        out_alu <=  And_op;
        when "00000010000000" =>
        out_alu <=  Not_op;
        when "00000001000000" =>
        out_alu <=  oper_1;
        when "00000000100000" =>
        out_alu <=  oper_1;
        when "00000000010000" =>
        out_alu <=  Compare_op;
        when "00000000001000" =>
        out_alu <=  Shift_left_op;
        when "00000000000100" =>
        out_alu <=  Shift_right_op;
        when "00000000000010" =>
        out_alu <=  oper_1;
        when "00000000000001" =>
        out_alu <=  Jump_conditionallly_op;
	when others =>
	out_alu <=  "1010101010101010";
      end case;
    end process;
    --  fin ALU
  
    -- PROCESOS --------------------------------------------------
  
  end;
