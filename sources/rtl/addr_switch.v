module addr_switch (
  clk,
  rst,

  i_branch_met,
  i_ir_ex,

  o_addr_mode
);

localparam [1:0]
  MODE_NORMAL = 0,
  MODE_ALU_IR = 1,
  MODE_MEM = 2,
  MODE_ALU_DATA = 3;

input  logic        clk, rst, i_branch_met;
input  logic [15:0] i_ir_ex;

output logic [ 1:0] o_addr_mode;

logic [3:0] data_mode_counter;

// Mode ctrl
always_comb begin
  if (rst) begin
    o_addr_mode = 0;
  end
//  else if (i_branch_met == 1) begin
//    o_addr_mode = MODE_ALU_IR;
//  end
  else if (data_mode_counter != 0 || i_ir_ex[15:11] == 5'b01101 || i_ir_ex[15:11] == 5'b01001 || i_ir_ex[15:11] == 5'b01100) begin // LDR || LDR (literal) || STR
    o_addr_mode = MODE_ALU_DATA;
  end
  else begin
    o_addr_mode = 0;
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    data_mode_counter <= 0;
  end
  else if (i_ir_ex[15:11] == 5'b01101 || i_ir_ex[15:11] == 5'b01001 || i_ir_ex[15:11] == 5'b01100) begin // LDR || LDR (literal) || STR
    data_mode_counter <= 1;
  end
  else if (data_mode_counter != 0) begin
    data_mode_counter <= data_mode_counter - 1;
  end
end

endmodule
