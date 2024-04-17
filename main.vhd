--emilio puto


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AC4 is
  port
  (
    --entradas y salidas AC4 
    clock : in std_logic;
    --reset : in std_logic;
    SW : in std_logic_vector(9 downto 0); 
    B : in std_logic_vector(1 downto 0);
    LED : out std_logic_vector(9 downto 0);
    seg_out_0 : out std_logic_vector(6 downto 0);
    seg_out_1 : out std_logic_vector(6 downto 0);
    seg_out_2 : out std_logic_vector(6 downto 0)
  );
end entity AC4;

architecture arch_AC4 of AC4 is
  type statetype is (S0, S1, S2, S3, S4, S5, S6, S7);
  signal state, nextstate : statetype;
  --mirar si la 1 es rom y la dos es ram
  type rom_type is array(0 to 6) of std_logic_vector(9 downto 0); --almacena 7 IDs de 10 bits cada uno
  constant IDs_MEM : rom_type := ("0000000000",
				  "0100000101",
				  "0010001001",
				  "0000101000",
				  "0000000100",
				  "0100000111",
				  "1100000100");
  type rw_type is array (0 to 6) of std_logic_vector(9 downto 0); --almacena 7 Precios de 10 bits cada uno
  --signal RAM_mem_type : rw_type;
  signal Preus_MEM : rw_type := ("1111111111",
			          "1010100001",
				  "0010110010",
				  "0111000011",
				  "0011010100",
				  "0111100101",
				  "0011110110");

  -- SIGNALS --------------------------------------
  signal we : std_logic; --Write enable 
  signal address : std_logic_vector(2 downto 0); -- para ambas memorias
  signal address_aux : std_logic_vector(2 downto 0); -- para ambas memorias
  signal found : std_logic;  
  signal id_num : std_logic_vector(9 downto 0):= "0000000000"; --los 10 bits leidos de la mem de IDs
  signal preu_num : std_logic_vector(9 downto 0):= "0000000000"; --los 10 bits de la mem Preus
  signal digit_0_p : std_logic_vector(3 downto 0);
  signal digit_1_p : std_logic_vector(3 downto 0);
  signal digit_2_p : std_logic_vector(3 downto 0);



  -- Componentes -----------------------------------

    component dec7seg is
        port(
            in_abc   : in std_logic_vector(3 downto 0);
            out_7seg : out std_logic_vector(6 downto 0)
        );
    end component;


begin
  -- Instanciacion de componentes  ----------------------------

  --instanciacion de los 3 displays 7 segments que deben de mostrar los digitos de la memoria de precios
  inst7s0: dec7seg port map (in_abc => digit_0_p, out_7seg => seg_out_0);
  inst7s1: dec7seg port map (in_abc => digit_1_p, out_7seg => seg_out_1);
  inst7s2: dec7seg port map (in_abc => digit_2_p, out_7seg => seg_out_2);    

  -- PROCESOS --------------------------------------------------

  -- state process si hay reset
  process (clock, B, state, nextstate) begin
    if (B = "11") then
      state <= S0;
    elsif (rising_edge(clock)) then
      state <= nextstate;
    end if;
  end process;

  -- next state logic (maquina de estados)
  process (state, nextstate, B, address, found, digit_0_p, digit_1_p, digit_2_p, clock) begin
    case state is
      when S0 =>
	LED <= "0000000000"; -- LEDs en OFF
	digit_0_p <= "1010"; --AAA en 7Segments
	digit_1_p <= "1010";
	digit_2_p <= "1010";
	address <= "000";
	address_aux <= "000";
	found <= '0';
	we <= '0';
        if (B = "01") then
          nextstate <= S1;
        elsif (B = "10") then
          nextstate <= S4;
	elsif (B = "00") then
	  nextstate <= S0;
        end if;

      when S1 =>
	if (rising_edge(clock) and address < "111" ) then
	  id_num <= IDs_MEM(to_integer(unsigned(address))); --leer de la memoria de IDs 
	  if (id_num = SW) then
	    found <= '1';
	    address_aux <= address;
	    LED <= id_num;
	    we <= '0';
	  else 
	    found <= '0';
	    address <= std_logic_vector(unsigned(address) + 1);
	  end if;

	else 
	  --nada
	end if;

	if (found = '1') then
            nextstate <= S2; --si coinciden ID y dato memoria, lectura precio 
        elsif (address /= "111" and found = '0') then
            nextstate <= S1; --si no ha leido todas las address y no coinciden IDs, sigue en S1
	elsif (address = "111" and found = '0') then
	    nextstate <= S3; --si ya leyo todas las address y no coincide, S3
        end if;
	

      when S2 =>
        if (we = '0') then
	  preu_num <= Preus_MEM(to_integer(unsigned(address_aux)- 1));
	  --LED <= id_num;
	  digit_0_p <= preu_num(3 downto 0);
	  digit_1_p <= preu_num(7 downto 4);
	  digit_2_p <= ("00" & preu_num(9 downto 8));
	  
        else
          --nada
        end if;

	if (B /= "10") then
	    nextstate <= S2;
	elsif (B = "10") then
	    nextstate <= S0;
	end if;
	

      when S3 =>
	LED <= "0000000000"; -- LEDs en OFF
	digit_0_p <= "0000"; --EE0 en 7Segments
	digit_1_p <= "1110";
	digit_2_p <= "1110";
	if (B /= "10") then
	  nextstate <= S3;
	elsif (B = "10") then
	  nextstate <= S0;
	end if;

      when S4 =>

	if (rising_edge(clock) and address < "111" ) then
	  id_num <= IDs_MEM(to_integer(unsigned(address))); --leer de la memoria de IDs 
	  if ((id_num = SW) and (address /= "000")) then
	    found <= '1';
	    address_aux <= address;
	    LED <= id_num;
	    we <= '1';
	  else
	    found <= '0';
	    address <= std_logic_vector(unsigned(address) + 1);
	  end if;

	else
	  --nada
	end if;

	if ((found = '1') and (address /= "001"))  then
            nextstate <= S6; --si coinciden ID y dato memoria, escritura precio 
        elsif (address /= "111" and found = '0') then
            nextstate <= S4; --si no ha leido todas las address y no coinciden IDs, sigue en S4
	--elsif ((address = "111" and found = '0') or (address = "001" and found = '0')) then
	elsif (address = "111" and found = '0')  then
	    nextstate <= S5; --si ya leyo todas las address y no coincide, S5
        end if;


      when S5 =>
	LED <= "0000000000"; -- LEDs en OFF
	digit_0_p <= "0001"; --EE1 en 7Segments
	digit_1_p <= "1110";
	digit_2_p <= "1110";
	if (B /= "10") then
	  nextstate <= S5;
	elsif (B = "10") then
	  nextstate <= S0;
	end if;

      when S6 =>
	--Espero que introduzcan precio por SW y que B = 01
	if (B /= "01") then
	  nextstate <= S6;
	elsif (B = "01") then
	  nextstate <= S7;
	end if;

      when S7 =>
        if (we = '1') then
	  Preus_MEM(to_integer(unsigned(address_aux)- 1)) <= SW;
	  --LED <= id_num;
	  digit_0_p <= "1101"; --ddd en 7Segments
	  digit_1_p <= "1101";
	  digit_2_p <= "1101";

        else
          --nada
        end if;

	if (B /= "10") then
	    nextstate <= S7;
	elsif (B = "10") then
	    nextstate <= S0;
	end if;

      when others =>
        nextstate <= S0;

    end case;
  end process;

end;
-------------------------------------------   