-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

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

	SIGNAL tb_done:														STD_LOGIC := '0';
	SIGNAL tb_pr_state:													state;
	SIGNAL rst, ena, clk, TBactive, wren_Dmem_TB, wren_Pmem_TB: 		STD_LOGIC;	
	SIGNAL DATA_in_Dmem_TB, DATA_out_Dmem_TB: 							STD_LOGIC_VECTOR (Dwidth-1 downto 0); -- n
	SIGNAL DATA_in_Pmem_TB: 											STD_LOGIC_VECTOR (Dwidth-1 downto 0); -- m (m=n?)
	SIGNAL writeAddr_Dmem_TB, writeAddr_Pmem_TB:  						STD_LOGIC_VECTOR (AwidthRam-1 DOWNTO 0);
	SIGNAL readAddr_Dmem_TB:											STD_LOGIC_VECTOR (AwidthRam-1 DOWNTO 0);
	SIGNAL donePmemIn, doneDmemIn:										BOOLEAN;
	
begin
	
	L0 : top port map(
						rst => rst, ena => ena, clk => clk,
						DATA_in_Dmem => DATA_in_Dmem_TB, DATA_in_Pmem => DATA_in_Pmem_TB, 
						writeAddr_Dmem => writeAddr_Dmem_TB, writeAddr_Pmem => writeAddr_Pmem_TB,
						readAddr_Dmem => readAddr_Dmem_TB, TBactive => TBactive,
						wren_Dmem => wren_Dmem_TB, wren_Pmem => wren_Pmem_TB, 
						DATA_out_Dmem => DATA_out_Dmem_TB,
						tb_done => tb_done, tb_pr_state => tb_pr_state);
						
    
	--------- start of stimulus section (13000 ns) ------------------	
	
	--------- Rst
	gen_rst : process
	begin
	  rst <='1','0' after 100 ns;
	  wait;
	end process;	
	------------ Clock
	gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;
	
	--------- 	TB
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
		doneDmemIn <= false;
		TempAddresses := (others => '0');
	--	writeAddr_Dmem_TB <= (others => '0');
	--	wait until rising_edge(clk);
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
		--wait until rising_edge(clk);
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
	
	ena <= '1' when (doneDmemIn and donePmemIn) else '0';
	
		
	--------- Writing from Data memory (CPU) to external Data Memory file, after the program end (tb_done = 1)
	
	WriteToDataMem:process 
		file outDmemfile : text open write_mode is dataMemResult;
		variable    linetomem			: std_logic_vector(Dwidth-1 downto 0);
		variable	good				: boolean;
		variable 	L 					: line;
		variable	TempAddresses		: std_logic_vector(AwidthRam-1 downto 0) ; -- Awidth
		variable 	counter				: integer;
	begin 
		wait until tb_done = '1' ;  
		TempAddresses := (others => '0');
		readAddr_Dmem_TB <= TempAddresses;
	--	wait until rising_edge(clk);
		counter := 1;
		while counter < 16 loop	--15 lines in file
			readAddr_Dmem_TB <= TempAddresses;
			wait until rising_edge(clk); 
			wait until rising_edge(clk);
			hwrite(L,DATA_out_Dmem_TB);
			writeline(outDmemfile,L);
			TempAddresses := TempAddresses +1;
			counter := counter +1;
		end loop ;
		file_close(outDmemfile);
		wait;
	end process;
		

end architecture rtb;

