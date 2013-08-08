module ctrl_ex (
  clk,
  rst,
  
  i_ir,
  i_stall, 
  o_ir_mem
);

input   logic         clk, rst, i_stall;
input   logic[15:0]   i_ir;

output  logic[15:0]   o_ir_mem;

//Output ir_cache (instruction in mem-phase)
always_ff @(posedge clk) begin
  if(rst)
    o_ir_mem <= 0;
  else
    o_ir_mem <= i_ir;
end

endmodule
