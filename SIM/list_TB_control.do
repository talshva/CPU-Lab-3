onerror {resume}
add list -width 9 /tb/clk
add list /tb/rst
add list /tb/ena
add list /tb/tb_done
add list /tb/tb_pr_state
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
add list /tb/Cflag
add list /tb/Zflag
add list /tb/Nflag
add list /tb/Mem_wr
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
add list /tb/OPC
add list /tb/PCsel
add list /tb/RFaddr
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
