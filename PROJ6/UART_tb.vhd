library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_tb is
end entity UART_tb;

architecture testbench of UART_tb is

    COMPONENT UART is
        port (
            clk     : IN STD_LOGIC;
            rst     : IN STD_LOGIC;
            baud    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    
            -- serial part
            io      : INOUT STD_LOGIC;
    
            -- parallel part
    
            -- transmitter
            start   : IN STD_LOGIC;
            din     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    
            -- receiver
            dout    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
            done    : OUT STD_LOGIC := '0'
    
        );
    end COMPONENT UART;

    SIGNAL t_clk    : STD_LOGIC := '0';
    SIGNAL t_rst    : STD_LOGIC := '1';
    SIGNAL t_baud   : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000001";
    SIGNAL t_io     : STD_LOGIC := '1';
    SIGNAL t_start  : STD_LOGIC := '0';
    SIGNAL t_din    : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    SIGNAL t_dout   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL t_done   : STD_LOGIC;

    -- SIGNAL x01 : STD_LOGIC;
    -- SIGNAL x10 : STD_LOGIC;

begin
    t_clk <= NOT t_clk AFTER 5 ns;
    -- x10 <= x01;
    test: process
    begin
        
        WAIT for 20 ns;

        t_rst <= '0';
        WAIT for 10 ns;

        -- transmit mode
        t_start <= '1';
        t_io    <= 'Z';
        t_din   <= "01100011";
        WAIT for 110 ns;

        t_io <= '1';
        WAIT for 10 ns;

        t_start <= '0';
        WAIT for 20 ns;

        -- receive mode
        t_io <= '0';
        WAIT for 20 ns;

        -- 10110001
        t_io <= '1';
        WAIT for 10 ns;

        t_io <= '0';
        WAIT for 10 ns;

        t_io <= '0';
        WAIT for 10 ns;

        t_io <= '0';
        WAIT for 10 ns;

        t_io <= '1';
        WAIT for 10 ns;

        t_io <= '1';
        WAIT for 10 ns;

        t_io <= '0';
        WAIT for 10 ns;

        t_io <= '1';
        WAIT for 10 ns;

        t_io <= '1';
        WAIT for 10 ns;

        WAIT;
    end process test;

    u1: UART PORT MAP(t_clk, t_rst, t_baud, t_io, t_start, t_din, t_dout, t_done);
    
end architecture testbench;
