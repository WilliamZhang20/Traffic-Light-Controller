--Authors: Group 26, Sanjay Jayaram, William Zhang
library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); -- outputs for both flip flops in the register

BEGIN

	process(clk)
	
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				sreg(0) <= '0';
			else
				sreg(0) <= din; -- assigns input to first flip flop
			end if;
		end if;

	end process;

	
	process(clk)
	
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				sreg(1) <= '0';
			else
				sreg(1) <= sreg(0); -- assigns first flip flop output to second flip flop
			end if;
		end if;

	end process;
	
	dout <= sreg(1); -- final output is second flip flop output
	
	
end;