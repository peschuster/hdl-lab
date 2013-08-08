module stall_ctrl (
  clk,
  rst,

  i_mem_data_access, // Number of mem-data access cycles, set during ID phase

  o_stall_id_r,
  o_stall_ex_r,
  o_stall_mem_r,
  o_stall_wb_r
);

input  logic          clk, rst;
input  logic  [ 3:0]  i_mem_data_access;

output logic          o_stall_id_r, o_stall_ex_r, o_stall_mem_r, o_stall_wb_r;

logic       stall;
logic [3:0] stall_counter;

assign stall = stall_counter == 0 ? 0 : 1;

always_ff @(posedge clk) begin
  if (rst) begin
    o_stall_id_r <= 0;
    o_stall_ex_r <= 0;
    o_stall_mem_r <= 0;
    o_stall_wb_r <= 0;
  end
  else begin
    o_stall_id_r  <= stall;
    o_stall_ex_r  <= stall;
    o_stall_mem_r <= stall;
    o_stall_wb_r  <= stall;
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    stall_counter <= 0;
  end
  else if (i_mem_data_access != 0) begin
    stall_counter <= i_mem_data_access;
  end
  else if (stall_counter != 0) begin
    stall_counter <= stall_counter - 1;
  end
end

endmodule
