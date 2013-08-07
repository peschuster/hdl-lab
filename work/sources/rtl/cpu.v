module cpu(
  clk,
  rst,

  i_mem_do,
  
  o_mem_di,
  o_mem_addr,
  o_mem_en,
  o_mem_rd_en,
  o_mem_wr_en
  );


//stores this many halfwords (1halfword=16bit=2Byte)
parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);

input logic clk, rst;

input  logic [0:1][7:0] i_mem_di;
output logic [0:1][7:0] o_mem_do;
output logic [ADDR_WIDTH-1:0] o_mem_addr;
output logic        o_mem_en;
output logic        o_mem_rd_en;
output logic [0:1]  o_mem_wr_en;


logic [ 3:0] apsr_r;
logic [ 1:0] mode_r;
logic [ 3:0] addr_rn_r, addr_rd_r, addr_rt_r;
logic [31:0] imm_r;

decode decode_inst (
  .clk(clk),
  .rst(rst),

  // inputs  
  .i_ir(i_mem_do),
  .i_apsr(apsr_r),
  
  // outputs
  .o_addrrn_r(addr_rn_r),
  .o_addrrd_r(addr_rd_r),
  .o_addrrt_r(addr_rt_r),
  .o_imm_r(imm_r),
  .o_mode_r(mode_r));

pc_ctrl #(.(MEM_DEPTH(MEM_DEPTH)) pc_ctrl_inst(
  .i_mode(mode_r), // 00: stall, 01: normal (+2), 10: branch
  .i_pc(),
  .i_branch(imm_r),
  .o_pc()
);

endmodule
