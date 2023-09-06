onerror {resume}
add list -width 12 /tb/Mem_wr
add list /tb/Cout
add list /tb/Cin
add list /tb/Ain
add list /tb/RFin
add list /tb/RFout
add list /tb/IRin
add list /tb/PCin
add list /tb/Imm1_in
add list /tb/Imm2_in
add list /tb/Mem_out
add list /tb/Mem_in
add list /tb/add
add list /tb/sub
add list /tb/nop
add list /tb/unused1
add list /tb/jmp
add list /tb/jc
add list /tb/jnc
add list /tb/unused2
add list /tb/mov
add list /tb/ld
add list /tb/st
add list /tb/done
add list /tb/tb_done
add list /tb/OPC
add list /tb/PCsel
add list /tb/RFaddr
add list /tb/clk
add list /tb/TBactive
add list /tb/rst
add list /tb/wren_Dmem_TB
add list /tb/wren_Pmem_TB
add list /tb/DATA_in_Dmem_TB
add list /tb/DATA_out_Dmem_TB
add list /tb/DATA_in_Pmem_TB
add list /tb/writeAddr_Dmem_TB
add list /tb/writeAddr_Pmem_TB
add list /tb/readAddr_Dmem_TB
add list /tb/donePmemIn
add list /tb/doneDmemIn
add list /tb/dataMemResult
add list /tb/dataMemLocation
add list /tb/progMemLocation
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
