library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port
  (
    oper_1      : in std_logic_vector (15 downto 0);
    oper_2      : in std_logic_vector (15 downto 0);
    decoder_out : in std_logic_vector (3 downto 0);
    clock       : in std_logic;

    out_alu     : out std_logic_vector (15 downto 0)
  );
end entity alu;

architecture arch_alu of alu is

    component register_block is
        generic(
        		data_size : integer := 6 
    		); 

   		port(
        		data_in : in std_logic_vector((data_size - 1) downto 0);
        		enable  : in std_logic;
        		clock   : in std_logic;

        		data_out : out std_logic_vector((data_size - 1) downto 0)
    		);

    end component;

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

    signal input_register : std_logic_vector (15 downto 0);
    
  begin

    output_register : register_block
    generic map(
        data_size => 16
    )
	port map(
		data_in => input_register,
		enable => '1',
		clock => clock,

		data_out => out_alu
	);

    Add_op <= std_logic_vector(signed(oper_1) + signed(oper_2));         --Add y Add Immediate
    
    Substract_op <= std_logic_vector(signed(oper_1) - signed(oper_2));   --Substract
    
    Or_op <= oper_1 or oper_2;  --Or
    
    Xor_op <= oper_1 xor oper_2;  --Xor
    
    And_op <= oper_1 and oper_2;      --And
    
    Not_op <= not oper_1;      --Not
          --Load  -> pasamos oper_1 a out_alu directament
          --Store -> pasamos oper_1 a out_alu directament
    
    Compare_op <= "0000000000000001" when (signed(oper_1) > signed(oper_2)) else
                  "0000000000000000";    --Compare
    
    Shift_left_op <= std_logic_vector(shift_left(unsigned(oper_1), to_integer(unsigned(oper_2))));      --Shift Left   shift_left(oper_1, to_integer(unsigned(oper_2)))
    
    Shift_right_op <= std_logic_vector(shift_right(unsigned(oper_1), to_integer(unsigned(oper_2))));      --Shift Right
          --Jump/Branch  -> pasamos oper_1 a out_alu directament
    
    Jump_conditionallly_op <= "1111111111111111" when (oper_1 = oper_2) else
                              "1010101010101010";    --Jump/Branch conditionally

    input_register <=   Add_op 		    when decoder_out = "0000" else
                        Add_op 		    when decoder_out = "0001" else
                        Substract_op    when decoder_out = "0010" else
                        Or_op 		    when decoder_out = "0011" else
                        Xor_op 		    when decoder_out = "0100" else
                        And_op 		    when decoder_out = "0101" else
                        Not_op 		    when decoder_out = "0110" else
                        oper_1 		    when decoder_out = "0111" else
                        oper_1 		    when decoder_out = "1000" else
                        Compare_op 	    when decoder_out = "1001" else
                        Shift_left_op 	when decoder_out = "1010" else
                        Shift_right_op 	when decoder_out = "1011" else
                        oper_1 		    when decoder_out = "1100" else
                        Jump_conditionallly_op when decoder_out = "1101";


  end;
