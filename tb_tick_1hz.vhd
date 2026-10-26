library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_tick_1hz is
-- Testbench tidak memiliki port
end tb_tick_1hz;

architecture Behavioral of tb_tick_1hz is
    signal clk  : std_logic := '0';
    signal rst  : std_logic := '0';
    signal tick : std_logic;

    constant CLK_PERIOD : time := 10 ns;
begin

    -- Instansiasi UUT dengan CLK_FREQ_HZ = 10 untuk simulasi cepat
    uut: entity work.tick_1hz
        generic map (
            CLK_FREQ_HZ => 10
        )
        port map (
            clk  => clk,
            rst  => rst,
            tick => tick
        );

    -- Pembangkit Clock (100 MHz)
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        rst <= '1';
        wait for 20 ns;
        
        rst <= '0';
        wait for 500 ns;
        
        wait;
    end process;

end Behavioral;