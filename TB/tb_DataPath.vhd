library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
---------------------------------------------------------
entity tb is
	constant Dwidth    : integer:=16 ;
	constant AwidthRam : integer:=6 ;	 
	constant AwidthRF  : integer:=4 ;
	constant dept      : integer:=64;

	constant dataMemResult:	 	string(1 to 105) :=
	"C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\LAB3\TB\Memory files\DTCMcontent.txt";
	
	constant dataMemLocation: 	string(1 to 102) :=
	"C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\LAB3\TB\Memory files\DTCMinit.txt";
	
	constant progMemLocation: 	string(1 to 102) :=
	"C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\LAB3\TB\Memory files\ITCMinit.txt";
end tb;
---------------------------------------------------------
architecture rtb of tb is

	SIGNAL Mem_wr, Cout, Cin, Ain, RFin, RFout, IRin:					STD_LOGIC;
	SIGNAL PCin, Imm1_in, Imm2_in, Mem_out, Mem_in: 					STD_LOGIC;
	SIGNAL add, sub, nop, unused1, jmp, jc, jnc, unused2: 				STD_LOGIC;
	SIGNAL mov, ld, st, done, Cflag, Zflag, Nflag, tb_done:				STD_LOGIC;
	SIGNAL OPC: 														STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL PCsel: 														STD_LOGIC_VECTOR (1 downto 0);
	SIGNAL RFaddr: 														STD_LOGIC_VECTOR (1 downto 0);
		
	SIGNAL clk, TBactive, rst, wren_Dmem_TB, wren_Pmem_TB: 				STD_LOGIC;	
	SIGNAL DATA_in_Dmem_TB, DATA_out_Dmem_TB: 							STD_LOGIC_VECTOR (Dwidth-1 downto 0); -- n
	SIGNAL DATA_in_Pmem_TB: 											STD_LOGIC_VECTOR (Dwidth-1 downto 0); -- m (m=n?)

	SIGNAL writeAddr_Dmem_TB, writeAddr_Pmem_TB:  						STD_LOGIC_VECTOR (AwidthRam-1 DOWNTO 0);
	SIGNAL readAddr_Dmem_TB:											STD_LOGIC_VECTOR (AwidthRam-1 DOWNTO 0);
	
	SIGNAL  donePmemIn, doneDmemIn:										BOOLEAN;
	
	
begin


	L0: Datapath PORT MAP (
						clk => clk, rst => rst,
						DATA_in_Dmem_TB => DATA_in_Dmem_TB, DATA_in_Pmem_TB => DATA_in_Pmem_TB,
						writeAddr_Dmem_TB => writeAddr_Dmem_TB, writeAddr_Pmem_TB => writeAddr_Pmem_TB,
						readAddr_Dmem_TB => readAddr_Dmem_TB,
						wren_Dmem_TB => wren_Dmem_TB, wren_Pmem_TB => wren_Pmem_TB,
						TBactive => TBactive,
						Mem_wr => Mem_wr, Cout => Cout, Cin => Cin,
						Ain => Ain, RFin => RFin, RFout => RFout,
						IRin => IRin, PCin => PCin, Imm1_in => Imm1_in,
						Imm2_in => Imm2_in, Mem_out => Mem_out, Mem_in => Mem_in,
						OPC => OPC, PCsel => PCsel, RFaddr => RFaddr,
						add => add, sub => sub, nop => nop, unused1 => unused1,
						jmp => jmp, jc => jc, jnc => jnc, unused2 => unused2,
						mov => mov, ld => ld, st => st, done => done,
						Cflag => Cflag, Zflag => Zflag, Nflag => Nflag,
						DATA_out_Dmem_TB => DATA_out_Dmem_TB);
	
	--------- start of stimulus section ------------------	


--------- Clock
gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;

