library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity elevator_tb is
end entity elevator_tb;

architecture test of elevator_tb is
    component elevator is
        port (
            clk         :   IN  STD_LOGIC;
            rst         :   IN  STD_LOGIC;
            up          :   IN  STD_LOGIC_VECTOR(3 downto 0);
            down        :   IN  STD_LOGIC_VECTOR(3 downto 0);
            sw          :   IN  STD_LOGIC_VECTOR(3 downto 0);
            flr         :   OUT STD_LOGIC_VECTOR(3 downto 0);
            motor_up    :   OUT STD_LOGIC;
            motor_down  :   OUT STD_LOGIC;
            move_state  :   OUT STD_LOGIC
        );
    END component elevator;

    SIGNAL t_clk          :   STD_LOGIC := '0';
    SIGNAL t_rst          :   STD_LOGIC := '1';
    SIGNAL t_up           :   STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    SIGNAL t_down         :   STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    SIGNAL t_sw           :   STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    SIGNAL t_flr          :   STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL t_motor_up     :   STD_LOGIC;
    SIGNAL t_motor_down   :   STD_LOGIC;
    SIGNAL t_move_state   :   STD_LOGIC;

begin
    t_clk <= NOT t_clk AFTER 5 ns;

    testbench: process
    begin

        WAIT for 20 ns;

        t_rst <= '0';
        WAIT for 10 ns;

        t_up <= "0110";
        WAIT for 20 ns;

        t_down <= "0001";
        t_up <= "0100";
        WAIT for 10 ns;

        t_up <= "0000";
        t_sw <= "0010";
        WAIT for 30 ns;

        t_sw <= "0000";
        

        WAIT;


    end process testbench;
    
    u1: elevator PORT MAP(t_clk, t_rst, t_up, t_down, t_sw, t_flr, t_motor_up, t_motor_down, t_move_state);
    
end architecture test;
