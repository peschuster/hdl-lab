module ctrl_mem (
  clk,
  rst,
  
  i_ir_mem,
  o_ir_wb
);

input   logic         clk, rst;
input   logic[15:0]   i_ir_mem;

output  logic[15:0]   o_ir_wb;

always_ff @(posedge clk) begin
  if(rst)
    o_ir_wb <= 0;
  else
    o_ir_wb <= i_ir_mem;
end

endmodule
