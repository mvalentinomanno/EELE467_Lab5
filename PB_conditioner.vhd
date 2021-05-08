--The conditioner used for HW2 was behaving strangely when placed in this project,
--I confirmed functionallity in modelsim, but couldnt get it to work here for some reason
--I troubleshot it for so long, that I decided to write a whole new conditioner (that is more simple)
--I hope this is okay
library IEEE;
use IEEE.std_logic_1164.all;

entity PB_conditioner is

generic(counter : integer := 5000000); --generic used to delay 100ms (debounce)

	port (clock : in std_logic;
			INP : in std_logic;
			OUP : out std_logic);
end entity;



architecture PB_conditioner_arch of PB_conditioner is

	signal syn : std_logic;
	signal P1 : std_logic;
	signal D1 : std_logic;
	signal F1 : std_logic;
	signal count : integer range 0 to 5000000 := 0;
	
	begin
	
	SYNC : process(clock) --sync same as 2 signal assignments
		begin
			if(rising_edge(clock)) then
			
				syn <= F1;
				OUP <= syn;
				
			end if;
		end process;
		
	DEB : process(clock) --debounces the signal for 100ms
		begin
			if(rising_edge(clock)) then
				count <= count + 1;
				P1 <= D1;
				if(count = counter) then
					count <= 0;
					if(rising_edge(clock) and INP = '0') then	
						D1 <= INP;
				end if;
			end if;
		end if;
	end process;
	
	ONEP : process(clock) --checks push button and result of debouncer to determine if we get a pulse
		begin
			if(P1 = '0' and D1 = '0') then
				F1 <= '1';
			elsif(D1 = '0' and P1 = '1') then
				F1 <= '0';
			end if;
		end process;
end architecture;
		
				