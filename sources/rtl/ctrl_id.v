module ctrl_id(
  clk,
  rst,
  
  i_alu_sel,
  
  o_alu_sel_r
);
input   logic       clk, rst;
input   logic[2:0]  i_alu_sel;

output  logic[2:0]  o_alu_sel_r;


always_ff@(posedge clk) begin
  if(rst)
    o_alu_sel_r <= 0;
  else
    o_alu_sel_r <= i_alu_sel;
end

endmodule
