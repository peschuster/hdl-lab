module ir_cache_ctrl (
  clk,
  rst,
  stall,

  i_data,
  o_data
);

input   logic         clk, rst, stall;
input   logic[15:0]   i_data;
output  logic[15:0]   o_data;

        logic         stall_1_r, stall_2_r;
        logic[15:0]   ir_cache;

always_ff @(posedge clk) begin
  if(rst)
    stall_1_r <= 0;
  else if(stall)
    stall_1_r <= 1;
  else
    stall_1_r <= 0;
end

always_ff @(posedge clk) begin
  if(rst)
    stall_2_r <= 0;
  else
    stall_2_r <= stall_1_r;
end

always_ff @(posedge clk) begin
  if(rst)
    ir_cache <= 0;
  else if(~stall_2_r) 
    ir_cache <= i_data;
  else
    ir_cache <= ir_cache;
end

always_comb begin
  if(stall_2_r)
    o_data = ir_cache;
  else
    o_data = i_data;
end


endmodule
