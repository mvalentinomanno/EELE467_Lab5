library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ST2 is
	port(clock : in std_logic;
			reset : in std_logic;
			LED_S2 : out std_logic_vector(6 downto 0));

end entity;

architecture ST2_arch of ST2 is

		component binary_up_counter is  --State2 is just the output of an up counter
			port
				(clock	: in std_logic;
					reset : in std_logic;
					fin 	: out std_logic_vector(6 downto 0));
		end component;
		
		begin
		
			COUNTER : binary_up_counter port map(clock => clock,
												reset => reset,
												fin(6 downto 0) => LED_S2(6 downto 0));
												

end architecture; 