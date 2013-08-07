stop
vsim -novopt work.decode_tb

add wave -position insertpoint  \
sim:/decode_tb/dut/clk \
sim:/decode_tb/dut/rst \
sim:/decode_tb/dut/i_ir \
sim:/decode_tb/dut/o_addrrn_r \
sim:/decode_tb/dut/o_addrrd_r \
sim:/decode_tb/dut/o_addrrt_r \
sim:/decode_tb/dut/o_imm_r

run
