LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UART is
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
        done    : OUT STD_LOGIC := '0';

        p_tor   : OUT STD_LOGIC := '0'

    );
end entity UART;


architecture u1 of UART is
    
    type transmit_states is (t_idle, t_run, t_s0, t_s1, t_s2, t_s3, t_s4, t_s5, t_s6, t_s7, t_parity, t_wait, t_check);
    type receive_states is (r_idle, r_s0, r_s1, r_s2, r_s3, r_s4, r_s5, r_s6, r_s7, r_parity, r_check, r_final);

    SIGNAL t_current, t_next: transmit_states;
    SIGNAL r_current, r_next: receive_states;

    SIGNAL baud_counter: STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL tr_parity, re_parity: std_LOGIC := '0';
    SIGNAL t_tr_parity, t_re_parity: std_LOGIC := '0';

    SIGNAL tx: STD_LOGIC := '1';
    SIGNAL rx: STD_LOGIC := '1';
    SIGNAL tor: STD_LOGIC := '0';
    SIGNAL c_action, n_action: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

begin
    
    sequential: process(clk, rst)
    begin
        IF rst = '1' THEN
            t_current <= t_idle;
            r_current <= r_idle;
            baud_counter <= "00000001";
            c_action <= "00";
        ELSE
            if rising_edge(clk) then
                if baud_counter = baud then
                    t_current <= t_next;
                    r_current <= r_next;
                    c_action <= n_action;
                    tr_parity <= t_tr_parity;
                    re_parity <= t_re_parity;
                    baud_counter <= "00000001";
                ELSE
                    baud_counter <= baud_counter + 1;
                end if;
            end if;
        end if;
    end process sequential;

    combinational: process(start, din, t_current, rx, r_current, c_action, tr_parity, re_parity)
        Variable v_dout, tv_dout : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    begin
        -- c_action <= 'Z';
        -- tor <= '1';
        tx <= '1';
        done <= '0';

        If c_action = "00" then 
            v_dout := (others => '0');
            t_next <= t_idle;
            r_next <= r_idle;
            t_tr_parity <= '0';
            t_re_parity <= '0';
            IF start = '1' AND r_current = r_idle THEN
                n_action <= "10";
                tor <= '1';
                p_tor <= '1';
            ELSIF rx = '0' AND t_current = t_idle THEN
                n_action <= "01";
                tor <= '0';
                p_tor <= '0';
            ELSE
                n_action <= "00";
                tor <= '0';
                p_tor <= '0';
                
            END IF;
        ELSIF c_action = "10" THEN
            n_action <= "10";
            v_dout := (others => '0');
            r_next <= r_idle;
            t_re_parity <= '0';
            t_tr_parity <= tr_parity XOR '0';
            tor <= '1';
            p_tor <= '1';
        ELSE
            v_dout := tv_dout;
            n_action <= "01";
            tor <= '0';
            p_tor <= '0';
        END IF;
            
        IF c_action = "10" THEN

            v_dout := (others => '0');
            r_next <= r_idle;
            t_re_parity <= '0';
            t_tr_parity <= '0';

            case t_current is
                when t_idle =>
                    if start = '1' then
                        t_next <= t_run;
                    ELSE
                        t_next <= t_idle;
                        n_action <= "00";
                    end if;
                    tx <= '1';
                    tor <= '1';
                    p_tor <= '1';

            when t_run => 
                t_next <= t_s0;
                tx <= '0';
                t_tr_parity <= '0';
                tor <= '1';
                p_tor <= '1';

            when t_s0 =>
                t_next <= t_s1;
                tx <= din(0);
                t_tr_parity <= tr_parity XOR din(0);
                tor <= '1';
                p_tor <= '1';

            when t_s1 =>
                t_next <= t_s2;
                tx <= din(1);
                t_tr_parity <= tr_parity XOR din(1);
                tor <= '1';
                p_tor <= '1';

            when t_s2 => 
                t_next <= t_s3;
                tx <= din(2);
                t_tr_parity <= tr_parity XOR din(2);
                tor <= '1';
                p_tor <= '1';

            when t_s3 =>
                t_next <= t_s4;
                tx <= din(3);
                t_tr_parity <= tr_parity XOR din(3);
                tor <= '1';
                p_tor <= '1';

            when t_s4 =>
                t_next <= t_s5;
                tx <= din(4);
                t_tr_parity <= tr_parity XOR din(4);
                tor <= '1';
                p_tor <= '1';

            when t_s5 =>
                t_next <= t_s6;
                tx <= din(5);
                t_tr_parity <= tr_parity XOR din(5);
                tor <= '1';
                p_tor <= '1';

            when t_s6 =>
                t_next <= t_s7;
                tx <= din(6);
                t_tr_parity <= tr_parity XOR din(6);
                tor <= '1';
                p_tor <= '1';

            when t_s7 =>
                t_next <= t_parity;
                tx <= din(7);
                t_tr_parity <= tr_parity XOR din(7);
                tor <= '1';
                p_tor <= '1';
            
            when t_parity =>
                t_next <= t_wait;
                tx <= NOT tr_parity;
                tor <= '1';
                p_tor <= '1';

            when t_wait =>
                    t_next <= t_check;
                    tor <= '1';
                    p_tor <= '1';
            
            when others =>
                    tor <= '0';
                    p_tor <= '0';
                    IF rx = '1' then
                        t_next <= t_idle;
                        n_action <= "00";
                    ELSE
                        t_next <= t_run;
                        tor <= '1';
                        p_tor <= '1';
                    END IF;
            end case;

        ELSIF c_action = "01" then
           
            t_next <= t_idle;
            t_tr_parity <= '0';

            case r_current is
                when r_idle =>
                if rx = '1' then
                    r_next <= r_idle;
                    n_action <= "00";
                ELSE
                    r_next <= r_s0;
                end if;
                v_dout := (others => '0');
                t_re_parity <= '0';

            when r_s0 =>
                r_next <= r_s1;
                v_dout(0) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s1 =>
                r_next <= r_s2;
                v_dout(1) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s2 =>
                r_next <= r_s3;
                v_dout(2) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s3 =>
                r_next <= r_s4;
                v_dout(3) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s4 => 
                r_next <= r_s5;
                v_dout(4) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s5 =>
                r_next <= r_s6;
                v_dout(5) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s6 =>
                r_next <= r_s7;
                v_dout(6) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_s7 =>
                r_next <= r_final;
                v_dout(7) := rx;
                t_re_parity <= re_parity XOR rx;
                tor <= '0';
                p_tor <= '0';

            when r_parity =>
                r_next <= r_check;
                t_re_parity <= re_parity XOR rx;
                v_dout := v_dout;
                tor <= '0';
                p_tor <= '0';

            when r_check =>
                tor <= '1';
                p_tor <= '1';
                If re_parity = '1' then
                    r_next <= r_final;
                    tx <= '1';
                    v_dout := v_dout;
                ELSE
                    r_next <= r_s0;
                    tx <= '0';
                    v_dout := "00000000";
                END IF;
                t_re_parity <= '0';

            when others =>
                r_next <= r_idle;
                n_action <= "00";
                done <= '1';
                t_re_parity <= '0';
                tor <= '0';
                p_tor <= '0';
                v_dout := v_dout;
                    
            
            end case;
        ELSE
            t_next <= t_idle;
            r_next <= r_idle;
            t_tr_parity <= '0';
            t_re_parity <= '0';
        END IF;

        dout <= v_dout;
        tv_dout := v_dout + 1;
        tv_dout := tv_dout - 1;
    end process combinational;

    io <= tx WHEN tor = '1' ELSE 'Z';
	rx <= io;

end architecture u1;