library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ST0 is
	port(clock : in std_logic;
			reset : in std_logic;
			LED_S0 : out std_logic_vector(6 downto 0));

end entity;

architecture ST0_arch of ST0 is
 
	signal LEDS: std_logic_vector(6 downto 0) := "0001000"; --as default,led(3) is on

begin

	--ST0 shifts the LEDs right
	RIGHTSFT: process(clock, reset)
	
		begin
		
			if(reset = '0') then
			
					LEDS <= "0001000";
					
			elsif(rising_edge(clock)) then
			 
					LEDS(2) <= LEDS(3);
					LEDS(1) <= LEDS(2);
					LEDS(0) <= LEDS(1);
					LEDS(3) <= LEDS(4);
					LEDS(4) <= LEDS(5);
					LEDS(5) <= LEDS(6);
					LEDS(6) <= LEDS(0);
					
			end if;
			
		end process;
		
		LED_S0 <= LEDS;

end architecture; 