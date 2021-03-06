module stall_ctrl (
  clk,
  rst,

  i_branch_met,
  i_mem_data_access, // Number of mem-data access cycles, set during ID phase

  o_stall_id_r,
  o_stall_ex_r,
  o_stall_mem_r,
  o_stall_wb_r
);

input  logic          clk, rst, i_branch_met;
input  logic  [ 3:0]  i_mem_data_access;

output logic          o_stall_id_r, o_stall_ex_r, o_stall_mem_r, o_stall_wb_r;

logic       stall;
logic [3:0] stall_counter;
logic [3:0] stall_wb_counter;

assign stall = stall_counter != 0;

always_comb begin     // _ff @(posedge clk)
//  if (rst) begin // || i_branch_met
//    o_stall_id_r <= 0;
//    o_stall_ex_r <= 0;
//    o_stall_mem_r <= 0;
//    o_stall_wb_r <= 0;
//  end
//  else begin
    o_stall_id_r  <= stall;
    o_stall_ex_r  <= stall;
    o_stall_mem_r <= stall;
    o_stall_wb_r  <= stall_wb_counter != 0 && stall_wb_counter != 1;
//  end
end

always_ff @(posedge clk) begin
  if (rst) begin  // branch condition met -> pipeline aborted, don't stall           // || i_branch_met
    stall_counter <= 0;
  end
  else if (i_mem_data_access != 0) begin
    stall_counter <= i_mem_data_access;
  end
  else if (stall_counter != 0) begin
    stall_counter <= stall_counter - 1;
  end

  if (rst)
    stall_wb_counter <= 0;
  else
    stall_wb_counter <= stall_counter;
end

endmodule
