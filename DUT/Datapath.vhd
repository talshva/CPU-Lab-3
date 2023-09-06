-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

---------------------------------------------------------
entity Datapath is
  GENERIC (n : INTEGER := 16;	-- Bus width, memory/program data width
		   m : INTEGER := 16;	-- Bus width, memory/program data width
		   k : INTEGER := 4;	-- address width of the register file
		   l : INTEGER := 6); 	-- address width of the dataMem/ProgMem, with 2^6 = 64 different addresses
		   
  port (clk, TBactive, rst, wren_Dmem_TB, wren_Pmem_TB: 				IN STD_LOGIC;
		Mem_wr, Cout, Cin, Ain, RFin, RFout, IRin:						IN STD_LOGIC;
		PCin, Imm1_in, Imm2_in, Mem_out, Mem_in: 						IN STD_LOGIC;
		OPC: 															IN STD_LOGIC_VECTOR (3 downto 0);
		PCsel: 															IN STD_LOGIC_VECTOR (1 downto 0);
		RFaddr: 														IN STD_LOGIC_VECTOR (1 downto 0);
		DATA_in_Dmem_TB: 												IN STD_LOGIC_VECTOR (n-1 downto 0);
		DATA_in_Pmem_TB: 												IN STD_LOGIC_VECTOR (m-1 downto 0);
		writeAddr_Dmem_TB, writeAddr_Pmem_TB:  							IN STD_LOGIC_VECTOR (l-1 DOWNTO 0);
		readAddr_Dmem_TB:												IN STD_LOGIC_VECTOR (l-1 DOWNTO 0);
		add, sub, nop, unused1, jmp, jc, jnc, unused2: 					OUT STD_LOGIC;
		mov, ld, st, done, Cflag, Zflag, Nflag:							OUT STD_LOGIC;
		DATA_out_Dmem_TB:						 						OUT STD_LOGIC_VECTOR (n-1 downto 0));
		 
end Datapath;
---------------------------------------------------------
architecture Datapath of Datapath is
	-- Program Memory --
	SIGNAL DATA_out_Pmem:																STD_LOGIC_VECTOR (n-1 downto 0);	
	-- Data Memory --
	SIGNAL	DATA_in_Dmem, DATA_in_Dmem_Bus, DATA_out_Dmem:								STD_LOGIC_VECTOR (n-1 downto 0);
	SIGNAL 	writeAddr_Dmem, writeAddr_Dmem_MuxOut, readAddr_Dmem, readAddr_Dmem_MuxOut:	STD_LOGIC_VECTOR (l-1 downto 0);
	SIGNAL  wren_Dmem: 																	STD_LOGIC;
	-- Reg File --
	SIGNAL	RF_Data_out, RF_Data_in: 													STD_LOGIC_VECTOR (n-1 downto 0);
	SIGNAL RF_WriteReadAddr: 															STD_LOGIC_VECTOR (k-1 DOWNTO 0);
	-- ALU --
	SIGNAL ALU_inA,ALU_inB, ALU_out, ALU_regC:											STD_LOGIC_VECTOR (n-1 downto 0);
	-- IR, PC --
	SIGNAL IR_out:																		STD_LOGIC_VECTOR (n-1 downto 0);
	SIGNAL IR_OP: 																		STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL IR_imm1_sext,IR_imm2_sext: 													STD_LOGIC_VECTOR (n-1 downto 0);
	SIGNAL PC_out, PC_in: 																STD_LOGIC_VECTOR (l-1 downto 0) := CONV_STD_LOGIC_VECTOR(0, l);
	-- Bus Signal --
    SIGNAL BUS_bidir: 																	STD_LOGIC_VECTOR (n-1 downto 0) := (others => 'Z');

