-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------
entity BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			Din:	out		std_logic_vector(width-1 downto 0);
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
end BidirPin;

architecture comb of BidirPin is
begin 

	Din  <= IOpin;
	IOpin <= Dout when(en='1') else (others => 'Z');
	
end comb;

