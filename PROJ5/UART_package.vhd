library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package UART_package is
    
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

    PROCEDURE read_file(
        SIGNAL hpr:     in TIME;
        SIGNAL nrst:    out std_LOGIC;
        SIGNAL clk:     out std_LOGIC;
        SIGNAL start:   out std_LOGIC;
        SIGNAL rx:      out std_logic;
        SIGNAL data_in: out std_logic_vector(7 downto 0)
    );
    
end package UART_package;

package body UART_package is
    
    PROCEDURE read_file(
        SIGNAL hpr:     in TIME;
        SIGNAL nrst:    out std_LOGIC;
        SIGNAL clk:     out std_LOGIC;
        SIGNAL start:   out std_LOGIC;
        SIGNAL rx:      out std_logic;
        SIGNAL data_in: out std_logic_vector(7 downto 0)) IS

        TYPE myfile IS FILE OF character;
        FILE fp : myfile;
        VARIABLE c : character;
        VARIABLE current_time : TIME := 0 ns;
        VARIABLE line_number : integer := 1;

        BEGIN    
        FILE_OPEN(fp, "input.txt", READ_MODE);

        -- ignore line 1
        FOR i IN 0 TO 12 LOOP
            READ(fp, c);
        END LOOP;

        -- ignore line 2
        FOR i IN 0 TO 12 LOOP
            READ(fp, c);
        END LOOP;

        WHILE (NOT ENDFILE(fp)) LOOP

            -- Read nrst
            READ(fp, c);
            IF c = '0' THEN
                nrst <= TRANSPORT '0' AFTER current_time;
            ELSE
                nrst <= TRANSPORT '1' AFTER current_time;
            END IF;

            READ(fp, c);

            -- Read clk
            READ(fp, c);
            IF c = '0' THEN
                clk <= TRANSPORT '0' AFTER current_time;
            ELSE
                clk <= TRANSPORT '1' AFTER current_time;
            END IF;

            READ(fp, c);

            -- Read start
            READ(fp, c);
            IF c = '0' THEN
                start <= TRANSPORT '0' AFTER current_time;
            ELSE
                start <= TRANSPORT '1' AFTER current_time;
            END IF;

            READ(fp, c);

            -- Read rx
            READ(fp, c);
            IF c = '0' THEN
                rx <= TRANSPORT '0' AFTER current_time;
            ELSE
                rx <= TRANSPORT '1' AFTER current_time;
            END IF;

            READ(fp, c);

            -- Read data_in
            READ(fp, c);
            if c = '0' then
                data_in(7) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(7) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(6) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(6) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(5) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(5) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(4) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(4) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(3) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(3) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(2) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(2) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(1) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(1) <= TRANSPORT '1' AFTER current_time;
            end if;

            READ(fp, c);
            if c = '0' then
                data_in(0) <= TRANSPORT '0' AFTER current_time;
            ELSE
                data_in(0) <= TRANSPORT '1' AFTER current_time;
            end if;

            -- Read carriage return
            READ(fp, c);            
            -- Read line feed
            READ(fp, c);
            current_time := current_time + hpr;
            line_number := line_number + 1;

        END LOOP;
        FILE_CLOSE(fp);
    end PROCEDURE read_file;
    
end package body UART_package;
