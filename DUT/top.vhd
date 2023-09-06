-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

-------------------------------------
ENTITY top IS
		GENERIC (
			n : INTEGER := 16 ; 
			m : INTEGER := 16 ; 
			k : INTEGER := 4 ;
			l : INTEGER := 6); 
		PORT(rst,ena,clk : 					IN STD_LOGIC;
			 DATA_in_Dmem : 				IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 DATA_in_Pmem : 				IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 writeAddr_Dmem:				IN STD_LOGIC_VECTOR (l-1 DOWNTO 0);
			 writeAddr_Pmem:				IN STD_LOGIC_VECTOR (l-1 DOWNTO 0);
			 readAddr_Dmem:					IN STD_LOGIC_VECTOR (l-1 DOWNTO 0);
			 TBactive:						IN STD_LOGIC;
			 wren_Dmem, wren_Pmem: 			IN STD_LOGIC;
			 DATA_out_Dmem : 				OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			 tb_done : 						OUT STD_LOGIC;
			 tb_pr_state : 					OUT state);
	END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS 
		 --blue signals:
		 SIGNAL add, sub, nop, unused1, jmp, jc, jnc, unused2: 		STD_LOGIC; 
		 SIGNAL mov, ld, st, done, Cflag, Zflag, Nflag: 			STD_LOGIC; 
		 
		 --red signals:
		 SIGNAL Mem_wr, Cout, Cin, Ain, RFin, RFout: 				STD_LOGIC; 
		 SIGNAL IRin, PCin, Imm1_in, Imm2_in, Mem_out, Mem_in: 		STD_LOGIC; 
		 SIGNAL OPC: 												STD_LOGIC_VECTOR (3 downto 0);
		 SIGNAL PCsel, RFaddr: 										STD_LOGIC_VECTOR (1 downto 0);
		 

		 
BEGIN

	g1: Control PORT MAP (
							rst, ena, clk,
							add, sub, nop, unused1, jmp, jc, jnc, unused2,
							mov, ld, st, done, Cflag, Zflag, Nflag,
							Mem_wr, Cout, Cin, Ain, RFin, RFout,
							IRin, PCin, Imm1_in, Imm2_in, Mem_out, Mem_in,
							OPC, RFaddr, PCsel,
							tb_done, tb_pr_state);
							

	g2: Datapath PORT MAP (
							clk => clk, rst => rst,
							DATA_in_Dmem_TB => DATA_in_Dmem, DATA_in_Pmem_TB => DATA_in_Pmem,
							writeAddr_Dmem_TB => writeAddr_Dmem, writeAddr_Pmem_TB => writeAddr_Pmem,
							readAddr_Dmem_TB => readAddr_Dmem,
							wren_Dmem_TB => wren_Dmem, wren_Pmem_TB => wren_Pmem,
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
							DATA_out_Dmem_TB => DATA_out_Dmem);
END struct;

