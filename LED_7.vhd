library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED_7 is
	port(clock : in std_logic;
			LED : out std_logic);
end entity;

architecture LED_7_arch of LED_7 is

	signal onoff : std_logic := '0';
	
	begin
	
	process(clock)
		begin
		
			if(rising_edge(clock)) then
			
					onoff <= not onoff;  --every clock we toggle LED(7)
					
			end if;
			
		end process;
		
		LED <= onoff;
		
end architecture;