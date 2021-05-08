library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ST4 is
	port(clock : in std_logic;
			reset : in std_logic;
			LED_S4 : out std_logic_vector(6 downto 0));

end entity;

architecture ST4_arch of ST4 is
		
	signal LEDS : std_logic_vector(6 downto 0) := "0001000"; --LED(3) is initially on
		
	begin	

	EXPCONT : process(clock, reset)
	
		begin
		
			if(reset = '0') then
			
					LEDS <= "0001000"; --Initially LEDS(3) is on
					
			elsif(rising_edge(clock)) then
			 
					LEDS(4) <= LEDS(3);
					LEDS(2) <= LEDS(3); --leds seperate and move outside, then reset back to center
					LEDS(5) <= LEDS(4);
					LEDS(1) <= LEDS(2);
					LEDS(6) <= LEDS(5);
					LEDS(0) <= LEDS(1);
					LEDS(3) <= LEDS(0);
					
			end if;
			
		end process;
		
		LED_S4 <= LEDS;

end architecture; 