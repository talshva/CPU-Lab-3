library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;
---------------------------------------------------------
entity tb is
end tb;
---------------------------------------------------------
architecture rtb of tb is
	--tb:	
	SIGNAL clk, rst, ena, tb_done:								STD_LOGIC; 
	SIGNAL tb_pr_state: 										state;
	
	--blue signals:
	SIGNAL add, sub, nop, unused1, jmp, jc, jnc, unused2: 		STD_LOGIC; 
	SIGNAL mov, ld, st, done, Cflag, Zflag, Nflag: 				STD_LOGIC;

	--red signals:
	SIGNAL Mem_wr, Cout, Cin, Ain, RFin, RFout: 				STD_LOGIC; 
	SIGNAL IRin, PCin, Imm1_in, Imm2_in, Mem_out, Mem_in: 		STD_LOGIC; 
	SIGNAL OPC: 												STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL PCsel, RFaddr: 										STD_LOGIC_VECTOR (1 downto 0);
		 
begin

	L0: Control PORT MAP (
							rst, ena, clk,
							add, sub, nop, unused1, jmp, jc, jnc, unused2,
							mov, ld, st, done, Cflag, Zflag, Nflag,
							Mem_wr, Cout, Cin, Ain, RFin, RFout,
							IRin, PCin, Imm1_in, Imm2_in, Mem_out, Mem_in,
							OPC, RFaddr, PCsel,
							tb_done, tb_pr_state);	
	--------- start of stimulus section ------------------	
	gen_clk : process
        begin
		  clk <= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
	
	StartTb : process
		begin
			ena 	<= '1';
			rst 	<= '1';
			add 	<= '0';
			sub 	<= '0';
			nop 	<= '0';
			unused1 <= '0';
			jmp 	<= '0';
			jc 		<= '0';
			jnc 	<= '0';
			unused2 <= '0';
			mov		<= '0';
			ld 		<= '0';
			st 		<= '0';
			done 	<= '0';
			Cflag	<= '0';
			Zflag 	<= '0';
			Nflag 	<= '0';
			
			wait for 200 ns;
			rst <= '0';
			add <= '1';
			wait for 500 ns; -- 5 cycles per R-type
			add <= '0';
			sub <= '1';
			wait for 500 ns; -- 5 cycles per R-type
			sub <= '0';
			nop <= '1';
			wait for 500 ns; -- 5 cycles per R-type
			nop <= '0';
			unused1 <= '1';
			wait for 500 ns; -- 5 cycles per R-type
			unused1 <= '0';
			jmp <= '1';
			wait for 300 ns; -- 3 cycles per  J-type
			jmp <= '0';
			Cflag <= '1';
			jc <= '1';
			wait for 300 ns; -- 3 cycles per  J-type
			jc <= '0';
			Cflag <= '0';
			jnc <= '1';
			wait for 300 ns; -- 3 cycles per  J-type
			jnc <= '0';
			unused2 <= '1';
			wait for 300 ns; -- 3 cycles per non- J-type
			unused2 <= '0';
			mov <= '1';
			wait for 300 ns; -- 3 cycles per I-type "mov"
			mov <= '0';
			ld <= '1';
			wait for 600 ns; -- 6 cycles per I-type "load"
			ld <= '0';
			st <= '1';
			wait for 600 ns; -- 6 cycles per I-type "store"
			st <= '0';
			done <= '1';
			ena <= '0';
			wait for 200 ns; -- 4 cycles per I-type "done", end simulation earlier. (Total of 5600 ns)
			done <= '0';
			
			wait;
			
	end process;
end architecture rtb;