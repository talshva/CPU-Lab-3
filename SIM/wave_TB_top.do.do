onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/tb_done
add wave -noupdate /tb/tb_pr_state
add wave -noupdate /tb/rst
add wave -noupdate /tb/ena
add wave -noupdate /tb/clk
add wave -noupdate /tb/TBactive
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
WaveRestoreCursors {{Cursor 1} {1026477 ps} 0}
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
WaveRestoreZoom {0 ps} {10500 ns}
