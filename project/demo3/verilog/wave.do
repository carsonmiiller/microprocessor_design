onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_hier_pbench/PC
add wave -noupdate /proc_hier_pbench/Inst
add wave -noupdate /proc_hier_pbench/DUT/clk
add wave -noupdate /proc_hier_pbench/DUT/rst
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_ID
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_IF
add wave -noupdate /proc_hier_pbench/DUT/p0/mem_stall
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_stall
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Addr
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/DataIn
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Rd
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Wr
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/DataOut
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Done
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {347 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {740 ns}
