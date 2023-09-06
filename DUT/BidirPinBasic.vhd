-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity BidirPinBasic is
	port(   writePin: in 	std_logic;
			readPin:  out 	std_logic;
			bidirPin: inout std_logic
	);
end BidirPinBasic;

architecture comb of BidirPinBasic is
begin 

	readPin  <= bidirPin;
	bidirPin <= writePin;
	
end comb;
