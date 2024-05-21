--En este apartado implementaremos la máquina de estados:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_block is
  port
  (
    clock : in std_logic;     -- Señal de reloj
    reset : in std_logic;     -- Señal de reinicio

    init_enable :in std_logic;  -- Señal para habilitar la inicialización

    -- MEMORIA -- Entradas y salidas para la ESCRITURA
    WADDR : out std_logic_vector(31 downto 0);   -- Dirección de escritura
    WDATA : out std_logic_vector(31 downto 0);   -- Datos a escribir
    WAVALID : out std_logic;     		 -- Validación de dirección de escritura
    WDATAV : out std_logic;      		 -- Validación de datos de escritura

    WRESP : in std_logic_vector(1 downto 0);  	 -- Respuesta de la escritura
    WRESPV : in std_logic;     			 -- Validación de respuesta de escritura

    -- Entradas y salidas para la LECTURA
    RADDR : out std_logic_vector(31 downto 0);   -- Dirección de lectura
    RAVALID : out std_logic;     		 -- Validación de dirección de lectura

    RDATA : in std_logic_vector(31 downto 0);    -- Datos leídos
    RRESP : in std_logic_vector(1 downto 0);     -- Respuesta de la lectura
    RDATAV : in std_logic;     			 -- Validación de datos leídos

    -- BANCO DE REGISTROS
    BankReg_read_not_write : out std_logic;  		-- Señal de lectura/escritura del banco de registros
    BankReg_input : out std_logic_vector(15 downto 0);  -- Entrada de datos al banco de registros
    BankReg_output : in std_logic_vector(15 downto 0);  -- Salida de datos del banco de registros
    BankReg_address : out std_logic_vector(3 downto 0); -- Dirección del banco de registros
    BankReg_reset : out std_logic;  			-- Señal de reinicio del banco de registros

    -- DECODIFICADOR
    op_code : in std_logic_vector(3 downto 0);     -- Combinación de la operación ha realizar
    address_rd : in std_logic_vector(5 downto 0);  -- Dirección de registro destino
    address_rs : in std_logic_vector(5 downto 0);  -- Dirección de registro rs
    address_rt : in std_logic_vector(5 downto 0);  -- Dirección de registro rt
    const_imm  : in std_logic_vector(7 downto 0);  -- Constante inmediata

    -- ALU
    out_alu : in std_logic_vector(15 downto 0);  -- Salida de la ALU

    -- Operandos
    oper_1 : out std_logic_vector(15 downto 0);  -- Operando 1
    oper_1_enable : out std_logic;  		 -- Habilitación del operando 1
    oper_2 : out std_logic_vector(15 downto 0);  -- Operando 2
    oper_2_enable : out std_logic;  		 -- Habilitación del operando 2

    -- REGISTRO DE INSTRUCCIONES (instruction register)
    Enable_Instruction_Reg : out std_logic;        -- Habilitación del registro de instrucciones

    -- REGISTRO DE BUFFER. NOTA: Registro implementado para el store y el load poder obtener las dos direcciones a la vez.
    Buffer_in : out std_logic_vector(15 downto 0);  -- Entrada del buffer
    Buffer_enable : out std_logic;  		    -- Habilitación del buffer. Depende de si está activado o desactivado, cogeremos una dirección o otra.
    Buffer_out : in std_logic_vector(15 downto 0)   -- Salida del buffer
  );
end entity control_unit_block;

architecture arch_control_unit of control_unit_block is
  -- Definición de los estados de la máquina de estados
  type estadoTipo is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28);
  signal currentState : estadoTipo;  			 -- Señal para el estado actual
  signal PC : std_logic_vector(5 downto 0) := "000000";  -- Contador del programa (Program Counter). Es el puntero que apunta a la siguiente direccion de la memoria (donde dentro hay la instrucción)

