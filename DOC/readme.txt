♦ VHDL Project Overview ♦
The project consists of the following components:
#############################################################################################################################
-----------------------------------------------------------------------------------------------------------------------------
File 1: aux_package.vhd
This file contains the declarations for all other components and facilitates interconnections between files.

-----------------------------------------------------------------------------------------------------------------------------
File 2: top.vhd
This is the main module of the system and incorporates both the control and datapath modules.

Inputs:
	• rst: Reset signal to reset all the outputs of the design
	• clk: Clock signal
	• ena: Enable signal
	• DATA_in_Dmem: Input data for data memory
	• DATA_in_Pmem: Input data for program memory
	• writeAddr_Dmem: Write address for data memory
	• writeAddr_Pmem: Write address for program memory
	• readAddr_Dmem: Read address for data memory
	• TBactive: Testbench active signal
	• wren_Dmem: Write enable for data memory
	• wren_Pmem: Write enable for program memory

Outputs:
	• DATA_out_Dmem: Output data from data memory
	• tb_done: Testbench done signal
	• tb_pr_state: Testbench present state

-----------------------------------------------------------------------------------------------------------------------------
File 3: control.vhd
This module implements the control unit of the system.

Inputs:
	• rst: Reset signal to reset all the outputs of the design
	• clk: Clock signal
	• ena: Enable signal
	• add, sub, nop, unused1, jmp, jc, jnc, unused2, mov, ld, st, done, Cflag, Zflag, Nflag: OPC decoder signals (blue)

Outputs:
	• Mem_wr: Memory write signal
	• Cout: ALU Register C - out signal
	• Cin: ALU Register C - in signal
	• Ain: ALU Register A - in signal
	• RFin: Register file input signal
	• RFout: Register file output signal
	• IRin: Instruction register input signal
	• PCin: Program counter input signal
	• Imm1_in: First immediate input signal
	• Imm2_in: Second immediate input signal
	• Mem_out: Memory output signal
	• Mem_in: Memory input signal
	• OPC: Opcode signal
	• RFaddr: Register file address signal
	• PCsel: Program counter select signal
	• tb_done: Testbench done signal
	• tb_pr_state: Testbench present state

-----------------------------------------------------------------------------------------------------------------------------
File 4: datapath.vhd
This module implements the datapath of the system.

Inputs:
	• clk: Clock signal
	• TBactive: Testbench active signal
	• rst: Reset signal to reset all the outputs of the design
	• wren_Dmem_TB: Write enable for data memory 	(controlled by testbench)
	• wren_Pmem_TB: Write enable for program memory (controlled by testbench)
	• Mem_wr: Memory write signal
	• Cout: ALU Register C - out signal
	• Cin: ALU Register C - in signal
	• Ain: ALU Recister A - in signal
	• RFin: Register file input signal
	• RFout: Register file output signal
	• IRin: Instruction register input signal
	• PCin: Program counter input signal
	• Imm1_in: First immediate input signal
	• Imm2_in: Second immediate input signal
	• Mem_out: Memory output signal
	• Mem_in: Memory input signal
	• OPC: Opcode signal
	• PCsel: Program counter select signal
	• RFaddr: Register file address signal
	• DATA_in_Dmem_TB: Input data for data memory		(controlled by testbench)
	• DATA_in_Pmem_TB: Input data for program memory	(controlled by testbench)	
	• writeAddr_Dmem_TB: Write address for data memory	(controlled by testbench)
	• writeAddr_Pmem_TB: Write address for program memory	(controlled by testbench)
	• readAddr_Dmem_TB: Read address for data memory	(controlled by testbench)

Outputs:
	• add, sub, nop, unused1, jmp, jc, jnc, unused2, mov, ld, st, done, Cflag, Zflag, Nflag: OPC decoder signals (blue)
	• tb_done: Testbench flag to indicate when the test is complete
	• tb_pr_state: State of the state machine in the testbench

-----------------------------------------------------------------------------------------------------------------------------
File 5: RF.vhd:
This component implements a register file with a write enable, write data, read address, and read data.

Inputs:
	• clk: Clock signal
	• rst: Reset signal to reset all the outputs of the design
	• WregEn: Write enable signal
	• WregData: Write data input vector
	• WregAddr: Write address input vector
	• RregAddr: Read address input vector

Outputs:
	• RregData: Read data output vector

-----------------------------------------------------------------------------------------------------------------------------
File 6: ProgMem.vhd:
This component implements a program memory with a write enable, write data, read address, and read data.

Inputs:
	• clk: Clock signal
	• memEn: Memory enable signal
	• WmemData: Write data input vector
	• WmemAddr: Write address input vector
	• RmemAddr: Read address input vector

Outputs:
	• RmemData: Read data output vector

-----------------------------------------------------------------------------------------------------------------------------
File 7: dataMem.vhd:
This component implements a data memory with a write enable, write data, read address, and read data.

Inputs:
	• clk: Clock signal
	• memEn: Memory enable signal
	• WmemData: Write data input vector
	• WmemAddr: Write address input vector
	• RmemAddr: Read address input vector
Outputs:
	• RmemData: Read data output vector

-----------------------------------------------------------------------------------------------------------------------------
File 8: ALU.vhd:
This component implements an arithmetic logic unit with inputs X, Y, and OPC, and outputs Cflag, Zflag, Nflag, and s.

Inputs:
	• X: Input vector of length n
	• Y: Input vector of length n
	• OPC: Input vector of length 4

Outputs:
	• Cflag: Carry flag output
	• Zflag: Zero flag output
	• Nflag: Negative flag output
	• s: Output vector of length n

-----------------------------------------------------------------------------------------------------------------------------
File 9: FA.vhd:
This component implements a full adder with inputs xi, yi, and cin, and outputs s and cout.

Inputs:
	• xi: Input signal
	• yi: Input signal
	• cin: Input signal

Outputs:
	• s: Output signal
	• cout: Carry-out signal

-----------------------------------------------------------------------------------------------------------------------------
File 10: BidirPinBasic.vhd:
This component implements a bidirectional pin with separate write and read signals.

Inputs:
	• writePin: Input signal

Outputs:
	• readPin: Output signal

Inouts:
	• bidirPin: Bidirectional signal

-----------------------------------------------------------------------------------------------------------------------------
File 11: BidirPin.vhd:
This component implements a bidirectional BUS with separate data in and out signals.

Inputs:
	• Dout: Input vector of length width
	• en: Input signal

Outputs:
	• Din: Output vector of length width

Inouts:
	• IOpin: Bidirectional vector of length width

-----------------------------------------------------------------------------------------------------------------------------

♥ Note: Please refer to the respective component files for detailed implementations of the processes and functionalities. ♥

-----------------------------------------------------------------------------------------------------------------------------