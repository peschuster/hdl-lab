module ctrl_ex (
  clk,
  rst,
  
  i_alu_sel_r,
  i_ir_cache,
  
  o_alu_sel,
  o_ir_mem
);

input   logic         clk, rst;
input   logic[2:0]    i_alu_sel_r;
input   logic[15:0]   i_ir_cache;

output  logic[2:0]    o_alu_sel;
output  logic[15:0]   o_ir_mem;

assign o_alu_sel = i_alu_sel_r;

always_ff @(posedge clk) begin
  if(rst)
    o_ir_mem <= 0;
  else
    o_ir_mem <= i_ir_cache;
end

endmodule
