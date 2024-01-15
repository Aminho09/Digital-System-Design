library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
    generic (n: integer := 8);
    port (
        a, b, start, clk, nrst: in std_logic;
        cout: out std_logic;
        done: out std_logic := '0';
        sum: out std_logic_vector(n-1 downto 0)
    );
end entity full_adder;


architecture fa of full_adder is
    signal index: integer := 0;
    signal c: std_logic_vector(n downto 0) := (others => '0');
begin
    adding: process(clk, nrst, start)
    begin

        if nrst = '1' then
            sum <= (others => 'X');
            cout <= 'X';

        else
            if rising_edge(clk) then
                if index = n then
                    cout <= c(index);
                    done <= '1';
                elsif start = '1' then
                    sum(index) <= a XOR b XOR c(index);
                    c(index+1) <= (a AND b) OR (a AND c(index)) OR (b AND c(index));
                    index <= index + 1;
                    done <= '0';
                end if;
            end if;
        end if; 
    end process adding;
    
    
end architecture fa;
