module ctrl_wb (
  clk,
  rst,
  
  i_stall,
  i_ir_wb
);

input   logic         clk, rst;
input   logic[15:0]   i_ir_wb;
input   logic         i_stall;

endmodule
