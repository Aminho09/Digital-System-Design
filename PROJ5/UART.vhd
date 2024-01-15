library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART is
    port (
        nreset:     in  std_logic;
        clk:        in  std_logic;
        
        -- transmitter ports
        start:      in  std_LOGIC;
        data_in:    in  std_logic_vector(7 downto 0);
        tx:         out std_LOGIC;

        -- reciever ports
        rx:         in  std_LOGIC;
        data_out:   out std_logic_vector(7 downto 0);
        strobe:     out std_LOGIC

    );
end entity UART;

architecture ua of UART is

    type transmit_states is (t_idle, t_run, t_s0, t_s1, t_s2, t_s3, t_s4, t_s5, t_s6, t_s7);
    type receive_states is (r_idle, r_s0, r_s1, r_s2, r_s3, r_s4, r_s5, r_s6, r_s7, r_final);

    SIGNAL t_current, t_next: transmit_states;
    SIGNAL r_current, r_next: receive_states;

begin
    
    transmit_sequential: process(clk, nreset)
    begin
        IF nreset = '0' THEN
            t_current <= t_idle;
        ELSE
            if rising_edge(clk) then
                t_current <= t_next;
            end if;
        end if;
    
    end process transmit_sequential;

    receive_sequential: process(clk, nreset)
    begin
        IF nreset = '0' THEN
            r_current <= r_idle;
        ELSE
            if rising_edge(clk) then
                r_current <= r_next;
            end if;
        end if;
    end process receive_sequential;
    
    transmit_combinational: process(start, data_in,t_current)
    begin

        case t_current is

            when t_idle =>
                if start = '1' then
                    t_next <= t_run;
                ELSE
                    t_next <= t_idle;
                end if;
                tx <= '1';

            when t_run => 
                t_next <= t_s0;
                tx <= '0';

            when t_s0 =>
                t_next <= t_s1;
                tx <= data_in(0);

            when t_s1 =>
                t_next <= t_s2;
                tx <= data_in(1);

            when t_s2 => 
                t_next <= t_s3;
                tx <= data_in(2);

            when t_s3 =>
                t_next <= t_s4;
                tx <= data_in(3);

            when t_s4 =>
                t_next <= t_s5;
                tx <= data_in(4);

            when t_s5 =>
                t_next <= t_s6;
                tx <= data_in(5);

            when t_s6 =>
                t_next <= t_s7;
                tx <= data_in(6);

            when others =>
                t_next <= t_idle;
                tx <= data_in(7);

                
        
        end case;
    end process transmit_combinational;

    receive_combinatoinal: process(rx, r_current)
    begin

        strobe <= '0';

        case r_current is

            when r_idle =>
                if rx = '1' then
                    r_next <= r_idle;
                ELSE
                    r_next <= r_s0;
                end if;

            when r_s0 =>
                r_next <= r_s1;
                data_out(0) <= rx;

            when r_s1 =>
                r_next <= r_s2;
                data_out(1) <= rx;

            when r_s2 =>
                r_next <= r_s3;
                data_out(2) <= rx;

            when r_s3 =>
                r_next <= r_s4;
                data_out(3) <= rx;

            when r_s4 => 
                r_next <= r_s5;
                data_out(4) <= rx;

            when r_s5 =>
                r_next <= r_s6;
                data_out(5) <= rx;

            when r_s6 =>
                r_next <= r_s7;
                data_out(6) <= rx;

            when r_s7 =>
                r_next <= r_final;
                data_out(7) <= rx;

            when others =>
                if rx = '0' then
                    r_next <= r_final;
                ELSE
                    r_next <= r_idle;
                end if;
                strobe <= '1';
                
        end case;
    end process receive_combinatoinal;
    
end architecture ua;
