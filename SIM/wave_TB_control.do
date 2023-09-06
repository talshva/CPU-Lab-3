onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/ena
add wave -noupdate /tb/tb_done
add wave -noupdate /tb/tb_pr_state
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
add wave -noupdate /tb/Cflag
add wave -noupdate /tb/Zflag
add wave -noupdate /tb/Nflag
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
add wave -noupdate /tb/OPC
add wave -noupdate /tb/PCsel
add wave -noupdate /tb/RFaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {714217 ps} 0}
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
WaveRestoreZoom {0 ps} {6944167 ps}
