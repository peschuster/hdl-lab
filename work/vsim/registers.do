vsim -novopt work.registers_tb

add wave -radix unsigned -position insertpoint sim:/registers_tb/dut/*

run
