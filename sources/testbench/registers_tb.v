// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Group 6
// Email:
//
// Testbench for Register module.

`timescale 1 ns / 1 ps

module registers_tb ();

logic     clk, rst, i_rd_wr_en;

logic [ 3:0]  i_addr_rn, i_addr_rd, i_addr_rt;
logic [31:0]  i_rd, i_pc;

logic [31:0]  o_rn_r, o_rt_r, o_pc_r;

logic [15:0][31:0]  regs_r;

registers dut (
  .clk(clk),
  .rst(rst),

  .i_addr_rn(i_addr_rn),
  .i_addr_rd(i_addr_rd),
  .i_addr_rt(i_addr_rt),

  .i_rd(i_rd),
  .i_rd_wr_en(i_rd_wr_en),

  .o_rn_r(o_rn_r),
  .o_rt_r(o_rt_r),

  .i_pc(i_pc),
  .o_pc_r(o_pc_r)
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

assign i_pc = o_pc_r + 2;

//PC GENERATOR  
initial begin

end

endmodule;
