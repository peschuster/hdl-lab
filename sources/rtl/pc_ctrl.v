module pc_ctrl (
  i_mode, // 00: stall, 01: normal (+2), 10: branch
  i_pc,
  i_branch,

  o_pc
);

input logic [ 1:0] i_mode; // 00: stall, 01: normal (+2), 10: branch
input logic [31:0] i_pc;
input logic [31:0] i_branch;

output logic [31:0] o_pc;

parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);

logic [ADDR_WIDTH:0] step;
logic [ADDR_WIDTH:0] result;

assign step = i_mode == 1 ? 2 : i_branch[ADDR_WIDTH:0];
assign result = i_pc[ADDR_WIDTH:0] + step;

always_comb begin
  case (i_mode)
    2'b00: // stall
      o_pc <= i_pc;
    2'b01: // normal
      o_pc <= result;
    2'b10: // branch
      o_pc <= result;
    default:
      o_pc <= i_pc;      
  endcase
end

endmodule
