library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity kasumi_tb is
end entity kasumi_tb;

architecture testbench of kasumi_tb is
    
    component kasumi is
        port (
            clk : IN  STD_LOGIC;
            nrst: IN  STD_LOGIC;
            pt  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
            kt  : IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
            ct  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
        );
    end component kasumi;

    SIGNAL t_clk    : STD_LOGIC := '0';
    SIGNAL t_nrst   : STD_LOGIC := '0';
    SIGNAL t_pt     : STD_LOGIC_VECTOR( 63 DOWNTO 0) := (others => '0');
    SIGNAL t_kt     : STD_LOGIC_VECTOR(127 DOWNTO 0) := (others => '0');
    SIGNAL t_ct     : STD_LOGIC_VECTOR( 63 DOWNTO 0);

begin
    
    t_clk <= NOT t_clk after 5 ns;

    test: process
    begin

        WAIT for 20 ns;

        t_nrst  <= '1';
        t_pt    <= x"123456789ABCDEF0";
        t_kt    <= x"9AF51BC73D45BA3A9B945B686055DF97";

        WAIT for 180 ns;
        WAIT;
    end process test;
    
    u1: kasumi port map(t_clk, t_nrst, t_pt, t_kt, t_ct);
    
end architecture testbench;