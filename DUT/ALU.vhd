-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.aux_package.all;
----------------------------------------------------------------------------------------------------
ENTITY ALU IS
  GENERIC 	(n : INTEGER := 16);
  PORT (X,Y: 	IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- X[n-1:0], Y[n-1:0] goes into the ALU
		OPC: 	IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- OPC [3:0] goes into the ALU
        Cflag, Zflag, Nflag: OUT STD_LOGIC; -- bit
        s: 		OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)); -- vector of length n (MSB on the left)
END ALU;

----------------------------------------------------------------------------------------------------
ARCHITECTURE dfALU OF ALU IS
	SIGNAL carry_vec, zero_vec: STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- carry and zero vectors
	SIGNAL Ysig, Xsig, Ssig: 	STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- vectors of length n
	SIGNAL sub_cont: STD_LOGIC;
BEGIN 
	with OPC select
	sub_cont <= '0' when "0000", -- Res=Y+X 
				'1' when "0001", -- Res=Y-X 
				'0' when "0010", -- Nop (R[r0] + R[r0])
				unaffected when others;
					
	Ysig <= Y;	   
	Xsig(0) <= x(0) xor sub_cont;
	firstFA : FA port map( -- the first FullAdder
			xi => Xsig(0),
			yi => Ysig(0),
			cin => sub_cont,
			s => Ssig(0),
			cout => carry_vec(0)
	);
	
	otherFA : for i in 1 to n-1 generate
		Xsig(i) <= x(i) xor sub_cont;
		chain : FA port map( -- implementing all of the other FullAdders.
			xi => Xsig(i),
			yi => Ysig(i),
			cin => carry_vec(i-1), -- previous FA Carry
			s => Ssig(i),	
			cout => carry_vec(i) -- Carry goes to the next FA
		);
	end generate;
	
	s <= Ssig;	       -- Output of the ALU
	Cflag <= carry_vec(n-1); -- last FA carry, this is the Cout of the ALU
	Nflag <= Ssig(n-1);  -- the MSB indicates if the result is negative
	
	-- calculating if the result is zero:
	zero_vec(0) <= Ssig(0);	   -- innitialize
	loop1: for i in 1 to n-1 generate
				zero_vec(i) <= zero_vec(i-1) or Ssig(i); -- 'OR' of all the bits of the result
			end generate;
	Zflag <= not(zero_vec(n-1)); 

	
	
----------------------------------------------------------------------------------------------------
END ARCHITECTURE dfALU;

