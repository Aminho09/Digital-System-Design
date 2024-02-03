library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.my_package.all;

entity kasumi is
    port (
        clk : IN  STD_LOGIC;
        nrst: IN  STD_LOGIC;
        pt  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
        kt  : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
        ct  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
end entity kasumi;

architecture rtl of kasumi is

    type state is (initial, F11, F12, F21, F22, F31, F32, F41, F42, F51, F52, F61, F62, F71, F72, F81, F82, DONE);
    SIGNAL cur_state, nxt_state: state;
    SIGNAL cur_lout, cur_rout, cur_midout, nxt_rout, nxt_lout, nxt_midout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cur_kl1, cur_kl2, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3, nxt_ki1, nxt_ki2, nxt_ki3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    constant c1: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0123";
    constant c2: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"4567";
    constant c3: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"89AB";
    constant c4: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"CDEF";
    constant c5: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FEDC";
    constant c6: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"BA98";
    constant c7: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"7654";
    constant c8: STD_LOGIC_VECTOR(15 DOWNTO 0) := X"3210";



begin
    
    seq: process(clk, nrst) 
    begin
        if nrst = '0' then
            cur_state   <= initial;
            cur_lout    <= (others => '0');
            cur_rout    <= (others => '0');
            cur_midout  <= (others => '0');
            cur_kl1     <= (others => '0');
            cur_kl2     <= (others => '0');
            cur_ko1     <= (others => '0');
            cur_ko2     <= (others => '0');
            cur_ko3     <= (others => '0');
            cur_ki1     <= (others => '0');
            cur_ki2     <= (others => '0');
            cur_ki3     <= (others => '0');
        elsif rising_edge(clk) then
            cur_state   <= nxt_state;
            cur_lout    <= nxt_lout;
            cur_rout    <= nxt_rout;
            cur_midout  <= nxt_midout;
            cur_kl1     <= nxt_kl1;
            cur_kl2     <= nxt_kl2;
            cur_ko1     <= nxt_ko1;
            cur_ko2     <= nxt_ko2;
            cur_ko3     <= nxt_ko3;
            cur_ki1     <= nxt_ki1;
            cur_ki2     <= nxt_ki2;
            cur_ki3     <= nxt_ki3;
        end if;
    end process seq;

    comb: process(cur_state, cur_lout, cur_rout, cur_midout, pt, kt, cur_kl1, cur_kl2, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3)
    begin

        ct <= (others => '0');

        case cur_state is

            when initial =>
                nxt_state   <= F11;
                KEY(kt(127 DOWNTO 112), kt(95 DOWNTO 80), kt(111 DOWNTO 96), kt(47 DOWNTO 32), kt(31 DOWNTO 16), kt(63 DOWNTO 48),
                    kt(79 DOWNTO 64), kt(15 DOWNTO 0), c3, c5, c4, c8, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_lout    <= pt(63 DOWNTO 32);
                nxt_rout    <= pt(31 DOWNTO  0);
                nxt_midout  <= (others => '0');
            
            when F11 =>
                nxt_state   <= F12;
                KEY(kt(127 DOWNTO 112), kt(95 DOWNTO 80), kt(111 DOWNTO 96), kt(47 DOWNTO 32), kt(31 DOWNTO 16), kt(63 DOWNTO 48),
                    kt(79 DOWNTO 64), kt(15 DOWNTO 0), c3, c5, c4, c8, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FL(cur_lout, cur_kl1, cur_kl2);
                nxt_lout    <= cur_lout;


            when F12 =>
                nxt_state   <= F21;
                KEY(kt(111 DOWNTO 96), kt(79 DOWNTO 64), kt(95 DOWNTO 80), kt(31 DOWNTO 16), kt(15 DOWNTO 0), kt(47 DOWNTO 32),
                    kt(63 DOWNTO 48), kt(127 DOWNTO 112), c4, c6, c5, c1, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FO(cur_midout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F21 =>
                nxt_state   <= F22;
                KEY(kt(111 DOWNTO 96), kt(79 DOWNTO 64), kt(95 DOWNTO 80), kt(31 DOWNTO 16), kt(15 DOWNTO 0), kt(47 DOWNTO 32),
                    kt(63 DOWNTO 48), kt(127 DOWNTO 112), c4, c6, c5, c1, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FO(cur_lout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3);
                nxt_lout    <= cur_lout;

            when F22 =>
                nxt_state   <= F31;
                KEY(kt(95 DOWNTO 80), kt(63 DOWNTO 48), kt(79 DOWNTO 64), kt(15 DOWNTO 0), kt(127 DOWNTO 112), kt(31 DOWNTO 16),
                    kt(47 DOWNTO 32), kt(111 DOWNTO 96), c5, c7, c6, c2, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FL(cur_midout, cur_kl1, cur_kl2) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F31 =>
                nxt_state   <= F32;
                KEY(kt(95 DOWNTO 80), kt(63 DOWNTO 48), kt(79 DOWNTO 64), kt(15 DOWNTO 0), kt(127 DOWNTO 112), kt(31 DOWNTO 16),
                    kt(47 DOWNTO 32), kt(111 DOWNTO 96), c5, c7, c6, c2, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FL(cur_lout, cur_kl1, cur_kl2);
                nxt_lout    <= cur_lout;

            when F32 =>
                nxt_state   <= F41;
                KEY(kt(79 DOWNTO 64), kt(47 DOWNTO 32), kt(63 DOWNTO 48), kt(127 DOWNTO 112), kt(111 DOWNTO 96), kt(15 DOWNTO 0),
                    kt(31 DOWNTO 16), kt(95 DOWNTO 80), c6, c8, c7, c3, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FO(cur_midout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F41 =>
                nxt_state   <= F42;
                KEY(kt(79 DOWNTO 64), kt(47 DOWNTO 32), kt(63 DOWNTO 48), kt(127 DOWNTO 112), kt(111 DOWNTO 96), kt(15 DOWNTO 0),
                    kt(31 DOWNTO 16), kt(95 DOWNTO 80), c6, c8, c7, c3, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FO(cur_lout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3);
                nxt_lout    <= cur_lout;

            when F42 =>
                nxt_state   <= F51;
                KEY(kt(63 DOWNTO 48), kt(31 DOWNTO 16), kt(47 DOWNTO 32), kt(111 DOWNTO 96), kt(95 DOWNTO 80), kt(127 DOWNTO 112),
                    kt(15 DOWNTO 0), kt(79 DOWNTO 64), c7, c1, c8, c4, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FL(cur_midout, cur_kl1, cur_kl2) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F51 =>
                nxt_state   <= F52;
                KEY(kt(63 DOWNTO 48), kt(31 DOWNTO 16), kt(47 DOWNTO 32), kt(111 DOWNTO 96), kt(95 DOWNTO 80), kt(127 DOWNTO 112),
                    kt(15 DOWNTO 0), kt(79 DOWNTO 64), c7, c1, c8, c4, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FL(cur_lout, cur_kl1, cur_kl2);
                nxt_lout    <= cur_lout;

            when F52 =>
                nxt_state   <= F61;
                KEY(kt(47 DOWNTO 32), kt(15 DOWNTO 0), kt(31 DOWNTO 16), kt(95 DOWNTO 80), kt(79 DOWNTO 64), kt(111 DOWNTO 96),
                    kt(127 DOWNTO 112), kt(63 DOWNTO 48), c8, c2, c1, c5, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FO(cur_midout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3) XOR cur_rout;
                nxt_midout  <= cur_midout;
                
            when F61 =>
                nxt_state   <= F62;
                KEY(kt(47 DOWNTO 32), kt(15 DOWNTO 0), kt(31 DOWNTO 16), kt(95 DOWNTO 80), kt(79 DOWNTO 64), kt(111 DOWNTO 96),
                    kt(127 DOWNTO 112), kt(63 DOWNTO 48), c8, c2, c1, c5, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FO(cur_lout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3);
                nxt_lout    <= cur_lout;

            when F62 =>
                nxt_state   <= F71;
                KEY(kt(31 DOWNTO 16), kt(127 DOWNTO 112), kt(15 DOWNTO 0), kt(79 DOWNTO 64), kt(63 DOWNTO 48), kt(95 DOWNTO 80),
                    kt(111 DOWNTO 96), kt(47 DOWNTO 32), c1, c3, c2, c6, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FL(cur_midout, cur_kl1, cur_kl2) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F71 =>
                nxt_state   <= F72;
                KEY(kt(31 DOWNTO 16), kt(127 DOWNTO 112), kt(15 DOWNTO 0), kt(79 DOWNTO 64), kt(63 DOWNTO 48), kt(95 DOWNTO 80),
                    kt(111 DOWNTO 96), kt(47 DOWNTO 32), c1, c3, c2, c6, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FL(cur_lout, cur_kl1, cur_kl2);
                nxt_lout    <= cur_lout;

            when F72 =>
                nxt_state   <= F81;
                KEY(kt(15 DOWNTO 0), kt(111 DOWNTO 96), kt(127 DOWNTO 112), kt(63 DOWNTO 48), kt(47 DOWNTO 32), kt(79 DOWNTO 64),
                    kt(95 DOWNTO 80), kt(31 DOWNTO 16), c2, c4, c3, c7, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_lout;
                nxt_lout    <= FO(cur_midout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when F81 =>
                nxt_state   <= F82;
                KEY(kt(15 DOWNTO 0), kt(111 DOWNTO 96), kt(127 DOWNTO 112), kt(63 DOWNTO 48), kt(47 DOWNTO 32), kt(79 DOWNTO 64),
                    kt(95 DOWNTO 80), kt(31 DOWNTO 16), c2, c4, c3, c7, nxt_kl1, nxt_kl2, nxt_ko1, nxt_ko2, nxt_ko3,
                    nxt_ki1, nxt_ki2, nxt_ki3);
                nxt_rout    <= cur_rout;
                nxt_midout  <= FO(cur_lout, cur_ko1, cur_ko2, cur_ko3, cur_ki1, cur_ki2, cur_ki3);
                nxt_lout    <= cur_lout;

            when F82 =>
                nxt_state   <= DONE;
                nxt_kl1     <= (others => '0');
                nxt_kl2     <= (others => '0');
                nxt_ko1     <= (others => '0');
                nxt_ko2     <= (others => '0');
                nxt_ko3     <= (others => '0');
                nxt_ki1     <= (others => '0');
                nxt_ki2     <= (others => '0');
                nxt_ki3     <= (others => '0');
                nxt_rout    <= cur_lout;
                nxt_lout    <= FL(cur_midout, cur_kl1, cur_kl2) XOR cur_rout;
                nxt_midout  <= cur_midout;

            when others =>
                nxt_state   <= initial;
                nxt_lout    <= (others => '0');
                nxt_rout    <= (others => '0');
                nxt_midout  <= (others => '0');
                nxt_kl1     <= (others => '0');
                nxt_kl2     <= (others => '0');
                nxt_ko1     <= (others => '0');
                nxt_ko2     <= (others => '0');
                nxt_ko3     <= (others => '0');
                nxt_ki1     <= (others => '0');
                nxt_ki2     <= (others => '0');
                nxt_ki3     <= (others => '0');
                ct          <= cur_lout & cur_rout;
                
        end case;
        
    end process comb;
    
end architecture rtl;