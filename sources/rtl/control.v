module control(
  clk,
  rst,
  
  i_alu_sel,
  i_ir_cache,
  
  o_alu_sel
);

input   logic           clk, rst;
input   logic[ 2:0]     i_alu_sel;
input   logic[15:0]     i_ir_cache;

output  logic[ 2:0]     o_alu_sel;
output  logic[ 3:0]     o_adr_rd_r;
output  logic           o_registers_rd_en;

        logic[ 2:0]     alu_sel;
        logic[15:0]     ir_2mem;
        logic[15:0]     ir_2wb;
        
        
ctrl_id ctrl_id_inst(
  .clk (clk),
  .rst (rst),
  
  .i_alu_sel (i_alu_sel),
  
  .o_alu_sel_r (alu_sel)
);



ctrl_ex ctrl_ex_inst(
  .clk (clk),
  .rst (rst),
  
  .i_alu_sel_r (alu_sel),
  .i_ir_cache (i_ir_cache),
  
  .o_alu_sel (o_alu_sel),
  .o_ir_mem (ir_2mem)
);



ctrl_mem ctrl_mem_inst(
  .clk (clk),
  .rst (rst),
  
  .i_ir_mem (ir_2mem),
  .o_ir_wb (ir_2wb)
);



ctrl_wb ctrl_wb_inst(
  .clk (clk),
  .rst (rst),
  
  .i_ir_wb (ir_2wb),
  .o_addr_rd_r (o_addr_rd_r),
  .o_registers_rd_en (o_registers_rd_en)
);


endmodule
