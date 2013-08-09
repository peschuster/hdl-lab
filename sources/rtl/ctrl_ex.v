module ctrl_ex (
  clk,
  rst,
  
  i_ir,
  i_apsr,
  i_stall, 
  
  o_branch_met,
  o_ir_mem
);

input  logic          clk, rst, i_stall;
input  logic [15:0]   i_ir;
input  logic [ 3:0]   i_apsr;

output logic [15:0]   o_ir_mem;
output logic          o_branch_met;


conditions conditions_inst (
  .i_ir(i_ir),
  .i_apsr(i_apsr),
  .o_met(o_branch_met)
);


//Output ir_cache (instruction in mem-phase)
always_ff @(posedge clk) begin
  if(rst)
    o_ir_mem <= 0;
  else if (i_stall == 0)
    o_ir_mem <= i_ir;
end

endmodule
