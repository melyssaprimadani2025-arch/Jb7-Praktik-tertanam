library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_traffic_light is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        sw  : in  STD_LOGIC_VECTOR(3 downto 0); -- Port Input Switch ke FSM
        led : out STD_LOGIC_VECTOR(5 downto 0)
    );
end top_traffic_light;

architecture Behavioral of top_traffic_light is
    signal tick_sig : STD_LOGIC;
begin

    -- Instansiasi Clock Divider (100 MHz -> 1 Hz)
    u_tick: entity work.tick_1hz
        generic map (
            CLK_FREQ_HZ => 100_000_000
        )
        port map (
            clk  => clk,
            rst  => rst,
            tick => tick_sig
        );

    -- Instansiasi FSM Pengendali Lampu
    u_fsm: entity work.traffic_light_fsm
        port map (
            clk  => clk,
            rst  => rst,
            tick => tick_sig,
            sw   => sw,
            led  => led
        );

end Behavioral;