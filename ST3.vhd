library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ST3 is
	port(clock : in std_logic;
			reset : in std_logic;
			LED_S3 : out std_logic_vector(6 downto 0));

end entity;

architecture ST3_arch of ST3 is

		component binary_down_counter is --State 3 is output of down counter
			port
				(clock	: in std_logic;
					reset : in std_logic;
					fin 	: out std_logic_vector(6 downto 0));
		end component;
		
		begin
		
			COUNTER : binary_down_counter port map(clock => clock,
												reset => reset,
												fin(6 downto 0) => LED_S3(6 downto 0));

end architecture; 