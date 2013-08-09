vsim -novopt work.testbench

add wave /testbench/cpu_inst/clk
add wave /testbench/cpu_inst/rst
add wave -radix hexadecimal /testbench/cpu_inst/i_mem_do
add wave -radix hexadecimal /testbench/cpu_inst/o_mem_di
add wave -radix hexadecimal /testbench/cpu_inst/o_mem_addr
add wave /testbench/cpu_inst/stall_id
add wave /testbench/cpu_inst/stall_ex
add wave /testbench/cpu_inst/stall_mem
add wave /testbench/cpu_inst/stall_wb
add wave /testbench/cpu_inst/addr_mode
add wave -radix decimal /testbench/cpu_inst/imm_r
add wave -radix hexadecimal /testbench/cpu_inst/addr_rn_r
add wave -radix decimal /testbench/cpu_inst/rn_r
add wave /testbench/cpu_inst/apsr_alu
add wave /testbench/cpu_inst/alu_sel
add wave /testbench/cpu_inst/apsr_r

add wave -expand -group {ir pipeline} -radix hexadecimal /testbench/cpu_inst/mem_do
add wave -expand -group {ir pipeline} -radix hexadecimal /testbench/cpu_inst/ir_id
add wave -expand -group {ir pipeline} -radix hexadecimal /testbench/cpu_inst/control_inst/ir_ex
add wave -expand -group {ir pipeline} -radix hexadecimal /testbench/cpu_inst/control_inst/ir_2mem
add wave -expand -group {ir pipeline} -radix hexadecimal /testbench/cpu_inst/control_inst/ir_2wb

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

run
