library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity LED_patterns is
    port(
        clk             : in  std_logic;                         -- system clock
        reset           : in  std_logic;                         -- system reset (assume active high, change at top level if needed)
        PB              : in  std_logic;                         -- Pushbutton to change state (assume active high, change at top level if needed)
        SW              : in  std_logic_vector(3 downto 0);      -- Switches that determine the next state to be selected
        HPS_LED_control : in  std_logic;                         -- Software is in control when asserted (=1)
        SYS_CLKs_sec    : in  std_logic_vector(31 downto 0);     -- Number of system clock cycles in one second
        Base_rate       : in  std_logic_vector(7 downto 0);      -- base transition period in seconds, fixed-point data type (W=8, F=4).
        LED_reg         : in  std_logic_vector(7 downto 0);      -- LED register
        LED             : out std_logic_vector(7 downto 0)       -- LEDs on the DE10-Nano board
    );
end entity LED_patterns;

architecture LED_patterns_arch of LED_patterns is

	type State_Type is (S0,S1,S2,S3,S4,show_state); --state type declarations
	signal current_state,next_state : State_Type;
	
	signal LEDS0, LEDS1, LEDS2, LEDS3, LEDS4 : std_logic_vector(6 downto 0); --signals used in file
	signal push : std_logic;
	
	signal LED_disp : std_logic;
	
	signal clockdiv1 : std_logic;
	signal clockdiv2 : std_logic;
	signal clockdiv4 : std_logic;
	signal clockdiv8 : std_logic;
	signal clock2 : std_logic;
	signal Base2 : std_logic_vector(7 downto 0); 
	signal Base14 : std_logic_vector(7 downto 0); 
	signal Base18 : std_logic_Vector(7 downto 0); 
	signal base12 : std_logic_Vector(7 downto 0); 
	
	component clock_gen is                     --Component sections
		port(clk	: in std_logic;
				SYS_CLKs_sec : in std_logic_vector(31 downto 0);
				Base_rate	: in std_logic_vector(7 downto 0);
				clock_o : out std_logic);
	end component;
	
	component PB_conditioner is
		port(clock  :  in std_logic;	
		INP : in std_logic;
		OUP : out std_logic);
	end component;
	
	component LED_7 is
		port(clock : in std_logic;
				LED : out std_logic);
	end component;
	
	component ST0 is
		port(clock : in std_logic;
				reset	: in std_logic;
				LED_S0 : out std_logic_vector(6 downto 0));
	end component;
	
		component ST1 is
		port(clock : in std_logic;
				reset	: in std_logic;
				LED_S1 : out std_logic_vector(6 downto 0));
	end component;
	
		component ST2 is
		port(clock : in std_logic;
				reset	: in std_logic;
				LED_S2 : out std_logic_vector(6 downto 0));
	end component;
	
		component ST3 is
		port(clock : in std_logic;
				reset	: in std_logic;
				LED_S3 : out std_logic_vector(6 downto 0));
	end component;
	
		component ST4 is
		port(clock : in std_logic;
				reset	: in std_logic;
				LED_S4 : out std_logic_vector(6 downto 0));
	end component;
	

begin

	LED7_BLINK : LED_7 port map(clock => clockdiv1,
							LED => LED(7));
							
	Base2 <= "0" & Base_rate(7 downto 1);   --dividing by 2 is the same as a shift  right
	Base12 <= Base_rate(6 downto 0) & "0";  --multiplying by 2 is the same as a shift left
	Base14 <= Base_rate(5 downto 0) & "00";
	Base18 <= Base_rate(4 downto 0) & "000";
	
	CLK_G_12 : clock_gen port map(clk => clk, --create clocks for baserate, baserate *2, baserate*1/2, baserate*1/4,baserate*1/8
					SYS_CLKs_sec => SYS_CLKs_sec,
					Base_rate => Base12,
					clock_o => clockdiv2);
	
	CLK_G_1 : clock_gen port map(clk => clk,
					SYS_CLKs_sec => SYS_CLKs_sec,
					Base_rate => Base_rate,
					clock_o => clockdiv1);
					
	CLK_G_2 : clock_gen port map(clk => clk,
					SYS_CLKs_sec => SYS_CLKs_sec,
					Base_rate => Base2,
					clock_o => clock2);

	CLK_G_14 : clock_gen port map(clk => clk,
					SYS_CLKs_sec => SYS_CLKs_sec,
					Base_rate => Base14,
					clock_o => clockdiv4);

	CLK_G_18 : clock_gen port map(clk => clk,
					SYS_CLKs_sec => SYS_CLKs_sec,
					Base_rate => Base18,
					clock_o => clockdiv8);
								--create states
	state0 : ST0 port map(clock => clockdiv2,  --state one is baserate*1/2
							Reset => reset,
							LED_S0 => LEDS0);
						
	state1 : ST1 port map(clock => clockdiv4,	--state two is baserate*1/4
							Reset => reset,
							LED_S1 => LEDS1);
							
	state2 : ST2 port map(clock => clock2, --state 2 is baserate*2
							Reset => reset,
							LED_S2 => LEDS2);
							
	state3 : ST3 port map(clock => clockdiv8, --state 3 is baserate*1/8
							Reset => reset,
							LED_S3 => LEDS3);

	state4 : ST4 port map(clock => clockdiv1, --state 4 i decided is baserate
							Reset => reset,
							LED_S4 => LEDS4);
							
	PUSHB : PB_conditioner port map (clock => clk, --conditions the input (HW2 conditioner was giving a small but strange error that couldnt be solved, so a new simple conditioner was created)
											INP => PB, 
											OUP => push);
											
	LED_D : process(clk,push) --sets flag if we display what the switches are set as
		variable counter : integer := 0;
		begin
			if(push = '0') then
			
				LED_disp <= '1';
				counter := 0;
				
			elsif(rising_edge(clk)) then
			
				if(counter = 50000000) then --counter to 50000000 is equal to 1s
				
					counter := 0;
					LED_disp <= '0';
					
				else
				
					counter := counter + 1;
					
				end if;
			end if;
		end process;

		
	STATE_MEMORY : process(clk,reset) --state machine for the LED patterns
		begin
			if(reset = '0') then
				
				current_state <= current_state;
				
			elsif(rising_edge(clk)) then
			
				current_state <= next_state;
				
			end if;
		end process;

	STATE_LOGIC : process(current_state,push,SW)
		begin
			
			if(push = '0') then
				case(SW) is
				
					when "0000" => next_state <= S0;
					when "0001" => next_state <= S1;
					when "0010" => next_state <= S2;
					when "0011" => next_state <= S3;
					when "0100" => next_state <= S4;
					when others => next_state <= current_state;
				end case;
			end if;
	end process;
	
	OUTPUT_LOGIC : process (current_state)
	
		begin
			if(HPS_LED_control = '1') then --software mode 
			
				LED(6 downto 0) <= LED_reg(6 downto 0);
				
			elsif(LED_disp = '0') then --hardware mode (switches control)
				
				case(current_state) is
					when S0 => LED(6 downto 0) <= LEDS0;
					when S1 => LED(6 downto 0) <= LEDS1;
					when S2 => LED(6 downto 0) <= LEDS2;
					when S3 => LED(6 downto 0) <= LEDS3;
					when S4 => LED(6 downto 0) <= LEDS4;
					when others => LED(6 downto 0) <= LEDS0;
				end case;
			else --display switches
				LED(6 downto 0) <= "000" & SW;
			end if;
		end process;
	
		
end architecture; 