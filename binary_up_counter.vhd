library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity binary_up_counter is

	generic(
		MIN : natural := 0;
		MAX : natural := 127); --7 bit counter so 128 diff numbers
		
	port(
		clock : in std_logic;
		reset : in std_logic;
		fin : out std_logic_vector(6 downto 0));
	

end entity;

architecture binary_up_counter_arch of binary_up_counter is

		begin
		
			process(clock)
				variable count : integer range MIN to MAX;
				
				begin
				
					if(reset = '0') then
						count := 0;
					elsif(rising_edge(clock)) then
						count := count + 1;
					end if;
					
				fin <= std_logic_vector(to_unsigned(count, fin'length));	
				
				end process;

end architecture; 