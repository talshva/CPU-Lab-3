onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/Mem_wr
add wave -noupdate /tb/Cout
add wave -noupdate /tb/Cin
add wave -noupdate /tb/Ain
add wave -noupdate /tb/RFin
add wave -noupdate /tb/RFout
add wave -noupdate /tb/IRin
add wave -noupdate /tb/PCin
add wave -noupdate /tb/Imm1_in
add wave -noupdate /tb/Imm2_in
add wave -noupdate /tb/Mem_out
add wave -noupdate /tb/Mem_in
add wave -noupdate /tb/add
add wave -noupdate /tb/sub
add wave -noupdate /tb/nop
add wave -noupdate /tb/unused1
add wave -noupdate /tb/jmp
add wave -noupdate /tb/jc
add wave -noupdate /tb/jnc
add wave -noupdate /tb/unused2
add wave -noupdate /tb/mov
add wave -noupdate /tb/ld
add wave -noupdate /tb/st
add wave -noupdate /tb/done
add wave -noupdate /tb/tb_done
add wave -noupdate /tb/OPC
add wave -noupdate /tb/PCsel
add wave -noupdate /tb/RFaddr
add wave -noupdate /tb/clk
add wave -noupdate /tb/TBactive
add wave -noupdate /tb/rst
add wave -noupdate /tb/wren_Dmem_TB
add wave -noupdate /tb/wren_Pmem_TB
add wave -noupdate /tb/DATA_in_Dmem_TB
add wave -noupdate /tb/DATA_out_Dmem_TB
add wave -noupdate /tb/DATA_in_Pmem_TB
add wave -noupdate /tb/writeAddr_Dmem_TB
add wave -noupdate /tb/writeAddr_Pmem_TB
add wave -noupdate /tb/readAddr_Dmem_TB
add wave -noupdate /tb/donePmemIn
add wave -noupdate /tb/doneDmemIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {965219 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {11998036 ps}
