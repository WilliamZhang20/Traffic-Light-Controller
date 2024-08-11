--Authors: Group 26, Sanjay Jayaram, William Zhang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine IS Port
(
	clk_input, clk_enable, reset, NSRequest, EWRequest			: IN std_logic;
 	NSGreenBlink, NSGreen, NSAmber, NSRed 					: OUT std_logic;
 	EWGreenBlink, EWGreen, EWAmber, EWRed 					: OUT std_logic;
 	NSCrossingDisplay, EWCrossingDisplay 					: OUT std_logic;
 	NSReset, EWReset 							: OUT std_logic;
 	state_num								: OUT std_logic_vector(3 downto 0);
 	blinkSignal			 					: IN std_logic
	 
);
END ENTITY;
 

 Architecture SM of State_Machine is
 
 --State Name Architecture G|SOLID|EW|2 <- Color(Green or Amber)|Light Type(Solid or blinking)|Direction Not Red|Position in Order
 --ex. ASOLIDNS1 is Amber, solid for north south direction, and is the first one of its type.

 TYPE STATE_NAMES IS (GBLINKNS1, GBLINKNS2, GSOLIDNS1, GSOLIDNS2, GSOLIDNS3, GSOLIDNS4, ASOLIDNS1, ASOLIDNS2,
							 GBLINKEW1, GBLINKEW2, GSOLIDEW1, GSOLIDEW2, GSOLIDEW3, GSOLIDEW4, ASOLIDEW1, ASOLIDEW2);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES
 

 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= GBLINKNS1;
		ELSIF (clk_enable = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (EWRequest, NSRequest, current_state) 

BEGIN
  CASE current_state IS
        WHEN GBLINKNS1 =>
				IF (EWRequest = '1' AND NSRequest='0') THEN
					next_state <= ASOLIDNS1;
				ELSE
					next_state <= GBLINKNS2;
				END IF;
			
			WHEN GBLINKNS2 =>		
				IF (EWRequest = '1' AND NSRequest='0') THEN
					next_state <= ASOLIDNS1;
				ELSE
					next_state <= GSOLIDNS1;
				END IF;
			
			WHEN GSOLIDNS1 =>
				next_state <= GSOLIDNS2;
			
			WHEN GSOLIDNS2 =>	
				next_state <= GSOLIDNS3;
			
			WHEN GSOLIDNS3 =>	
				next_state <= GSOLIDNS4;
			
			WHEN GSOLIDNS4 =>		
				next_state <= ASOLIDNS1;
			
			WHEN ASOLIDNS1 =>		
				next_state <= ASOLIDNS2;
			
			WHEN ASOLIDNS2 =>		
				next_state <= GBLINKEW1;
			
         WHEN GBLINKEW1 =>		
				IF (EWRequest = '0' AND NSRequest='1') THEN
					next_state <= ASOLIDEW1;
				ELSE	
					next_state <= GBLINKEW2;
				END IF;
			
			WHEN GBLINKEW2 =>	
				IF (EWRequest = '0' AND NSRequest='1') THEN
					next_state <= ASOLIDEW1;
				ELSE		
					next_state <= GSOLIDEW1;
				END IF;
			
			WHEN GSOLIDEW1 =>	
				next_state <= GSOLIDEW2;
			
			WHEN GSOLIDEW2 =>	
				next_state <= GSOLIDEW3;
			
			WHEN GSOLIDEW3 =>	
				next_state <= GSOLIDEW4;
			
			WHEN GSOLIDEW4 =>		
				next_state <= ASOLIDEW1;
			
			WHEN ASOLIDEW1 =>		
				next_state <= ASOLIDEW2;
			
			WHEN ASOLIDEW2 =>		
				next_state <= GBLINKNS1;

			WHEN OTHERS =>
              next_state <= GBLINKNS1;
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS (MOORE FORM)

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN GBLINKNS1 =>	
				NSGreenBlink <= '1';
				NSGreen <= blinkSignal;
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0000";
			
         WHEN GBLINKNS2 =>	
				NSGreenBlink <= '1';
				NSGreen <= blinkSignal;
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0001";
			
        WHEN GSOLIDNS1 =>	
				NSGreenBlink <= '0';
				NSGreen <= '1';
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '1'; -- North South direction is crossing
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0010";
			
			WHEN GSOLIDNS2 =>	
				NSGreenBlink <= '0';
				NSGreen <= '1';
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '1';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0011";
			
			WHEN GSOLIDNS3 =>	
				NSGreenBlink <= '0';
				NSGreen <= '1';
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '1';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0100";
			
			WHEN GSOLIDNS4 =>	
				NSGreenBlink <= '0';
				NSGreen <= '1';
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '1';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0101";
				
			WHEN ASOLIDNS1 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '1';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '1'; -- North-South crossing request is cleared - previous request has been granted.
				EWReset <= '0';
				state_num <= "0110";
			
			WHEN ASOLIDNS2 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '1';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '1';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "0111";
			
			WHEN GBLINKEW1 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '1';
				EWGreen <= blinkSignal;
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1000";
			
         WHEN GBLINKEW2 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '1';
				EWGreen <= blinkSignal;
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1001";
			
        WHEN GSOLIDEW1 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '1';
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '1'; -- East-West Direction is crossing
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1010";
			
			WHEN GSOLIDEW2 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '1';
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '1';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1011";
			
			WHEN GSOLIDEW3 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '1';
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '1';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1100";
			
			WHEN GSOLIDEW4 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '1';
				EWAmber <= '0';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '1';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1101";
				
			WHEN ASOLIDEW1 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '1';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '1'; -- East-West crossing request is cleared - previous request has been granted.
				state_num <= "1110";
			
			WHEN ASOLIDEW2 =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '1';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '1';
				EWRed <= '0';
				NSCrossingDisplay <= '0';
				EWCrossingDisplay <= '0';
				NSReset <= '0';
				EWReset <= '0';
				state_num <= "1111";
			
         WHEN OTHERS =>	
				NSGreenBlink <= '0';
				NSGreen <= '0';
				NSAmber <= '0';
				NSRed <= '0';
				EWGreenBlink <= '0';
				EWGreen <= '0';
				EWAmber <= '0';
				EWRed <= '0';
				state_num <= "0000";
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
