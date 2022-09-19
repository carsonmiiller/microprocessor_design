onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /proc_hier_pbench/DUT/clk
add wave -noupdate /proc_hier_pbench/DUT/rst
add wave -noupdate /proc_hier_pbench/RegWrite
add wave -noupdate /proc_hier_pbench/WriteData
add wave -noupdate /proc_hier_pbench/WriteRegister
add wave -noupdate /proc_hier_pbench/PC
add wave -noupdate /proc_hier_pbench/Inst
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_IF
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_ID
add wave -noupdate -divider {Instr Mem}
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/iCacheFSM/state
add wave -noupdate /proc_hier_pbench/DUT/p0/inst_stall
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/iCacheFSM/Stall
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/iCacheFSM/CacheHit
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/iCacheFSM/Done
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/Addr
add wave -noupdate /proc_hier_pbench/DUT/p0/fetch0/instr/DataOut
add wave -noupdate -divider {Data Mem}
add wave -noupdate /proc_hier_pbench/DUT/p0/mem_stall
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/iCacheFSM/state
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/Stall
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/Done
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/Addr
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/DataIn
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/Rd
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/Wr
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/DataOut
add wave -noupdate /proc_hier_pbench/DUT/p0/memory0/dMEM/CacheHit
add wave -noupdate -divider Ex/Mem
add wave -noupdate /proc_hier_pbench/DUT/p0/iFWD/EX_MEM_A
add wave -noupdate /proc_hier_pbench/DUT/p0/iFWD/EX_MEM_B
add wave -noupdate /proc_hier_pbench/DUT/p0/iFWD/MEM_WB_A
add wave -noupdate /proc_hier_pbench/DUT/p0/iFWD/MEM_WB_B
add wave -noupdate /proc_hier_pbench/DUT/p0/ID_EX_pipe_reg/memWrite_ID
add wave -noupdate /proc_hier_pbench/DUT/p0/ID_EX_pipe_reg/memWrite_EX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3934 ns} 0}
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
WaveRestoreZoom {1489 ns} {6137 ns}
