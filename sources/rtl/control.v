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
  o_addr_mode,
  o_rd_sel,
  o_mem_rd_mode_r,
  o_mem_wr_mode_r
);

input   logic           clk, rst;
input   logic[15:0]     i_ir_id;
input   logic[ 3:0]     i_apsr;

output  logic[ 1:0]     o_addr_mode, o_mem_rd_mode_r, o_mem_wr_mode_r;
output  logic[ 2:0]     o_alu_sel;
output  logic[ 3:0]     o_addr_rd_r;
output  logic           o_stall_id, o_stall_ex, o_stall_mem, o_stall_wb, o_registers_rd_en_r, o_rd_sel;

        logic           stall_id, stall_ex, stall_mem, stall_wb, branch_met;
        logic[ 3:0]     mem_data_access;
        logic[15:0]     ir_ex, ir_2mem;
        logic[15:0]     ir_2wb;
        

assign o_stall_id  = stall_id;
assign o_stall_ex  = stall_ex | branch_met;
assign o_stall_mem = stall_mem;
assign o_stall_wb  = stall_wb;

// temp
// temp end

addr_switch addr_switch_inst (
  .clk (clk),
  .rst (rst),

  .i_branch_met (branch_met),
  .i_ir_ex (ir_ex),

  .o_addr_mode (o_addr_mode)
);

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

  .i_stall (stall_ex),
  .i_ir (i_ir_id),
  
  .o_ir_ex_r (ir_ex),
  .o_alu_sel_r (o_alu_sel),
  .o_mem_data_access_r(mem_data_access),
  .o_mem_rd_mode_r(o_mem_rd_mode_r),
  .o_mem_wr_mode_r(o_mem_wr_mode_r)
);



ctrl_ex ctrl_ex_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (o_stall_mem),
  .i_ir (ir_ex),
  .i_apsr (i_apsr),
  
  .o_ir_mem (ir_2mem),
  .o_branch_met(branch_met)
);



ctrl_mem ctrl_mem_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (stall_wb),
  .i_ir_mem (ir_2mem),
  .o_ir_wb_r (ir_2wb),
  .o_addr_rd_r (o_addr_rd_r),
  .o_registers_rd_en_r (o_registers_rd_en_r)
);



ctrl_wb ctrl_wb_inst(
//  .clk (clk),
//  .rst (rst),
  
//  .i_stall (stall_wb),
  .i_ir_wb (ir_2wb),
  .o_rd_sel (o_rd_sel)
);


endmodule
