module ctrl_mem (
  clk,
  rst,
  
  i_stall,
  i_ir_mem,
  o_ir_wb_r,
  o_addr_rd_r,
  o_registers_rd_en_r
);

input   logic         clk, rst;
input   logic         i_stall;
input   logic[15:0]   i_ir_mem;

output  logic[15:0]   o_ir_wb_r;
output  logic         o_registers_rd_en_r;
output  logic[3:0]    o_addr_rd_r;

always_ff @(posedge clk) begin
  if(rst)
    o_ir_wb_r <= 0;
  else if(i_stall)
    o_ir_wb_r <= o_ir_wb_r;
  else
    o_ir_wb_r <= i_ir_mem;
end

always_ff @(posedge clk) begin

  if (rst) begin
      o_addr_rd_r <= 0;
      o_registers_rd_en_r <= 0;
    end
  else if(i_stall) begin
      o_registers_rd_en_r <= 0;
      o_addr_rd_r <= o_addr_rd_r;
    end
  else
    begin

      casez (i_ir_mem[15:7])
        9'b0001110??: begin // ADD
            o_addr_rd_r <= i_ir_mem[2:0];
            o_registers_rd_en_r <= 1;
          end
        9'b101100001: begin // SUB SP
            o_addr_rd_r <= 13;
            o_registers_rd_en_r <= 1;
          end
        9'b00100????: begin // MOV IMM
            o_addr_rd_r <= i_ir_mem[10:8];
            o_registers_rd_en_r <= 1;
          end
        9'b01000110?: begin // MOV REG
            o_addr_rd_r <= i_ir_mem[2:0];
            o_registers_rd_en_r <= 1;
          end
        9'b01101????: begin // LDR
            o_addr_rd_r <= i_ir_mem[2:0];
            o_registers_rd_en_r <= 1;
          end
        9'b01001????: begin // LDR (literal - PC + imm8)
            o_addr_rd_r <= i_ir_mem[10:8];
            o_registers_rd_en_r <= 1;
          end
        default:     begin // error
            o_addr_rd_r <= 0;
            o_registers_rd_en_r <= 0;
          end
      endcase
    end
end

endmodule
