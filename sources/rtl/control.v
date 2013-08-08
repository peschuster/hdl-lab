module control(
  clk,
  rst,
  
  i_ir_id,
  
  o_stall,  
  o_alu_sel,
  o_addr_rd_r,
  o_registers_rd_en_r
);

input   logic           clk, rst;
input   logic[15:0]     i_ir_id;

output  logic[ 2:0]     o_alu_sel;
output  logic[ 3:0]     o_addr_rd_r;
output  logic           o_stall, o_registers_rd_en_r;

        logic           stall;
        logic[ 2:0]     alu_sel;
        logic[15:0]     ir_ex, ir_2mem;
        logic[15:0]     ir_2wb;
        

assign o_stall = stall;
        
ctrl_id ctrl_id_inst(
  .clk (clk),
  .rst (rst),
  .i_stall (stall),
  
  .i_ir (i_ir_id),
  
  .o_ir_ex_r (ir_ex),
  .o_alu_sel_r (alu_sel)
);



ctrl_ex ctrl_ex_inst(
  .clk (clk),
  .rst (rst),
  
  .i_alu_sel_r (alu_sel),
  .i_ir_cache (ir_ex),
  
  .o_alu_sel (o_alu_sel),
  .o_ir_mem (ir_2mem),
  .o_stall_r(stall)
);



ctrl_mem ctrl_mem_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (stall),
  .i_ir_mem (ir_2mem),
  .o_ir_wb (ir_2wb),
  .o_addr_rd_r (o_addr_rd_r),
  .o_registers_rd_en_r (o_registers_rd_en_r)
);



ctrl_wb ctrl_wb_inst(
  .clk (clk),
  .rst (rst),
  
  .i_stall (stall),
  .i_ir_wb (ir_2wb)
);


endmodule
