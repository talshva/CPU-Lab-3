onerror {resume}
add list -width 13 /tb/tb_done
add list /tb/tb_pr_state
add list /tb/rst
add list /tb/ena
add list /tb/clk
add list /tb/TBactive
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
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
