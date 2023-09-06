-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

---------------------------------------------------------
entity Control is
  GENERIC (n : INTEGER := 16); 

  
  port (rst, ena, clk: 										IN STD_LOGIC;
		add, sub, nop, unused1, jmp, jc, jnc, unused2:		IN STD_LOGIC;
		mov, ld, st, done, Cflag, Zflag, Nflag:				IN STD_LOGIC;	
		Mem_wr, Cout, Cin, Ain, RFin, RFout:				OUT STD_LOGIC;
		IRin, PCin, Imm1_in, Imm2_in, Mem_out, Mem_in:		OUT STD_LOGIC;
		OPC: 												OUT STD_LOGIC_VECTOR (3 downto 0);
		RFaddr: 											OUT STD_LOGIC_VECTOR (1 downto 0);
		PCsel: 												OUT STD_LOGIC_VECTOR (1 downto 0);
		tb_done: 											OUT STD_LOGIC;
		tb_pr_state:										OUT state); -- STD_LOGIC_VECTOR (3 downto 0)
		
end Control;
---------------------------------------------------------
ARCHITECTURE fsm OF Control IS
	SIGNAL pr_state, nx_state: state;
BEGIN

	PROCESS (rst, clk)
	BEGIN
		IF (rst='1') THEN
			pr_state <= Reset;
		ELSIF (clk'EVENT AND clk='1' AND ena = '1') THEN
			pr_state <= nx_state;
		END IF;
	END PROCESS;
	
	PROCESS (ena, pr_state, add, sub, nop, unused1, jmp, jc, jnc, unused2, mov, ld, st, done, Cflag, Zflag, Nflag)
	BEGIN
		CASE pr_state IS
		
--          @@@@@@@ state 0 @@@@@@@@
			WHEN Reset =>
			IF done = '0' THEN
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "0000"; 
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFout	 <= '0';
				RFaddr	 <= "00";   
				IRin	 <= '0';
				PCin	 <= '1';	-- change PC
				PCsel	 <= "10";	-- PC <--- 0...0
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				nx_state <= Fetch;
			END IF;
			
			
--          @@@@@@@ state 1 @@@@@@@@		
			WHEN Fetch => 
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 	-- ALU unaffected
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFout	 <= '0';
				RFaddr	 <= "11";   	-- RF unaffected
				IRin	 <= '1';		-- Get an instruction from the program memory
				PCin	 <= '0';
				PCsel	 <= "00";	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';	
				-- select next state:				
				nx_state <= Decode;
				
				
--          @@@@@@@ state 2 @@@@@@@@			
			WHEN Decode =>
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				Ain	 	 <= '0';
				RFin	 <= '0';		
				RFout	 <= '0';
				IRin	 <= '0';
				PCin	 <= '0';
				RFaddr	 <= "11";
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				
				IF 	  (jmp = '1' OR 
								(jc = '1' AND Cflag = '1') OR 
														  (jnc = '1' AND Cflag = '0')) 			THEN	-- OR unused2 = 1
						PCsel	 <= "01";	-- PC <--- PC + 1 + Immidiate <4..0>	(PC isn't changing yet)
				ELSE
						PCsel	 <= "00";   -- PC <--- PC + 1	(PC isn't changing yet)
				END IF;
		
				-- select next state:
				IF 	  (add = '1' OR sub = '1' OR nop = '1' OR unused1 = '1')					THEN
						nx_state <= R_1;
				ELSIF (jmp = '1' OR jc = '1' OR jnc = '1' OR unused2 = '1') 					THEN
						nx_state <= J;
				ELSE 	-- mov = '1' OR ld = '1' OR st = '1' OR done = '1')
						nx_state <= I_1;
				END IF;
				
				
--          @@@@@@@ state 3 @@@@@@@@	
			WHEN R_1 => 						
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				RFin	 <= '0';
				RFaddr	 <= "01";    -- select R[rb] 
				RFout	 <= '1';	 -- put R[rb] data into the BUS					
				Ain	 	 <= '1';	 -- register 'A' gets the data (R[rb]) from the BUS
				IRin	 <= '0';
				PCin	 <= '0';
				PCsel	 <= "00";	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				-- select next state:
				nx_state <= R_2;	
				
			
--          @@@@@@@ state 4 @@@@@@@@		
			WHEN R_2 =>			
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFaddr	 <= "10";   	-- select R[rc] 
				RFout	 <= '1';		-- put R[rc] data into the BUS	
				IRin	 <= '0';
				
				IF 	  (add = '1') 		THEN 	OPC <= "0000";	-- ALU calculating (rb OP rc)
				ELSIF (sub = '1') 		THEN	OPC <= "0001";	
				ELSIF (nop = '1') 		THEN	OPC <= "0010";   
				ELSIF (unused1 = '1') 	THEN	OPC <= "0011";  
				ELSE 							OPC <= "1111";
				END IF;
				
				Cin	 	 <= '1';		-- register 'C' gets the data from the ALU's output.	
				PCin	 <= '0';
				PCsel	 <= "00";	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				-- select next state:
				nx_state <= R_WB;
				

--          @@@@@@@ state 5 @@@@@@@@
			WHEN R_WB =>
				Mem_wr	 <= '0';
				Cout	 <= '1';		-- put register 'C' data (rb OP rc) into the BUS	
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				Ain	 	 <= '0';
				RFaddr	 <= "00";   -- select R[ra]  
				RFin	 <= '1';	-- put BUS data (rb OP rc) into register R[ra]
				RFout	 <= '0';
				IRin	 <= '0';
				PCin	 <= '1';	-- change PC	
				PCsel	 <= "00";	-- PC <--- PC + 1	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				-- select next state:
				nx_state <= Fetch;
				
				
--          @@@@@@@ state 6 @@@@@@@@
			WHEN J 	 =>
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111";  -- Unaffected
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFout	 <= '0';
				RFaddr	 <= "11";    -- Unaffected 
				IRin	 <= '0';
				PCin	 <= '1';	 -- change PC	

				IF (jmp = '1' 
						     OR (jc = '1' AND Cflag = '1') 
													   OR (jnc = '1' AND Cflag = '0')) 	THEN	-- OR unused2 = 1
					PCsel <= "01"; -- PC <--- PC + 1 + IR<4...0>
				ELSE			   -- if condition not applying, just PC++
					PCsel <= "00";		
				END IF;
				
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				-- select next state:
				nx_state <= Fetch;
				
				
--          @@@@@@@ state 7 @@@@@@@@
			WHEN I_1 =>					
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				IRin	 <= '0';
				PCsel	 <= "00";			-- PC <-- PC + 1	
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				
				IF 	(mov = '1' ) 				THEN
					Imm1_in	 <= '1';		-- load the long Immidiate into the BUS
					Imm2_in	 <= '0';
					Ain	 	 <= '0';
					RFaddr	 <= "00";  		-- select R[ra]  
					RFin	 <= '1';		-- put BUS data (Imm1) into register R[ra]
					PCin	 <= '1';		-- Change PC
					tb_done  <= '0';
					RFout	 <= '0';
					-- select next state:
					nx_state <= Fetch;

				ELSIF (done = '1')				THEN
					Imm1_in	 <= '0';
					Imm2_in	 <= '0';
					Ain	 	 <= '0';
					RFin	 <= '0';
					RFaddr	 <= "11";  
					PCin	 <= '1';			-- Change PC
					tb_done  <= '1';			-- Signal to TB that DTCM content is ready to be read
					RFout	 <= '0';
					-- select next state:
					nx_state <= Reset;
					
				ELSIF (ld = '1' OR st = '1')	THEN
					Imm1_in	 <= '0';
					Imm2_in	 <= '0';	
					RFin	 <= '0';
					RFaddr	 <= "01";  		-- select R[rb]  
					RFout	 <= '1';		-- put R[rb] data into the BUS	
					Ain	 	 <= '1';		-- register 'A' gets the data (R[rb]) from the BUS				
					PCin	 <= '0';
					tb_done  <= '0';
					-- select next state:
					nx_state <= I_2;
				
				END IF;
				
--          @@@@@@@ state 8 @@@@@@@@			
			WHEN I_2 =>					
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Imm2_in	 <= '1';		-- load the short Immidiate into the BUS
				OPC	 	 <= "0000"; 	-- ALU perform R[rb] + sext<Imm2> into register C
				Cin	 	 <= '1';		-- (C <--- A + B)
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFout	 <= '0';
				RFaddr	 <= "11";   	
				IRin	 <= '0';
				PCin	 <= '0';		
				PCsel	 <= "00";	
				Imm1_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				tb_done  <= '0';
				-- select next state:
				nx_state <= I_3;
				
				
--          @@@@@@@ state 9 @@@@@@@@
			WHEN I_3 =>			
				Mem_wr	 <= '0';
				Cout	 <= '1';		-- put register 'C' data (R[rb] + sext<Imm2>) into the BUS
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				Ain	 	 <= '0';
				RFin	 <= '0';
				RFout	 <= '0';
				RFaddr	 <= "00";  		-- select R[ra]  (preparing for next state)
				IRin	 <= '0';
				PCin	 <= '0';
				PCsel	 <= "00";	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_out	 <= '0';
				Mem_in	 <= '1';		-- put the BUS data (R[rb] + sext<Imm2>) into the data memory address D-FF. 
				tb_done  <= '0';
				-- select next state:
				nx_state <= I_4;


--          @@@@@@@ state 10 @@@@@@@@	
			WHEN I_4 =>
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				Ain	 	 <= '0';
				RFaddr	 <= "00"; 	-- select R[ra]
				IRin	 <= '0';
				PCin	 <= '1';	-- Change PC
				PCsel	 <= "00";	-- PC <--- PC + 1	
				Imm1_in	 <= '0';
				Imm2_in	 <= '0';
				Mem_in	 <= '0';
				
				IF (ld = '1')					THEN
					RFout	 <= '0';
					Mem_out	 <= '1';	-- get the data from the Data Memory into the BUS
					Mem_wr	 <= '0';
					RFin	 <= '1';	-- get the BUS data into R[ra]
					
				ELSIF (st = '1')				THEN
					RFout	 <= '1';	-- get R[ra] data into the BUS
					Mem_out	 <= '0';
					Mem_wr	 <= '1';	-- write the BUS data into the Data Memory (in the address provided on previous cycle)
					RFin	 <= '0';
				END IF;	
				
				tb_done  <= '0';
				-- select next state:
				nx_state <= Fetch;
				
		END CASE;
  END PROCESS;
  
  tb_pr_state <= pr_state;
  
END fsm;

