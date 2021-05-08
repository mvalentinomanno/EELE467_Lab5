--! @file
--! 
--! @author Ross Snider
--! 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

LIBRARY altera;
USE altera.altera_primitives_components.all;


-----------------------------------------------------------
-- Signal Names are defined in the DE10-Nano User Manual
-- http://de10-nano.terasic.com
-----------------------------------------------------------
 entity DE10_Top_Level is
	port(
		----------------------------------------
		--  CLOCK Inputs
		--  See DE10 Nano User Manual page 23
		----------------------------------------
		FPGA_CLK1_50  :  in std_logic;										--! 50 MHz clock input #1
		FPGA_CLK2_50  :  in std_logic;										--! 50 MHz clock input #2
		FPGA_CLK3_50  :  in std_logic;										--! 50 MHz clock input #3
		
		
		----------------------------------------
		--  Push Button Inputs (KEY) 
		--  See DE10 Nano User Manual page 24
		--  The KEY push button inputs produce a '0' 
		--  when pressed (asserted)
		--  and produce a '1' in the rest (non-pushed) state
		--  a better label for KEY would be Push_Button_n 
		----------------------------------------
		KEY : in std_logic_vector(1 downto 0);								--! Two Pushbuttons (active low)
		
		
		----------------------------------------
		--  Slide Switch Inputs (SW) 
		--  See DE10 Nano User Manual page 25
		--  The slide switches produce a '0' when
		--  in the down position 
		--  (towards the edge of the board)
		----------------------------------------
		SW  : in std_logic_vector(3 downto 0);								--! Four Slide Switches 
		
		
		----------------------------------------
		--  LED Outputs 
		--  See DE10 Nano User Manual page 26
		--  Setting LED to 1 will turn it on
		----------------------------------------
		LED : out std_logic_vector(7 downto 0);							--! Eight LEDs
		
		
		----------------------------------------
		--  GPIO Expansion Headers (40-pin)
		--  See DE10 Nano User Manual page 27
		--  Pin 11 = 5V supply (1A max)
		--  Pin 29 - 3.3 supply (1.5A max)
		--  Pins 12, 30 GND
		--  Note: the DE10-Nano GPIO_0 & GPIO_1 signals
		--  have been replaced by
		--  Audio_Mini_GPIO_0 & Audio_Mini_GPIO_1
		--  since some of the DE10-Nano GPIO pins
		--  have been dedicated to the Audio Mini
		--  plug-in card.  The new signals 
		--  Audio_Mini_GPIO_0 & Audio_Mini_GPIO_1 
		--  contain the available GPIO.
		----------------------------------------
		--GPIO_0 : inout std_logic_vector(35 downto 0);					--! The 40 pin header on the top of the board
		--GPIO_1 : inout std_logic_vector(35 downto 0);					--! The 40 pin header on the bottom of the board 
		Audio_Mini_GPIO_0 : inout std_logic_vector(33 downto 0);		--! 34 available I/O pins on GPIO_0
		Audio_Mini_GPIO_1 : inout std_logic_vector(12 downto 0)		--! 13 available I/O pins on GPIO_1 
	
		
	);
end entity DE10_Top_Level;



architecture DE10Nano_arch of DE10_Top_Level is

	signal clk_sec : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(50000000,32));
	signal basee : std_logic_vector(7 downto 0) := "00010000"; -- 1 Hz
	signal hard_LED_reg : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(0, 8));
	signal reset_hard : std_logic := '1';
	signal control : std_logic := '0';

	component LED_patterns is
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
	 end component;

begin

	LEDPATTERNS : LED_patterns port map(clk => FPGA_CLK1_50,   --port map with certain signals hard coded in
										reset => reset_hard,
										PB => KEY(0),
										SW => SW,
										HPS_LED_control => control,
										SYS_CLKs_sec => clk_sec,
										Base_rate => basee,
										LED_reg => hard_LED_reg,
										LED => LED);
										
		
	
end architecture;
