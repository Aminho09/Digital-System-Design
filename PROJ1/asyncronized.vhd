LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity A_SRAM1024x8 is
    port (
        addr:       in std_logic_vector(9 downto 0);
        CLK, wr:    in std_logic;
        din:        in std_logic_vector(7 downto 0);
        dout:       out std_logic_vector(7 downto 0)
    );
end entity A_SRAM1024x8;

architecture instance of A_SRAM1024x8 is
    type memory is array (0 to 1023) of std_logic_vector(7 downto 0);
    signal mem: memory;
begin
    proc_name: process(clk)
    begin
        if rising_edge(clk) then
            if wr = '1' then
                mem(conv_integer(addr)) <= din; 
            end if;
        end if;
    end process proc_name;
    
    dout <= mem(conv_integer(addr));
    
    
end architecture instance;

