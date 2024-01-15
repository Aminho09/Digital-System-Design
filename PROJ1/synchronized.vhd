LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity s_SRAM1024x8 is
    port (
        addr:       in std_logic_vector(9 downto 0);
        CLK, wr:    in std_logic;
        din:        in std_logic_vector(7 downto 0);
        dout:       out std_logic_vector(7 downto 0)
    );
end entity s_SRAM1024x8;

architecture instance of s_SRAM1024x8 is
    type mem is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal mem1: mem;
begin
    proc_name: process(clk)
    begin
        if rising_edge(clk) then
            if wr = '1' then
                mem1(conv_integer(addr)) <= din; 
            end if;
        dout <= mem1(conv_integer(addr));
        end if;
    end process proc_name;
    
    
end architecture instance;
