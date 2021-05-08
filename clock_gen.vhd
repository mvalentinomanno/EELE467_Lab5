library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_gen is
	port(clk : in std_logic;
		SYS_CLKs_sec : in std_logic_vector(31 downto 0);
		Base_rate : std_logic_vector(7 downto 0);
		clock_o : out std_logic);
		
end entity clock_gen;

architecture clock_gen_arch of clock_gen is

	signal count : integer := 0;
	signal conversion : unsigned(34 downto 0);
	signal clock_pre : unsigned(39 downto 0);
	signal clock : std_logic;


begin 

	clock_pre <= unsigned(SYS_CLKs_sec)*unsigned(Base_rate); --mult base rate by clocks in a second
	conversion <= clock_pre(39 downto 5); --convert
	
	GEN : process(clk) --checks if counter is same as conversion , letting us know we're done
		begin
			if(rising_edge(clk)) then
				if(count = conversion) then
					clock_o <= clock;
					clock <= not clock;
					count<= 0;
				else
					count <= count + 1;
				end if;
			end if;
		end process;

end architecture;
