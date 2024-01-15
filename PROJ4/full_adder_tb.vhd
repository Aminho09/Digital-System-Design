library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_tb is
end entity full_adder_tb;

architecture test of full_adder_tb is
    
    constant bits: integer := 8;

    component full_adder is
        generic (n: integer := bits);
        port (
            a, b, start, clk, nrst: in std_logic;
            cout: out std_logic;
            done: out std_logic := '0';
            sum: out std_logic_vector(n-1 downto 0)
        );
    end component full_adder;

    signal a:       std_logic;
    signal b:       std_logic;
    signal clk:     std_logic := '0';
    signal nrst:    std_logic := '1';
    signal start:   std_logic := '0';
    signal done:    std_logic;
    signal sum:     std_logic_vector(bits-1 downto 0);
    signal cout:    std_logic;


begin

    clk <= not clk after 5 ns;
    
    testbench: process
    begin

        wait for 10 ns;

        start <= '1';
        nrst <= '0';
        a <= '1';
        b <= '0';
        wait for 10 ns;

        a <= '1';
        b <= '1';
        wait for 10 ns;

        a <= '1';
        b <= '0';
        wait for 10 ns;

        a <= '0';
        b <= '0';
        wait for 10 ns;

        a <= '0';
        b <= '1';
        wait for 10 ns;

        a <= '1';
        b <= '1';
        wait for 10 ns;

        a <= '0';
        b <= '0';
        wait for 10 ns;

        a <= '0';
        b <= '1';
        wait for 10 ns;

        wait;
    end process testbench;
    
    u1: full_adder generic map(bits) port map(a, b, start, clk, nrst, cout, done, sum);
    
end architecture test;