--------- Rst
gen_rst : process
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process;	
--------- TB
gen_TB : process
	begin
	 TBactive <= '1';
	 wait until donePmemIn and doneDmemIn;  
	 TBactive <= '0';
	 wait until tb_done = '1';  
	 TBactive <= '1';	
	end process;	
	



	--------- reading from external Data Memory file and writing to RAM	(CPU Data Memory)
	LoadDataMem:process 
		file inDmemfile : text open read_mode is dataMemLocation;
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(AwidthRam-1 downto 0) ; -- Awidth
	begin 
		--wait for 50 ns;
		doneDmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inDmemfile) loop
			readline(inDmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			wren_Dmem_TB <= '1';
			writeAddr_Dmem_TB <= TempAddresses;
			DATA_in_Dmem_TB <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		wren_Dmem_TB <= '0';
		doneDmemIn <= true;
		file_close(inDmemfile);
		wait;
	end process;
		
		
	--------- reading from external Program Memory file and writing to RAM	(CPU Program Memory)
	LoadProgramMem:process 
		file inPmemfile : text open read_mode is progMemLocation;
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(AwidthRam-1 downto 0) ; -- Awidth
	begin 
		donePmemIn <= false;
		TempAddresses := (others => '0');
		while not endfile(inPmemfile) loop
			readline(inPmemfile,L);
			hread(L,linetomem,good);
			next when not good;
			wren_Pmem_TB <= '1';	
			writeAddr_Pmem_TB <= TempAddresses;
			DATA_in_Pmem_TB <= linetomem;
			wait until rising_edge(clk);
			TempAddresses := TempAddresses +1;
		end loop ;
		wren_Pmem_TB <= '0';
		donePmemIn <= true;
		file_close(inPmemfile);
		wait;
	end process;
	
	
	
	
	
	StartTb : process
		begin
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "0000"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "00"; 
			IRin	 <= '0';
			PCin	 <= '1';		-- PC <-- 0...0
			PCsel	 <= "10";
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
			Cflag	 <= '0';
			Zflag	 <= '0';
			Nflag  	 <= '0';
			
			wait until donePmemIn and doneDmemIn;  

			
			wait for 100 ns; --reset
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; -- ALU unaffected
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "11";   -- RF unaffected
			IRin	 <= '0';
			PCin	 <= '1';
			PCsel	 <= "10";	-- PC <--- 0...0
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
				
			wait for 100 ns; --fetch (first instruction in the file is Load)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "00";   
			IRin	 <= '1';		-- get instruction
			PCin	 <= '0';
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
			
			wait for 100 ns; -- Load (decode state)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '1';		--WAS 0
			RFaddr	 <= "01"; 		-- R[rb]  
			IRin	 <= '0';
			PCin	 <= '0';
			PCsel	 <= "00";   -- PC <--- PC+1
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
		
			wait for 100 ns; -- Load (I_1)
			
				Mem_wr	 <= '0';
				Cout	 <= '0';
				Cin	 	 <= '0';
				OPC	 	 <= "1111"; 
				IRin	 <= '0';
				PCsel	 <= "01";	
				Mem_out	 <= '0';
				Mem_in	 <= '0';
				Imm1_in	 <= '0';
				Imm2_in	 <= '1';	--WAS 0
				Ain	 	 <= '1';
				RFin	 <= '0';
				RFout	 <= '0';	--WAS 1
				RFaddr	 <= "01";  		-- R[rb]
				PCin	 <= '0';
				tb_done  <= '0';

			wait for 100 ns; --Load (I_2)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '1';
			OPC	 	 <= "0000"; 	-- add
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "01";   	-- R[rb]
			IRin	 <= '0';
			PCin	 <= '0';		
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';	--WAS 1
			Mem_out	 <= '0';
			Mem_in	 <= '1';
			tb_done  <= '0';
			
			wait for 100 ns; --Load (I_3)
			
			Mem_wr	 <= '0';
			Cout	 <= '1';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "00";  		-- R[ra]
			IRin	 <= '0';
			PCin	 <= '0';
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
				
			wait for 100 ns; --Load (I_4)
			
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFaddr	 <= "00"; 	--R[ra]  
			IRin	 <= '0';
			PCin	 <= '1';
			PCsel	 <= "00";	-- PC <-- PC+1	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_in	 <= '0';
			RFout	 <= '0';
			Mem_out	 <= '1';
			Mem_wr	 <= '0';
			RFin	 <= '1';
			tb_done  <= '0';

				
			---- New Instruction:
		
			wait for 100 ns; --fetch (first instruction in the file is Store)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "00";   
			IRin	 <= '1';		-- get instruction
			PCin	 <= '0';
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
			
			wait for 100 ns; -- Store (decode state)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "01"; 		-- R[rb]  
			IRin	 <= '0';
			PCin	 <= '0';
			PCsel	 <= "00";   -- PC <--- PC+1
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			tb_done  <= '0';
		
			wait for 100 ns; -- Store (I_1)
		
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			IRin	 <= '0';
			PCsel	 <= "01";	
			Mem_out	 <= '0';
			Mem_in	 <= '0';
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Ain	 	 <= '1';
			RFin	 <= '0';
			RFout	 <= '1';
			RFaddr	 <= "01";  		-- R[rb]
			PCin	 <= '0';
			tb_done  <= '0';

				
	
			wait for 100 ns; --Store (I_2)
			
			Mem_wr	 <= '0';
			Cout	 <= '0';
			Cin	 	 <= '1';
			OPC	 	 <= "0000"; 	-- add
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "01";   	-- R[rb]
			IRin	 <= '0';
			PCin	 <= '0';		
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '1';
			Mem_out	 <= '0';
			Mem_in	 <= '0';	
			tb_done  <= '0';
			
	
			wait for 100 ns; -- Store (I_3)
			
			Mem_wr	 <= '0';
			Cout	 <= '1';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFin	 <= '0';
			RFout	 <= '0';
			RFaddr	 <= "00";  		-- R[ra]
			IRin	 <= '0';
			PCin	 <= '0';
			PCsel	 <= "00";	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_out	 <= '0';
			Mem_in	 <= '1';
			tb_done  <= '0';

			
			wait for 100 ns; -- Store (I_4)
			
			Cout	 <= '0';
			Cin	 	 <= '0';
			OPC	 	 <= "1111"; 
			Ain	 	 <= '0';
			RFaddr	 <= "00"; 	--R[ra]  
			IRin	 <= '0';
			PCin	 <= '1';
			PCsel	 <= "00";	-- PC <-- PC+1	
			Imm1_in	 <= '0';
			Imm2_in	 <= '0';
			Mem_in	 <= '0';
			RFout	 <= '1';
			Mem_out	 <= '0';
			Mem_wr	 <= '1';
			RFin	 <= '0';
			tb_done  <= '0';	

			wait for 100 ns; 
			tb_done  <= '1';	-- just for simulation
			wait for 100 ns; 
			
		end process;	
		
		
		
		--------- Writing from Data memory (CPU) to external Data Memory file, after the program ends (tb_done = 1).
		
		WriteToDataMem:process 
			file outDmemfile : text open write_mode is dataMemResult;
			variable    linetomem			: STD_LOGIC_VECTOR(Dwidth-1 downto 0);
			variable	good				: BOOLEAN;
			variable 	L 					: LINE;
			variable	TempAddresses		: STD_LOGIC_VECTOR(AwidthRam-1 downto 0) ; -- Awidth
			variable 	counter				: INTEGER;
		begin 

			wait until tb_done = '1'; 
			TempAddresses := (others => '0');
			counter := 1;
			while counter < 16 loop	--15 lines in file
				readAddr_Dmem_TB <= TempAddresses;
				wait until rising_edge(clk);   -- synchronize with the clock
				wait until rising_edge(clk);  
				linetomem := DATA_out_Dmem_TB;   -- read the data from the signal
				hwrite(L,linetomem);
				writeline(outDmemfile,L);
				TempAddresses := TempAddresses +1;
				counter := counter +1;
			end loop ;
			file_close(outDmemfile);
			wait;
		end process;

		
end architecture rtb;		
