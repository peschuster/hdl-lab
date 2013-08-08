vsim -novopt work.addr_ctrl_tb

add wave sim:/addr_ctrl_tb/clk
add wave -radix unsigned sim:/addr_ctrl_tb/dut/*

run
