library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port
  (
    oper_1      : in std_logic_vector (15 downto 0);
    oper_2      : in std_logic_vector (15 downto 0);
    decoder_out : in std_logic_vector (13 downto 0);
    clock       : in std_logic

    out_alu     : out std_logic_vector (15 downto 0);
  );
end entity alu;

architecture arch_alu of alu is

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
    
  begin

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

    out_alu <=  Add_op 		when decoder_out = "10000000000000" else
                Add_op 		when decoder_out = "01000000000000" else
                Substract_op 		when decoder_out = "00100000000000" else
                Or_op 		when decoder_out = "00010000000000" else
                Xor_op 		when decoder_out = "00001000000000" else
                And_op 		when decoder_out = "00000100000000" else
                Not_op 		when decoder_out = "00000010000000" else
                oper_1 		when decoder_out = "00000001000000" else
                oper_1 		when decoder_out = "00000000100000" else
                Compare_op 		when decoder_out = "00000000010000" else
                Shift_left_op 	when decoder_out = "00000000001000" else
                Shift_right_op 	when decoder_out = "00000000000100" else
                oper_1 		when decoder_out = "00000000000010" else
                Jump_conditionallly_op when decoder_out = "00000000000001";


  end;
