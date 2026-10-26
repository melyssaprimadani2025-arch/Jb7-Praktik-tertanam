library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_traffic_light is
-- Testbench tidak memiliki port fisik
end tb_top_traffic_light;

architecture Behavioral of tb_top_traffic_light is
    -- Sinyal simulasi untuk dihubungkan ke Top Level
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal sw  : std_logic_vector(3 downto 0) := "0000";
    signal led : std_logic_vector(5 downto 0);

    -- Periode Clock 100 MHz (10 ns)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instansiasi Unit Under Test (UUT)
    uut: entity work.top_traffic_light
        port map (
            clk => clk,
            rst => rst,
            sw  => sw,
            led => led
        );

    -- Pembangkit Sinyal Clock 100 MHz
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus Sinyal Input
    stim_proc: process
    begin
        -- 1. Kondisi Reset Awal
        rst <= '1';
        sw  <= "0000"; -- Mode awal: Durasi Hijau 5 Detik (5 + 0)
        wait for 20 ns;
        
        rst <= '0';    -- Melepas Reset
        
        -- 2. Pengujian Siklus Pertama (sw = "0000" -> Hijau 5 Detik)
        -- Urutan LED yang diuji: 
        -- NS_HIJAU (5s) -> NS_KUNING (3s) -> ALL_RED_1 (1s) -> EW_HIJAU (5s) -> EW_KUNING (3s) -> ALL_RED_2 (1s)
        wait for 2500 ns;
        
        -- 3. Pengujian Ubah Switch (sw = "0101" / Nilai 5 -> Durasi Hijau 10 Detik)
        sw <= "0101";
        wait for 4000 ns;

        -- Hentikan Stimulus
        wait;
    end process;

end Behavioral;