BEGIN

	-- Port Mapping:
	g1: ALU generic map (n) port map (ALU_inB, ALU_inA, OPC, Cflag, Zflag, Nflag, ALU_out); 
	g2: dataMem 			port map (clk, wren_Dmem, DATA_in_Dmem, writeAddr_Dmem_MuxOut, readAddr_Dmem_MuxOut, DATA_out_Dmem); 
	g3: progMem 			port map (clk, wren_Pmem_TB, DATA_in_Pmem_TB, writeAddr_Pmem_TB, PC_out, DATA_out_Pmem); 
	g4: RF 			  		port map (clk, rst, RFin, RF_Data_in, RF_WriteReadAddr, RF_WriteReadAddr, RF_Data_out);
	
	
	--IR and Sign Extention:
	IR_OP <= IR_out(n-1 DOWNTO n-4);
	
	IR_imm1_sext(7 DOWNTO 0)	<= IR_out(7 DOWNTO 0);
	IR_imm1_sext(n-1 DOWNTO 8) 	<= (OTHERS => IR_OUT(7));

	IR_imm2_sext(3 DOWNTO 0)	<= IR_out(3 DOWNTO 0);
	IR_imm2_sext(n-1 DOWNTO 4) 	<= (OTHERS => '0');	--(OTHERS => IR_OUT(3));

	
	-- Instantiate the BidirPin component for each tri-state buffer:
	ALU_regC_buf: 	  BidirPin generic map(width => n) port map(Dout => ALU_regC, en => Cout, Din => ALU_inB, IOpin => BUS_bidir);
	IR_imm1_sext_buf: BidirPin generic map(width => n) port map(Dout => IR_imm1_sext, en => Imm1_in, IOpin => BUS_bidir); -- no Din
	IR_imm2_sext_buf: BidirPin generic map(width => n) port map(Dout => IR_imm2_sext, en => Imm2_in, IOpin => BUS_bidir); -- no Din
	RF_out_buf: 	  BidirPin generic map(width => n) port map(Dout => RF_Data_out, en => RFout, Din => RF_Data_in, IOpin => BUS_bidir);
	Dmem_out_buf:	  BidirPin generic map(width => n) port map(Dout => DATA_out_Dmem, 	en => Mem_out, Din => DATA_in_Dmem_Bus, IOpin => BUS_bidir);
	
	readAddr_Dmem <= BUS_bidir(l-1 downto 0);
	
	--  MUXs:

	-- Data Memory - TB:
	wren_Dmem      			<= wren_Dmem_TB	  		when TBactive = '1' 	else Mem_wr;
	DATA_in_Dmem    		<= DATA_in_Dmem_TB		when TBactive = '1' 	else DATA_in_Dmem_Bus;
	writeAddr_Dmem_MuxOut 	<= writeAddr_Dmem_TB 	when TBactive = '1' 	else writeAddr_Dmem;
	readAddr_Dmem_MuxOut 	<= readAddr_Dmem_TB 	when TBactive = '1' 	else readAddr_Dmem;
	DATA_out_Dmem_TB 		<= DATA_out_Dmem;
	
	-- PC Mux:	
	with PCsel select	
	PC_in <= PC_out + 1 								 	 when "00", -- PC + 1
			 SIGNED(PC_OUT) + 1 + SIGNED(IR_out(4 downto 0)) when "01", -- PC + 1 + IR_out(4 DOWNTO 0)
			 CONV_STD_LOGIC_VECTOR(0, l) 				 	 when "10", -- "0...0"
			 unaffected 								 	 when others;
		
	-- Select which register will be used in the RF (IR to RF Mux):
	WITH RFaddr SELECT
	RF_WriteReadAddr <= IR_out(3*k-1 downto 2*k) 	when "00", -- ra
						IR_out(2*k-1 downto k) 		when "01", -- rb	
						IR_out(k-1 downto 0) 		when "10", -- rc
						unaffected 					when others;
	


-------------------------------------- Synchronous Part --------------------------------------

	-- FOR DEBUGGING ONLY --
	-- print : process (clk) 
    --    begin
	--	 if rising_edge(clk) then
	--	 report "time = " & to_string(now);
	--	 report "ALU_regC = " & to_string(ALU_regC);
	--	 report "ALU_out = " & to_string(ALU_out);
	--	 report "Cflag_ALU = " & to_string(Cflag);
	--	 report "ALU_inA = " & to_string(ALU_inA);
	--	 report "ALU_inB = " & to_string(ALU_inB);
	--	 report "BUS = " & to_string(BUS_bidir);
	--	 report "PC_out = " & to_string(PC_out);
	--	 report "PC_in = " & to_string(PC_in);
	--	 report "DATA_out_Pmem = " & to_string(DATA_out_Pmem);	
	--	 report "read Dmem Address = " & to_string(readAddr_Dmem);
	--	 report " Dmem data out = " & to_string(DATA_out_Dmem_TB);
	--	 end if;
	--end process;	



	-- Registers updates on rising clock:
	process1: PROCESS (clk) 	
	BEGIN
		IF (rising_edge(clk)) THEN
		
			IF (Mem_in = '1') THEN	
				writeAddr_Dmem <= BUS_bidir(l-1 downto 0); 	-- signal after D-FF
			END IF;
			
			IF (Ain = '1') 	  THEN	
				ALU_inA <= BUS_bidir; 
			END IF;
			
			IF (Cin = '1') 	  THEN
				ALU_regC <= ALU_out;
			END IF;
			
			IF (IRin = '1')   THEN	
				IR_out <= DATA_out_Pmem;
			END IF;
			
			IF (PCin = '1')   THEN
				PC_out <= PC_in;
			END IF;
			
		END IF;
	END PROCESS;
	
	
	--  OPC Decoder:
	process2: PROCESS (IR_OP) 
	BEGIN
		CASE IR_OP IS
			WHEN "0000" => 	-- add
				add 	<= '1';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0001" => 	-- sub
				add 	<= '0';
				sub 	<= '1';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0010" =>  -- nop
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '1';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0011" =>  -- unused1
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '1';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0100" =>  -- jmp
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '1';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0101" =>  -- jc
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '1';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0110" =>  -- jnc
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '1';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "0111" =>  -- unused2
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '1';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "1000" =>  -- mov
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '1';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
			WHEN "1001" =>  -- ld
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '1';
				st 		<= '0';
				done 	<= '0';
			WHEN "1010" =>  -- st
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '1';
				done 	<= '0';
			WHEN "1011" =>  -- done
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '1';						
		  WHEN OTHERS 	=> 
				add 	<= '0';
				sub 	<= '0';
				nop	 	<= '0';	
				unused1 <= '0';
				jmp 	<= '0';
				jc 		<= '0';
				jnc 	<= '0';
				unused2 <= '0';
				mov 	<= '0';
				ld 		<= '0';
				st 		<= '0';
				done 	<= '0';
		END CASE;
	END PROCESS;
		
	
END Datapath;                 