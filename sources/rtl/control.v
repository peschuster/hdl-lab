module control(
  clk,
  rst,
  
  i_ir_id,
  i_apsr,
  
  o_stall_id,
  o_stall_ex,
  o_stall_mem,
  o_stall_wb,

  o_alu_sel,
  o_addr_rd_r,
  o_registers_rd_en_r,
  o_addr_mode
);

input   logic           clk, rst;
input   logic[15:0]     i_ir_id;
input   logic[ 3:0]     i_apsr;

output  logic[ 1:0]     o_addr_mode;
output  logic[ 2:0]     o_alu_sel;
output  logic[ 3:0]     o_addr_rd_r;
output  logic           o_stall_id, o_stall_ex, o_stall_mem, o_stall_wb, o_registers_rd_en_r;

        logic           stall_id, stall_ex, stall_mem, stall_wb, branch_met;
        logic[ 3:0]     mem_data_access;
        logic[15:0]     ir_ex, ir_2mem;
        logic[15:0]     ir_2wb;
        

assign o_stall_id  = stall_id;
assign o_stall_ex  = stall_ex | branch_met;
assign o_stall_mem = stall_mem;
assign o_stall_wb  = stall_wb;

// temp

// Mode ctrl
always_comb begin
  if (rst) begin
    o_addr_mode = 0;
    branch_met = 0;
  end
  else if (ir_ex[15:11] == 5'b11100) begin
    o_addr_mode = 1;  // 01: alu-addr (IR)
    branch_met = 1;
  end
  else if (ir_ex[15:12] == 4'b1101) begin
    if (i_apsr[2] == 1 || i_apsr[3] != i_apsr[0]) begin
      o_addr_mode = 1;  // 01: alu-addr (IR)
      branch_met = 1;
    end
    else begin
      o_addr_mode = 0;
      branch_met = 0;
    end
  end
  else begin
    o_addr_mode = 0;
    branch_met = 0;
  end
end
// temp end

stall_ctrl stall_ctrl_inst (
  .clk (clk),
  .rst (rst),
  .i_branch_met (branch_met),
  .i_mem_data_access (mem_data_access), // Number of mem-data access cycles, set during ID phase
  .o_stall_id_r (stall_id),
  .o_stall_ex_r (stall_ex),
  .o_stall_mem_r (stall_mem),
  .o_stall_wb_r (stall_wb)
);

       
ctrl_id ctrl_id_inst(
  .clk (clk),
  .rst (rst),

  .i_stall (stall_id),
  .i_ir (i_ir_id),
  
  .o_ir_ex_r (ir_ex),
  .o_alu_sel_r (o_alu_sel),
  .o_mem_data_access_r(mem_data_access)
);



ctrl_ex ctrl_ex_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (o_stall_ex),
  .i_ir (ir_ex),
  
  .o_ir_mem (ir_2mem)
);



ctrl_mem ctrl_mem_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (stall_mem),
  .i_ir_mem (ir_2mem),
  .o_ir_wb (ir_2wb),
  .o_addr_rd_r (o_addr_rd_r),
  .o_registers_rd_en_r (o_registers_rd_en_r)
);



ctrl_wb ctrl_wb_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (stall_wb),
  .i_ir_wb (ir_2wb)
);


endmodule
