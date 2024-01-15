library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_tb_raw is
end entity UART_tb_raw;

architecture test of UART_tb_raw is
    COMPONENT UART is
        port (
            nreset:     in  std_logic;
            clk:        in  std_logic;
            start:      in  std_LOGIC;
            data_in:    in  std_logic_vector(7 downto 0);
            tx:         out std_LOGIC;
            rx:         in  std_LOGIC;
            data_out:   out std_logic_vector(7 downto 0);
            strobe:     out std_LOGIC
        );
    end COMPONENT UART;
    SIGNAL t_nreset:    std_LOGIC := '0';
    SIGNAL t_clk:       std_LOGIC := '0';
    SIGNAL t_start:     std_LOGIC := '0';
    SIGNAL t_data_in:   std_logic_vector(7 downto 0) := "01101001";
    SIGNAL t_tx:        std_LOGIC;
    SIGNAL t_rx:        std_LOGIC := '1';
    SIGNAL t_data_out:  std_logic_vector(7 downto 0);
    SIGNAL t_strobe:    std_logic;

begin
    t_clk <= NOT t_clk AFTER 5 ns;

    testbench: process
    begin

        WAIT for 20 ns;
        t_nreset <= '1';

        WAIT for 10 ns;

        -- transmit mode
        t_start <= '1';
        WAIT for 90 ns;

        t_start <= '0';
        WAIT for 5 ns;

        -- receive mode
        t_rx <= '0';
        WAIT for 10 ns;

        -- 10110001
        t_rx <= '1';
        WAIT for 10 ns;

        t_rx <= '0';
        WAIT for 10 ns;

        t_rx <= '0';
        WAIT for 10 ns;

        t_rx <= '0';
        WAIT for 10 ns;

        t_rx <= '1';
        WAIT for 10 ns;

        t_rx <= '1';
        WAIT for 10 ns;

        t_rx <= '0';
        WAIT for 10 ns;

        t_rx <= '1';
        WAIT for 10 ns;

        t_rx <= '1';
        WAIT for 10 ns;


        WAIT;
    end process testbench;

    u1: UART PORT MAP(t_nreset, t_clk, t_start, t_data_in, t_tx, t_rx, t_data_out, t_strobe);
    
    
end architecture test;
