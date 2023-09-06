-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352  

LIBRARY ieee;
USE ieee.std_logic_1164.all;


PACKAGE aux_package IS

-----------------------------------------------------------------
TYPE state IS (Reset, Fetch, Decode, R_1, R_2, R_WB, J, I_1, I_2, I_3, I_4);	
-----------------------------------------------------------------
	COMPONENT top IS
		GENERIC (
			n : INTEGER := 16 ; 
			m : INTEGER := 16 ; 
			k : INTEGER := 4 ;
			l : INTEGER := 6); 
		PORT(rst,ena,clk : 					IN STD_LOGIC;
			 DATA_in_Dmem : 				IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 DATA_in_Pmem : 				IN STD_LOGIC_VECTOR (m-1 DOWNTO 0);
			 writeAddr_Dmem:				IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 writeAddr_Pmem:				IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 readAddr_Dmem:					IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 TBactive:						IN STD_LOGIC;
			 wren_Dmem, wren_Pmem: 			IN STD_LOGIC;
			 DATA_out_Dmem : 				OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			 tb_done : 						OUT STD_LOGIC;
			 tb_pr_state : 					OUT state);
	END COMPONENT;
-----------------------------------------------------------------
	COMPONENT Control is
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
		tb_pr_state:										OUT state);
		
	end COMPONENT;
-----------------------------------------------------------------
	COMPONENT Datapath is
	GENERIC (n : INTEGER := 16;
		   m : INTEGER := 16;
		   k : INTEGER := 4;
		   l : INTEGER := 6); 
		   
	port (clk, TBactive,rst, wren_Dmem_TB, wren_Pmem_TB: 				IN STD_LOGIC;
		Mem_wr, Cout, Cin, Ain, RFin, RFout, IRin:						IN STD_LOGIC;
		PCin, Imm1_in, Imm2_in, Mem_out, Mem_in: 						IN STD_LOGIC;
		OPC: 															IN STD_LOGIC_VECTOR (3 downto 0);
		PCsel: 															IN STD_LOGIC_VECTOR (1 downto 0);
		RFaddr: 														IN STD_LOGIC_VECTOR (1 downto 0);
		DATA_in_Dmem_TB: 												IN STD_LOGIC_VECTOR (n-1 downto 0);
		DATA_in_Pmem_TB: 												IN STD_LOGIC_VECTOR (m-1 downto 0);
		writeAddr_Dmem_TB, writeAddr_Pmem_TB:  							IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		readAddr_Dmem_TB:												IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		add, sub, nop, unused1, jmp, jc, jnc, unused2: 					OUT STD_LOGIC;
		mov, ld, st, done, Cflag, Zflag, Nflag:							OUT STD_LOGIC;
		DATA_out_Dmem_TB:						 						OUT STD_LOGIC_VECTOR (n-1 downto 0));
		 
	end COMPONENT;
-----------------------------------------------------------------
	COMPONENT RF is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	clk,rst,WregEn: in std_logic;	
			WregData:	in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RregData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end COMPONENT;
-----------------------------------------------------------------
	COMPONENT ProgMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end COMPONENT;
-----------------------------------------------------------------
	COMPONENT dataMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end COMPONENT;
-----------------------------------------------------------------
	COMPONENT ALU IS
	GENERIC 	(n : INTEGER := 16);
	PORT (X,Y: 	IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- X[n-1:0], Y[n-1:0] goes into the ALU
		OPC: 	IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- OPC [3:0] goes into the ALU
        Cflag, Zflag, Nflag: OUT STD_LOGIC; -- bit
        s: 		OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)); -- vector of length n (MSB on the left)
	END COMPONENT;

-----------------------------------------------------------------
	COMPONENT FA IS
		PORT (xi, yi, cin: IN std_logic;
				  s, cout: OUT std_logic);
	END COMPONENT;
-----------------------------------------------------------------
	COMPONENT BidirPinBasic is
		port(   writePin: in 	std_logic;
				readPin:  out 	std_logic;
				bidirPin: inout std_logic
		);
	END COMPONENT;
-----------------------------------------------------------------
	COMPONENT BidirPin is
		generic( width: integer:=16 );
		port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
				en:		in 		std_logic;
				Din:	out		std_logic_vector(width-1 downto 0);
				IOpin: 	inout 	std_logic_vector(width-1 downto 0)
		);
	END COMPONENT;
-----------------------------------------------------------------
 
END aux_package;

