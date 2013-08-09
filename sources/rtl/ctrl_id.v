module ctrl_id(
  clk,
  rst,

  i_stall,  
  i_ir,

  o_ir_ex_r,
  o_alu_sel_r,
  o_mem_data_access_r,
  o_mem_rd_mode_r,
  o_mem_wr_mode_r
);

localparam [2:0]
  ALU_ADD     = 3'b000,
  ALU_SUB     = 3'b101,
  ALU_MV_IMM  = 3'b001,
  ALU_MV_REG  = 3'b010;


localparam [1:0]
  MEM_MODE_NONE = 0,
  MEM_MODE_16   = 1,
  MEM_MODE_32   = 2,
  MEM_MODE_8    = 3;

input   logic       clk, rst, i_stall;
input   logic[15:0] i_ir;

output  logic[15:0]  o_ir_ex_r;
output  logic[ 2:0]  o_alu_sel_r;
output  logic[ 3:0]  o_mem_data_access_r;
output  logic[ 1:0]  o_mem_rd_mode_r, o_mem_wr_mode_r;

// Buffer ir
always_ff @(posedge clk) begin
  if (rst) begin
    o_ir_ex_r <= 0;
  end
  else if (i_stall == 0) begin
    o_ir_ex_r <= i_ir;
  end
end

// Set alu_sel signal
always_ff @(posedge clk) begin
  if (rst) begin
      o_alu_sel_r <= ALU_MV_IMM;
    end
  else
    begin

      casez (i_ir[15:7])
        9'b0001110??: begin // ADD
            o_alu_sel_r <= ALU_ADD;
          end
        9'b10101????: begin // ADD (SP + Imm)
            o_alu_sel_r <= ALU_ADD;
          end
        9'b101100001: begin // SUB SP
            o_alu_sel_r <= ALU_SUB;
          end
        9'b00100????: begin // MOV IMM
            o_alu_sel_r <= ALU_MV_IMM;
          end
        9'b01000110?: begin // MOV REG
            o_alu_sel_r <= ALU_MV_REG;
          end
        9'b01101????: begin // LDR
            o_alu_sel_r <= ALU_ADD;
          end
        9'b01001????: begin // LDR (literal - PC + imm8)
            o_alu_sel_r <= ALU_ADD;
          end
        9'b01100????: begin // STR
            o_alu_sel_r <= ALU_ADD;
          end
        9'b11100????: begin // B
            o_alu_sel_r <= ALU_ADD;
          end
        9'b1101?????: begin // B<c>
            o_alu_sel_r <= ALU_ADD;
          end
        9'b00101????: begin // CMP
            o_alu_sel_r <= ALU_SUB;
          end
        default:     begin // error
            o_alu_sel_r <= ALU_MV_IMM;
          end
      endcase;
    end
end

// Mem access ctrl
always_ff @(posedge clk) begin
  if(rst)
    o_mem_data_access_r <= 0;
    o_mem_rd_mode_r <= MEM_MODE_16;
    o_mem_wr_mode_r <= MEM_MODE_NONE;
  else begin
    casez (i_ir[15:11])
      5'b01101: begin // LDR
        o_mem_data_access_r <= 2;
        o_mem_rd_mode_r <= MEM_MODE_32;
        o_mem_wr_mode_r <= MEM_MODE_NONE;
      end
      5'b01001: begin // LDR (literal - PC + imm8)
        o_mem_data_access_r <= 2;
        o_mem_rd_mode_r <= MEM_MODE_32;
        o_mem_wr_mode_r <= MEM_MODE_NONE;
      end
      5'b01100: begin // STR
        o_mem_data_access_r <= 2;
        o_mem_rd_mode_r <= MEM_MODE_NONE;
        o_mem_wr_mode_r <= MEM_MODE_32;
      end
      default: begin
        o_mem_data_access_r <= 0;
        o_mem_rd_mode_r <= MEM_MODE_16;
        o_mem_wr_mode_r <= MEM_MODE_NONE;
      end
    endcase
  end
end

endmodule