begin

  process(clock, reset)

    begin
      -- Si se activa el reset
      if (reset = '1') then
        currentState <= s0; -- Vamos al estado inicial s0

      -- En cada flanco de subida del reloj
      elsif (rising_edge(clock)) then
      case currentState is
          when s0 =>
            -- Inicialización de señales y PC
            PC <= "000000";
            
            WADDR <= "00000000000000000000000000000000";
            WDATA <= "00000000000000000000000000000000";
            WAVALID <= '0';
            WDATAV <= '0';
            
            RADDR <= "00000000000000000000000000000000";
            RAVALID <= '0';

            BankReg_read_not_write <= '1'; --Lectura
            BankReg_input <= "0000000000000000";
            BankReg_address <= "0000";
            BankReg_reset <= '1';

            oper_1 <= "0000000000000000";
            oper_2 <= "0000000000000000";
            oper_1_enable <= '0';
            oper_2_enable <= '0';

            Enable_Instruction_reg <= '0'; -- Su función es retener la instrucción que se quiera ejecutar.

            Buffer_in <= "0000000000000000";
            Buffer_enable <= '0';

            if (init_enable = '1') then
              currentState <= S1; -- Vamos al estado s1 si se habilita la inicialización
            else
              currentState <= s0; -- Permanecemos en s0 si no se habilita la inicialización
            end if;

        when s1 => -- FETCH
            -- Configuramos para leer memoria
            RADDR <= std_logic_vector(resize(signed(PC), RADDR'length)); --Convierte el valor de PC para asignarlo a la señal RADDR.
            RAVALID <= '1'; 
            Enable_Instruction_Reg <= '1'; --Para que podamos guardar la instrucción leida en el IR.
            BankReg_reset <= '0'; 

            if ((RDATAV = '1') and (RRESP = "00")) then -- Se ha leido bien y no hay error (00). NOTA: 01 : error 00 : ok
              currentState <= s2;  -- Vamos al estado s2 si los datos son válidos
            else
              currentState <= s1;  -- Permanecemos en s1 hasta que los datos sean válidos
            end if;
       
        when s2 => -- FETCH
            currentState <= s3;  -- Vamos al estado s3

        when s3 => -- FETCH
            -- Deshabilitar la lectura de memoria
            Enable_Instruction_Reg <= '0';
            RAVALID <= '0'; 
            currentState <= s4;  -- Vamos al estado s4

        when s4 => -- FETCH
            -- Incrementar el PC y configurar el banco de registros para leer el registro fuente 1
            PC <= std_logic_vector(to_signed(to_integer(signed(PC)) + 1, 6));
            BankReg_address <= address_rs(3 downto 0); -- Ponemos la dirección del rs en la dirección del banc register
            currentState <= s5;  -- Vamos al estado s5

        when s5 => --DECODE
            -- Habilitar operandos y buffer para la siguiente operación
            oper_1_enable <= '1';
            oper_2_enable <= '1';
            Buffer_enable <= '1';

            if(op_code = "1000" or op_code = "0111") then -- Store o Load
              currentState <= s19;  -- Vamos al estado s19 
            else
              currentState <= s6;  -- Vamos al estado s6 
            end if;

        when s6 => --DECODE
            -- Cargamos operando 1 desde el banco de registros
            oper_1 <= BankReg_output; --Asiganmos el valor contenido del bank register a operando 1.
            Buffer_enable <= '0';

            currentState <= s26;  -- Vamos al estado s26

        when s7 => --DECODE
            -- Desactivar el operando uno y activar el operando 2.
            oper_1_enable <= '0';
            oper_2_enable <= '1';

            currentState <= s8;  -- Vamos al estado s8

        when s8 => --DECODE
            -- Cargamos operando 2 desde el banco de registros
            oper_2 <= BankReg_output;

            currentState <= s27;  -- Vamos al estado s27

        when s9 => --EXECUTE
            -- Deshabilitar los dos operandos
            oper_1_enable <= '0';
            oper_2_enable <= '0';

            currentState <= s10;  -- Vamos al estado s10

        when s10 =>
            -- Dependiendo del op_code, determinar la siguiente operación
            if (op_code = "1100" or (op_code = "1101" and out_alu = "1111111111111111")) then ----Jump  or  jump conditionally
              currentState <= s14; -- Vamos al s14
              BankReg_address <= address_rd(3 downto 0);
              BankReg_read_not_write <= '1'; --read
            elsif (op_code = "1101" and out_alu = "1010101010101010") then -- jump conditionally
              currentState <= s16;
            else
              currentState <= s11;
            end if;

        when s11 =>
            -- Configuramos el banco de registros para escribir la salida de la ALU
            BankReg_input <= out_alu;
            Bankreg_read_not_write <= '0'; -- write
            BankReg_address <= address_rd(3 downto 0); --Nos posicionamos en la dirección del registro rd del banc register para escribir el resultado.
            
            currentState <= s12; -- Vamos al estado s12

        when s12 =>
            currentState <= s13; -- Vamos al estado s13

        when s13 =>
            -- Finalizamos la escritura en el banco de registros y volver al estado s1
            BankReg_read_not_write <= '1';

            currentState <= s1;

        when s14 =>
            --BankReg_address <= address_rd(3 downto 0);
            --BankReg_read_not_write <= '1';
            currentState <= s28;

        when s15 =>
            PC <= BankReg_output(5 downto 0); -- el contenido del bank register lo asignamos al program counter.

            currentState <= s1; -- Volvemos al estado s1

        when s16 =>
            currentState <= s1; -- Volvemos al estado s1 sin realizar cambios adicionales

        when s17 =>
            -- Configuramos operandos
            oper_1_enable <= '0';
            oper_2_enable <= '1';
            
            currentState <= s18; -- Vamos al estado s18

        when s18 =>
            -- Cargamos el operando 2 con el valor inmediato
            oper_2 <= std_logic_vector(resize(signed(const_imm), oper_2'length));

            currentState <= s9; -- Vamos al estado s9

        when s19 =>
            -- Cargamos el buffer con la salida del banco de registros
            Buffer_in <= BankReg_output;
            oper_1_enable <= '0'; --Desactivamos los operandos
            oper_2_enable <= '0'; --Desactivamos los operandos

            currentState <= s20;  -- Vamos al estado s20

        when s20 =>
            Buffer_enable <= '0'; -- Deshabilitar el buffer
            BankReg_address <= address_rd(3 downto 0); -- Configuramos la dirección del registro destino

            if (op_code = "0111") then -- LOAD
            currentState <= s21;  -- Vamos al estado s21 para lectura de memoria
            else
              currentState <= s24;  --STORE. Vamos al estado s24 para escritura de memoria
            end if;

        when s21 =>
            RADDR <= std_logic_vector(resize(signed(Buffer_out), RADDR'length)); --Asignamos la dirección del registro rs al RADDR
            RAVALID <= '1';
            BankReg_read_not_write <= '0'; --Write. 

            if (RDATAV = '1') then -- Vamos al estado s22 si los datos son válidos
              currentState <= s22;
            else
              currentState <= s21; -- Permanecemos en s21 hasta que los datos sean válidos
            end if;

        when s22 =>
            BankReg_input <= RDATA(15 downto 0); -- Cargamos el banco de registros con los datos leídos de memoria

            currentState <= s23; -- Vamos al estado s23

        when s23 =>
            -- Finalizamos la lectura de memoria y volver al estado s1
            BankReg_read_not_write <= '1'; --read
            RAVALID <= '0';

            currentState <= s1;

        when s24 =>
            WADDR <= std_logic_vector(resize(signed(BankReg_output), WADDR'length));
            WDATA <= std_logic_vector(resize(signed(Buffer_out), WDATA'length));
            WAVALID <= '1';
            WDATAV <= '1';

            if(WRESPV = '1') then 
              currentState <= s25; -- Vamos al estado s25 si la escritura es válida
            else
              currentState <= s24; -- Permanecemos en s24 hasta que la escritura sea válida
            end if;

        when s25 =>
            -- Finalizamos la escritura de memoria y volver al estado s1
            WAVALID <= '0';
            WDATAV <= '0';

            currentState <= s1;

        when s26 =>
            -- Configuramos la siguiente operación basada en el código de operación (op_code)
            if(op_code = "0001") then
              currentState <= s17;
            elsif (op_code = "0110") then
              currentState <= s9;
            else
              BankReg_address <= address_rt(3 downto 0);
              currentState <= s7;
            end if;

        when s27 => 
            currentState <= s9;
        
        when s28 =>
            currentState <= s15;

        when others =>
            currentState <= s0;

      end case;

    end if;
  end process;
end arch_control_unit; 