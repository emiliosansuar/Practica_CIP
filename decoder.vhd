entity decoder is
    Port (
        instruction : in std_logic_vector(31 downto 0); 
        opcode: out std_logic_vector(3 downto 0);
        address_rd: out std_logic_vector(5 downto 0);
        address_rs: out std_logic_vector(5 downto 0);
        address_rt: out std_logic_vector(5 downto 0);
        const_imm: : out std_logic_vector(7 downto 0);
        --ravalid :  out std_logic;
        -- mirar foto
    );
end decoder;


architecture Behavioral of decoder is
    begin
       opcode <= instruction(31 downto 28);

       when opcode == "0000" or .... => --add
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(11 downto 6);
            address_rt  <= instruction(5 downto 0);
            type_oper <= "00" --RRR

       when opcode == "0001" => --add immediate
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(17 downto 12);
            const_imm  <= instruction(7 downto 0);
            type_oper <= "11" --RRimm
        
        when opcode == "0010" => --substract
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(11 downto 6);
            address_rt  <= instruction(5 downto 0);
            type_oper <= "00" --RRR


        when opcode == "0011" => -- or
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(11 downto 6);
            address_rt  <= instruction(5 downto 0);
            type_oper <= "00" --RRR

       when opcode == "0100" => --xor
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(11 downto 6);
            address_rt  <= instruction(5 downto 0);
            type_oper <= "00" --RRR
        
        when opcode == "0101" => --and
            address_rd  <= instruction(23 downto 18);
            address_rs  <= instruction(17 downto 12);
            const_imm  <= instruction(7 downto 0);
            type_oper <= "11" --RRR

        







end Behavioral;