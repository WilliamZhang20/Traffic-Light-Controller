--Authors: Group 26, Sanjay Jayaram, William Zhang
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
PORT
(
   clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
          clk        : in  	std_logic := '0';
			 DIN2 		: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
	);
   end component;

    component pb_filters port (
			clkin					: in std_logic;
			rst_n					: in std_logic;
			rst_n_filtered	  	: out std_logic;
			pb_n					: in  std_logic_vector (3 downto 0);
			pb_n_filtered	   : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				: out	std_logic;							 
			pb_n_filtered	: in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
   end component; 
  component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;	


Component State_Machine Port
(
	 clk_input, reset, NSRequest, EWRequest			: IN std_logic;
	 NSGreenBlink, NSGreen, NSAmber, NSRed 			: OUT std_logic;
	 EWGreenBlink, EWGreen, EWAmber, EWRed 			: OUT std_logic;
	 NSCrossingDisplay, EWCrossingDisplay 				: OUT std_logic;
	 NSReset, EWReset : OUT std_logic;
	 state_num			: OUT std_logic_vector(3 downto 0);
	 blinkSignal : IN std_logic
	 
 );
END Component;  
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode																: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    					: std_logic; -- signals to reset the state machine, synchronizer, and holding register
	SIGNAL sm_clken, blink_sig													: std_logic; -- outputs of clock generator component for clock and blink signals to state machines
	SIGNAL pb_n_filtered, pb, pb_sync										: std_logic_vector(3 downto 0);  -- versions of the push button arrays
	SIGNAL NSRequest, EWRequest 												: STD_LOGIC; -- request signals for the north-south direction and east-west directions
	SIGNAL NSGreenBlink, NSGreen, NSAmber, NSRed 						: std_logic; -- outputs to the north-south segment: blinking green, solid green, amber, and red
	SIGNAL EWGreenBlink, EWGreen, EWAmber, EWRed 						: std_logic; -- output to the east-west segment: blinking green, solid green, amber, and red
	SIGNAL NSReset, EWReset 													: std_logic; -- The reset signals for the NS and EW requests, input into the holding register to clear them
	SIGNAL state_number 															: std_logic_vector(3 downto 0); -- the 4-bit state number
	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters			port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered); -- Premade instance required to filter the push button signals
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb); -- inverts push buttons so that pressed = 1
INST2: synchronizer     port map (clkin_50,synch_rst, rst, synch_rst);	-- the synchronizer is also reset by synch_rst.
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig); -- given clock generator instance to generate blink signal and state machine clock enable


SYNC0: synchronizer     port map (clkin_50,synch_rst, pb(0), pb_sync(0)); -- Input synchronizer for the NS direction
HRNS : holding_register port map (clkin_50,synch_rst,NSReset,pb_sync(0), NSRequest); -- north-south holding register

SYNC1: synchronizer     port map (clkin_50,synch_rst, pb(1), pb_sync(1)); -- Input synchronizer for the EW direction
HREW : holding_register port map (clkin_50,synch_rst,EWReset,pb_sync(1), EWRequest); -- east-west holding register

SMAC: State_Machine port map(sm_clken, synch_rst, NSRequest, EWRequest, NSGreenBlink, NSGreen, NSAmber, NSRed, EWGreenBlink, EWGreen, EWAmber, EWRed, leds(0), leds(2), NSReset, EWReset, state_number, blink_sig); -- the state machine instance

DSPLY: segment7_mux port map(clkin_50, EWAmber & "00" & EWGreen & "00" & EWRed, NSAmber & "00" & NSGreen & "00" & NSRed , seg7_data, seg7_char1, seg7_char2); -- concatenations for the outputs to the two 7-segment displays

leds(7) <= state_number(3); -- assigns state number statuses (1 or 0) to the LEDS 7 to 4
leds(6) <= state_number(2);
leds(5) <= state_number(1);
leds(4) <= state_number(0);

leds(1) <= NSRequest; -- Assigns NS and EW request buttons to the corresponding LEDS numbers 1 and 3.
leds(3) <= EWRequest;
END SimpleCircuit;
