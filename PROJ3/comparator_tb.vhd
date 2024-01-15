LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity comparator_tb is
end entity comparator_tb;

architecture c_tb of comparator_tb is

    constant BITS: integer := 16;

    signal a, b: std_logic_vector(BITS-1 downto 0);
    signal alb, aeb, agb: std_logic;

    component n_bit_comparator is
        generic (n: integer := BITS);
        port(
            a, b: in std_logic_vector(n-1 downto 0);
            alb, aeb, agb: out std_logic
        );
    end component;


begin
    
    testbench: process
    begin
        
        a <= x"1345";
        b <= x"1311";
        wait for 10 ns;

        
        a <= x"F190";
        b <= x"FFFF";
        wait for 10 ns;


        a <= x"3000";
        b <= x"3000";
        wait for 10 ns;

        wait;
    end process testbench;
    
    u1: n_bit_comparator generic map(BITS) port map(a, b, alb, aeb, agb);

    
end architecture c_tb;
