library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Diperlukan untuk fungsi to_integer & unsigned

entity traffic_light_fsm is
    Port (
        clk  : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        tick : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR(3 downto 0); -- Input Switch SW3..SW0
        led  : out STD_LOGIC_VECTOR(5 downto 0)  -- Output LED
    );
end traffic_light_fsm;

architecture Behavioral of traffic_light_fsm is
    -- Status FSM
    type state_type is (NS_HIJAU, NS_KUNING, ALL_RED_1, EW_HIJAU, EW_KUNING, ALL_RED_2);
    signal current_state : state_type := NS_HIJAU;
    
    -- Register timer internal (0 s/d 31 detik)
    signal timer : integer range 0 to 31 := 5;
    
    -- Konstanta waktu fase kuning dan all-red
    constant TIME_YELLOW  : integer := 3; -- 3 detik
    constant TIME_ALL_RED : integer := 1; -- 1 detik

    -- Sinyal penampung hasil kalkulasi durasi hijau dari switch (5 s/d 20 detik)
    signal green_time : integer range 5 to 20;

begin

    -- Perhitungan dinamis durasi hijau berdasarkan posisi switch (5 + 0 s/d 15 = 5 s/d 20)
    green_time <= 5 + to_integer(unsigned(sw));

    -- Proses Sinkron Pengatur Timer dan Transisi Status (Berjalan setiap tick = '1')
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= NS_HIJAU;
                timer         <= green_time;
            elsif tick = '1' then
                if timer <= 1 then
                    -- Transisi status dan muat nilai timer baru
                    case current_state is
                        when NS_HIJAU =>
                            current_state <= NS_KUNING;
                            timer         <= TIME_YELLOW;

                        when NS_KUNING =>
                            current_state <= ALL_RED_1;
                            timer         <= TIME_ALL_RED;

                        when ALL_RED_1 =>
                            current_state <= EW_HIJAU;
                            timer         <= green_time; -- Mengambil nilai switch saat ini

                        when EW_HIJAU =>
                            current_state <= EW_KUNING;
                            timer         <= TIME_YELLOW;

                        when EW_KUNING =>
                            current_state <= ALL_RED_2;
                            timer         <= TIME_ALL_RED;

                        when ALL_RED_2 =>
                            current_state <= NS_HIJAU;
                            timer         <= green_time; -- Mengambil nilai switch saat ini
                    end case;
                else
                    timer <= timer - 1;
                end if;
            end if;
        end if;
    end process;

    -- Dekode Output LED
    -- led(2 downto 0) = Utara-Selatan (bit 0=Hijau, bit 1=Kuning, bit 2=Merah)
    -- led(5 downto 3) = Timur-Barat   (bit 3=Hijau, bit 4=Kuning, bit 5=Merah)
    process(current_state)
    begin
        case current_state is
            when NS_HIJAU  => led <= "100001"; -- EW Merah, NS Hijau
            when NS_KUNING => led <= "100010"; -- EW Merah, NS Kuning
            when ALL_RED_1 => led <= "100100"; -- EW Merah, NS Merah (All-Red)
            when EW_HIJAU  => led <= "001100"; -- EW Hijau, NS Merah
            when EW_KUNING => led <= "010100"; -- EW Kuning, NS Merah
            when ALL_RED_2 => led <= "100100"; -- EW Merah, NS Merah (All-Red)
        end case;
    end process;

end Behavioral;