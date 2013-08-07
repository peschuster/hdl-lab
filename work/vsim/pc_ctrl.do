stop
vsim -novopt work.pc_ctrl_tb

add wave -radix unsigned -position insertpoint sim:/pc_ctrl_tb/dut/*

run
