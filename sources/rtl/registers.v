// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Group 6
// Email:
//
// Register module
// manages the register set

module registers(
  clk,
  rst,

  i_addr_rn,
  i_addr_rd,
  i_addr_rt,

  i_rd,
  i_rd_wr_en,

  o_rn_r,
  o_rt_r,

  i_pc,
  o_pc_r
);

localparam [3:0]
  SP = 13,
  LR = 14,
  PC = 15;

input  logic     clk, rst, i_rd_wr_en;

input  logic [ 3:0]  i_addr_rn, i_addr_rd, i_addr_rt;
input  logic [31:0]  i_rd, i_pc;

output logic [31:0]  o_rn_r, o_rt_r, o_pc_r;

logic [15:0][31:0]  regs_r;
integer i;

assign o_pc_r = regs_r[PC];

always_ff @(posedge clk) begin
  if (rst) begin
      o_rn_r  <= 0;
      o_rt_r  <= 0;

      for (i = 0; i < 16; i=i+1) begin
        regs_r[i] <= 0;
      end
    end
  else begin
    regs_r[PC] <= i_pc;

    o_rn_r <= regs_r[i_addr_rn];
    o_rt_r <= regs_r[i_addr_rt];
    
    if (i_rd_wr_en) begin
      regs_r[i_addr_rd] <= i_rd;
    end
  end
end


endmodule
