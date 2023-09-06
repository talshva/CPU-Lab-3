-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------
entity RF is
generic( Dwidth: integer:=16;
		 Awidth: integer:=4);
port(	clk,rst,WregEn: in std_logic;	
		WregData:	in std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RregData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end RF;
--------------------------------------------------------------
architecture behav of RF is

type RegFile is array (0 to 2**Awidth-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRF: RegFile;

begin			   
  process(clk,rst)
  begin
	if (rst='1') then
		sysRF(0) <= (others=>'0');   -- R[0] is constant Zero value 
	elsif (clk'event and clk='1') then
	    if (WregEn='1') then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRF(conv_integer(WregAddr)) <= WregData; 
	    end if;
	end if;
  end process;
	
  RregData <= sysRF(conv_integer(RregAddr));

end behav;
