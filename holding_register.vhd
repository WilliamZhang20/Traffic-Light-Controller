--Authors: Group 26, Sanjay Jayaram, William Zhang
library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; -- serial register signal at overall output

BEGIN

	process(clk)
	
	begin
		if(rising_edge(clk)) then
			sreg <= (sreg OR din) AND (NOT(register_clr OR reset));
		end if;

	end process;
	
	dout <= sreg;

end;