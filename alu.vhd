library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_block is 
  port
  (
    oper_1      : in std_logic_vector (15 downto 0); -- Primer operando de la ALU
    oper_2      : in std_logic_vector (15 downto 0); -- Segundo operando de la ALU
    decoder_out : in std_logic_vector (3 downto 0);  -- Entrada de control para seleccionar la operación
    clock       : in std_logic;                      -- Señal de reloj
    out_alu     : out std_logic_vector (15 downto 0) -- Resultado de la operación de la ALU
  );
end entity ALU_block;

architecture arch_alu of ALU_block is

    -- Importamos el componente del bloque de registro
    component registerBlock is
        generic(
            data_size : integer := 6  -- Tamaño de los datos
        ); 
        port(
            data_in : in std_logic_vector((data_size - 1) downto 0);  -- Entrada de datos al bloque de registro
            enable  : in std_logic;                                   -- Señal de habilitación para poder guardar y luego mostrar
            clock   : in std_logic;                                   -- Señal de reloj
            data_out : out std_logic_vector((data_size - 1) downto 0) -- Salida de datos del bloque de registro
        );
    end component;

    -- Señales internas para cada operación:
    signal Add_op : std_logic_vector (15 downto 0);
    signal Substract_op : std_logic_vector (15 downto 0);
    signal Or_op : std_logic_vector (15 downto 0);
    signal Xor_op : std_logic_vector (15 downto 0);
    signal And_op : std_logic_vector (15 downto 0);
    signal Not_op : std_logic_vector (15 downto 0);
    signal Compare_op : std_logic_vector (15 downto 0);
    signal Shift_left_op : std_logic_vector (15 downto 0);
    signal Shift_right_op : std_logic_vector (15 downto 0);
    signal Jump_conditionallly_op : std_logic_vector (15 downto 0);
    signal input_register : std_logic_vector (15 downto 0); -- Registro de entrada para la ALU
    
  begin

    -- Instanciamos del bloque de registro
    output_registerBlock : registerBlock
    generic map(
        data_size => 16 -- Tamaño del bus de datos (16 bits)
    )
    port map(
      data_in => input_register, -- Conexión de la entrada de datos al registro de entrada de la ALU
      enable => '1',             -- Señal de habilitación
      clock => clock,            -- Señal de reloj
      data_out => out_alu        -- Salida de datos conectada a la salida de la ALU
    );

    --Las diferentes operaciones de la ALU:

    Add_op <= std_logic_vector(signed(oper_1) + signed(oper_2));         -- Operación de suma
    Substract_op <= std_logic_vector(signed(oper_1) - signed(oper_2));   -- Operación de resta
    Or_op <= oper_1 or oper_2;                                           -- Operación OR
    Xor_op <= oper_1 xor oper_2;                                         -- Operación XOR
    And_op <= oper_1 and oper_2;                                         -- Operación AND
    Not_op <= not oper_1;                                                -- Operación NOT

    -- Comparación
    	-- Si oper_1 > oper_2 el resultado será 1 
    	--  Si oper_1 < oper_2 el resultado será 0
    Compare_op <= "0000000000000001" when (signed(oper_1) > signed(oper_2)) else
                  "0000000000000000";               -- Operación de comparación

    -- Operación de desplazamiento a la izquierda
    Shift_left_op <= std_logic_vector(shift_left(unsigned(oper_1), to_integer(unsigned(oper_2))));
    
    -- Operación de desplazamiento a la derecha
    Shift_right_op <= std_logic_vector(shift_right(unsigned(oper_1), to_integer(unsigned(oper_2))));

    -- Condicional de salto
    Jump_conditionallly_op <= "1111111111111111" when (oper_1 = oper_2) else
                              "1010101010101010";     -- Operación de salto condicional

    -- Multiplexor para seleccionar la operación basada en decoder_out
    input_register <=   Add_op                  when decoder_out = "0000" else
                        Add_op                  when decoder_out = "0001" else
                        Substract_op            when decoder_out = "0010" else
                        Or_op                   when decoder_out = "0011" else
                        Xor_op                  when decoder_out = "0100" else
                        And_op                  when decoder_out = "0101" else
                        Not_op                  when decoder_out = "0110" else
                        oper_1                  when decoder_out = "0111" else
                        oper_1                  when decoder_out = "1000" else
                        Compare_op              when decoder_out = "1001" else
                        Shift_left_op           when decoder_out = "1010" else
                        Shift_right_op          when decoder_out = "1011" else
                        oper_1                  when decoder_out = "1100" else
                        Jump_conditionallly_op  when decoder_out = "1101";
  end arch_alu;
