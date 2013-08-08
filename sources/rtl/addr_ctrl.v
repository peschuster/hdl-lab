module addr_ctrl (
  rst,
  i_mode, // 00: normal (+2), 01: alu-addr (ir memory), 10: mem-addr (pop), 11: alu-addr (data memory)
  i_pc,
  i_alu_addr,
  i_mem_addr,
  
  o_addr,
  o_pc
);

parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);

localparam [1:0]
  MODE_NORMAL = 0,
  MODE_ALU_IR = 1,
  MODE_MEM = 2,
  MODE_ALU_DATA = 3;

input logic        rst;
input logic [ 1:0] i_mode;
input logic [31:0] i_pc, i_alu_addr, i_mem_addr;

output logic [31:0] o_pc;
output logic [ADDR_WIDTH-1:0] o_addr;

always_comb begin
  if (rst) begin
    o_addr <= 0;
  end else begin
    case (i_mode)
      MODE_NORMAL:
        o_addr <= i_pc;
      MODE_ALU_IR:
        o_addr <= i_alu_addr;
      MODE_MEM:
        o_addr <= i_mem_addr;
      MODE_ALU_DATA:
        o_addr <= i_alu_addr;
      default:
        o_addr <= i_pc;      
    endcase
  end
end

always_comb begin
  if (rst) begin
    o_pc <= 0;
  end 
  else if (i_mode == MODE_ALU_DATA) begin
    o_pc <= i_pc;
  end
  else begin
    o_pc <= o_addr + 2;
  end
end

endmodule
