// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Group 6
// Email:
//
// Testbench for decode module.

`timescale 1 ns / 1 ps

module decode_tb;

// INTERNAL SIGNALS
logic clk;
logic rst;

logic [15:0]  i_ir;
logic [3:0]  o_addrrn_r;
logic [3:0]  o_addrrd_r;
logic [3:0]  o_addrrt_r;
logic [31:0] o_imm_r;
logic [3:0]  apsr;
logic [1:0]  mode_r;
logic [2:0]  alusel_r;

// MODULE INSTANTIATION
decode
dut
(   .clk (clk),
    .rst (rst),
    .i_ir (i_ir),
    .i_apsr (apsr),
    .o_addrrn_r (o_addrrn_r),
    .o_addrrd_r (o_addrrd_r),
    .o_addrrt_r (o_addrrt_r),
    .o_imm_r    (o_imm_r),
    .o_mode_r   (mode_r),
    .o_alusel_r (alusel_r)
);

 
//CLOCK GENERATOR
initial begin
	clk = 1'b0;
	forever #1  clk = !clk;
end

//RESET GENERATOR  
initial begin
	rst			= 1'b1;
	#2 rst	= 1'b0;
end

//DATA GENERATOR  
initial begin
	// i_ir = 16'b101100001_0000001; // sub
	i_ir = 16'b0001110_001_010_011; // add 1+r2->r3

  #500 $finish;
end

endmodule
