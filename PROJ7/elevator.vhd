library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity elevator is
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
end entity elevator;

architecture rtl of elevator is
    
    TYPE STATE_TYPE IS (f0, f1, f2, f3);
    SIGNAL c_state, n_state: STATE_TYPE;
    SIGNAL c_move, n_move: STD_LOGIC_VECTOR(1 downto 0);

begin

    seq: process(clk, rst)
    begin
        if rst = '1' THEN
            c_state <= f0;
            c_move  <= "00";
        
        ELSIF rising_edge(clk) THEN
            c_state <= n_state;
            c_move  <= n_move;
        end if;
    end process seq;

    comb: process(c_state, c_move, up, down, sw)
    begin
        case c_state is

            when f0 =>

                flr <= "0001";
                motor_down <= '0';
                if c_move = "01" THEN
                    n_state <= f0;
                    n_move <= "00";
                    motor_up <= '0';
                    move_state <= '0';

                else
                    if up(0) = '1' OR down(0) = '1' OR sw(0) = '1' OR (up = "0000" AND down = "0000" AND sw = "0000") THEN
                        n_state <= f0;
                        n_move <= "00";
                        motor_up <= '0';
                        move_state <= '0';
                    else
                        n_state <= f1;
                        n_move <= "10";
                        motor_up <= '1';
                        move_state <= '1';

                    end if;
                end if;

            when f1 =>

                flr <= "0010";
                if c_move = "01" THEN
                    if down(1) = '1' OR sw(1) = '1' THEN
                        n_state <= f1;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF down(0) = '1' OR sw(0) = '1' OR (down = "0000" AND sw = "0000" AND up(0) = '1') THEN
                        n_state <= f0;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '1';
                        move_state <= '1';

                    else
                        n_state <= f1;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                end if;

                ELSIF c_move = "10" THEN
                    if up(1) = '1' OR sw(1) = '1' THEN
                        n_state <= f1;
                        n_move <= "10";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF up(2) = '1' OR up(3) = '1' OR sw(2) = '1' OR sw(3) = '1' 
                                OR (up = "0000" AND sw = "0000" AND (down(2) = '1' OR down(3) = '1')) THEN

                        n_state <= f2;
                        n_move <= "10";
                        motor_up <= '1';
                        motor_down <= '0';
                        move_state <= '1';

                    else
                        n_state <= f1;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    end if;
                else
                    if up(1) = '1' OR down(1) = '1' OR sw(1) = '1' OR (up = "0000" AND down = "0000" AND sw = "0000") THEN
                        n_state <= f1;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF down(0) = '1' OR up(0) = '1' OR sw(0) = '1' THEN
                        n_state <= f0;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '1';
                        move_state <= '1';

                    else
                        n_state <= f1;
                        n_move <= "10";
                        motor_up <= '1';
                        motor_down <= '0';
                        move_state <= '1';
                    end if;

                end if;

            when f2 =>

                flr <= "0100";
                if c_move = "01" THEN
                    if down(2) = '1' OR sw(2) = '1' THEN
                        n_state <= f2;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF down(1) = '1' OR sw(1) = '1' OR down(0) = '1' OR sw(0) = '1' 
                                OR (down = "0000" AND sw = "0000" AND (up(0) = '1' OR up(1) = '1')) THEN
                        n_state <= f1;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '1';
                        move_state <= '1';

                    else
                        n_state <= f2;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';
                    end if;
                ELSIF c_move = "10" THEN
                    if up(2) = '1' OR sw(2) = '1' THEN
                        n_state <= f2;
                        n_move <= "10";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF up(3) = '1' OR sw(3) = '1' OR (up = "0000" AND sw = "0000" AND down(3) = '1') THEN

                        n_state <= f3;
                        n_move <= "10";
                        motor_up <= '1';
                        motor_down <= '0';
                        move_state <= '1';

                    else
                        n_state <= f2;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    end if;

                else
                    if up(2) = '1' OR down(2) = '1' OR sw(2) = '1' OR (up = "0000" AND down = "0000" AND sw = "0000") THEN
                        n_state <= f2;
                        n_move <= "00";
                        motor_up <= '0';
                        motor_down <= '0';
                        move_state <= '0';

                    ELSIF down(0) = '1' OR up(0) = '1' OR sw(0) = '1' OR down(1) = '1' OR up(1) = '1' OR sw(1) = '1' THEN
                        n_state <= f1;
                        n_move <= "01";
                        motor_up <= '0';
                        motor_down <= '1';
                        move_state <= '1';

                    else
                        n_state <= f2;
                        n_move <= "10";
                        motor_up <= '1';
                        motor_down <= '0';
                        move_state <= '1';
                end if;
            end if;


            when others =>

                flr <= "1000";
                motor_up <= '0';
                IF c_move = "10" THEN
                    n_state <= f3;
                    n_move <= "00";
                    motor_up <= '0';
                    move_state <= '0';
                else
                    if down(3) = '1' OR sw(3) = '1' OR (up = "0000" AND down = "0000" AND sw = "0000") THEN
                        n_state <= f3;
                        n_move <= "00";
                        motor_up <= '0';
                        move_state <= '0';
                    else
                        n_state <= f2;
                        n_move <= "10";
                        motor_down <= '1';
                        move_state <= '1';

                    end if;
                end if;
        
        end case;
    end process comb;
    
    
end architecture rtl;