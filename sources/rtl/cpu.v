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

input  logic [0:1][7:0] i_mem_do;
output logic [0:1][7:0] o_mem_di;
output logic [ADDR_WIDTH-1:0] o_mem_addr;
output logic        o_mem_en;
output logic        o_mem_rd_en;
output logic [0:1]  o_mem_wr_en;


logic        rd_wr_en, stall_id, stall_ex, stall_mem, stall_wb;

logic [ 3:0] apsr_r;
logic [ 1:0] addr_mode; // 00: normal (+2), 01: alu-addr (ir memory), 10: mem-addr (pop), 11: alu-addr (data memory)
logic [ 3:0] addr_rn_r, addr_rd_r, addr_rt_r;
logic [31:0] imm_r;
logic [31:0] rd_r, rd_data, alu, alu_out_r;
logic [31:0] pc, pc_next, rn_r, rt_r;
logic [ 3:0] apsr_alu;
logic [ 2:0] alu_sel;

// mem signals
logic [ 1:0]            mem_wr_mode;
logic [ 1:0]            mem_rd_mode;
logic [31:0]            mem_do;
logic [ADDR_WIDTH-1:0]  mem_addr;

// rd select mux
logic                   rd_sel;

//
logic [15:0]            ir_id;

always_ff @(posedge clk) begin
  if (rst) begin
    rd_r <= 0;
    apsr_r <= 0;
    alu_out_r <= 0;
  end
  else begin
    if (stall_mem == 0) begin
      alu_out_r <= alu;
      apsr_r <= apsr_alu;
    end

    if (stall_wb == 0)
      rd_r <= alu_out_r;
  end
end

// cross-stage control module
control control_inst(
  .clk (clk),
  .rst (rst),
  
  .i_apsr(apsr_r),
  .i_ir_id (ir_id),
  
  .o_stall_id (stall_id),
  .o_stall_ex (stall_ex),
  .o_stall_mem (stall_mem),
  .o_stall_wb (stall_wb),

  .o_alu_sel (alu_sel),
  .o_addr_rd_r (addr_rd_r),
  .o_registers_rd_en_r (rd_wr_en),
  .o_addr_mode (addr_mode),
  .o_rd_sel (rd_sel),
  .o_mem_rd_mode_r (mem_rd_mode),
  .o_mem_wr_mode_r (mem_wr_mode)
);

//
// IF stage

// controller for pc and mem address
addr_ctrl #(.MEM_DEPTH(MEM_DEPTH)) addr_ctrl_inst(
  .rst(rst),
  .i_mode(addr_mode),
  .i_pc(pc),
  .i_alu_addr(alu),
  .i_mem_addr(mem_do),
  .o_addr(mem_addr),
  .o_pc(pc_next)
);

// memory
mem_ctrl #(.MEM_DEPTH(MEM_DEPTH)) mem_ctrl_inst(
  .rst (rst),
  .clk (clk),
  .i_cpu_addr (mem_addr),

  .i_cpu_data (rt_r),
  .i_mem_data (i_mem_do),  

  .i_wr_mode (mem_wr_mode),
  .i_rd_mode (mem_rd_mode),

  .o_mem_addr (o_mem_addr),
  .o_mem_data (o_mem_di),
  .o_cpu_data (mem_do),

  .o_en (o_mem_en), 
  .o_rd_en (o_mem_rd_en),
  .o_wr_en (o_mem_wr_en)
);

//
// ID stage

ir_cache_ctrl ir_cache_ctrl_inst (
  .clk(clk),
  .rst(rst),
  .stall(stall_id),

  .i_data(mem_do[15:0]),
  .o_data(ir_id)
);

// ir decoder
decode decode_inst (
  .clk(clk),
  .rst(rst),

  // inputs  
  .i_ir(ir_id),
  .i_stall(stall_ex),
  
  // outputs
  .o_addrrn_r(addr_rn_r),
  .o_addrrt_r(addr_rt_r),
  .o_imm_r(imm_r)
);

// Register file
registers registers_inst (
  .clk (clk), 
  .rst (rst), 
  .i_stall(stall_ex),
  .i_rd_wr_en (rd_wr_en),

  .i_addr_rn (addr_rn_r), 
  .i_addr_rd (addr_rd_r), 
  .i_addr_rt (addr_rt_r),
  .i_rd (rd_data), 
  .i_pc (pc_next),

  .o_rn_r (rn_r), 
  .o_rt_r (rt_r), 
  .o_pc_r (pc)
);

//
// EX stage

alu alu_inst(
  .i_imm (imm_r),
  .i_rn (rn_r),
  .i_sel (alu_sel),
  .o_result_r (alu),
  .o_apsr_r (apsr_alu)
);



//
// WB stage

// MUX for WB selection
always_comb begin
  if (rd_sel == 1) begin
    // LDR --> Memory output 
    rd_data <= mem_do;
  end 
  else begin
    // None LDR  --> Rd
    rd_data <= rd_r;
  end
end

endmodule
