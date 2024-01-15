library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.UART_package.all;

entity UART_tb is
end entity UART_tb;

architecture test of UART_tb is
    SIGNAL t_nreset:    std_LOGIC := '0';
    SIGNAL t_clk:       std_LOGIC := '0';
    SIGNAL t_start:     std_LOGIC := '0';
    SIGNAL t_data_in:   std_logic_vector(7 downto 0);
    SIGNAL t_tx:        std_LOGIC;
    SIGNAL t_rx:        std_LOGIC := '1';
    SIGNAL t_data_out:  std_logic_vector(7 downto 0);
    SIGNAL t_strobe:    std_logic;
    SIGNAL HalfPeriod:  TIME := 5 ns;
begin

    read_file(HalfPeriod, t_nreset, t_clk, t_start, t_rx, t_data_in);
    u1: UART PORT MAP(t_nreset, t_clk, t_start, t_data_in, t_tx, t_rx, t_data_out, t_strobe);
    
end architecture test;