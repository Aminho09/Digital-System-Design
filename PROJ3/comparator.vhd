library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity one_bit_comparator is
    port (
        a, b, alb_in, aeb_in, agb_in: in std_logic;
        alb_out, aeb_out, agb_out: out std_logic
        );
end entity one_bit_comparator;

architecture obc of one_bit_comparator is
    signal temp: std_logic_vector(1 downto 0);
    signal result: std_logic_vector(2 downto 0);
begin
    temp <= a & b;

    
    result <=   "001" when ((temp = "01" or alb_in = '1') and agb_in = '0') else
                "010" when ((temp = "10" or agb_in = '1') and alb_in = '0') else
                "100" when (temp = "00" or temp = "11") else
                "XXX";

    alb_out <= result(0);
    agb_out <= result(1);
    aeb_out <= result(2);
    
end architecture obc;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity n_bit_comparator is
    generic (n: integer := 8);
    port (
        a, b: in std_logic_vector(n-1 downto 0);
        alb, aeb, agb: out std_logic
    );
end entity n_bit_comparator;

architecture nbc of n_bit_comparator is
    component one_bit_comparator
        port (
            a, b, alb_in, aeb_in, agb_in: in std_logic;
            alb_out, aeb_out, agb_out: out std_logic
        );
    end component;
    
    signal temp_alb, temp_aeb, temp_agb: std_logic_vector(n downto 0);
begin

    temp_alb(n) <= '0';
    temp_aeb(n) <= '0';
    temp_agb(n) <= '0';

    comp: for i in n-1 downto 0 generate
        u1: one_bit_comparator port map(a(i), b(i), temp_alb(i+1), temp_aeb(i+1), temp_agb(i+1), temp_alb(i), temp_aeb(i), temp_agb(i));
    end generate comp;
    
    alb <= temp_alb(0);
    aeb <= temp_aeb(0);
    agb <= temp_agb(0);
    
end architecture nbc;
