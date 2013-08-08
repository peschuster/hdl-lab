module ctrl_id(
  clk,
  rst,

  i_stall,  
  i_ir,

  o_ir_ex_r,
  o_alu_sel_r,
  o_mem_data_access_r
);

localparam [2:0]
  ALU_ADD     = 3'b000,
  ALU_SUB     = 3'b101,
  ALU_MV_IMM  = 3'b001,
  ALU_MV_REG  = 3'b010;

input   logic       clk, rst, i_stall;
input   logic[15:0] i_ir;

output  logic[15:0]  o_ir_ex_r;
output  logic[ 2:0]  o_alu_sel_r;
output  logic[ 3:0]  o_mem_data_access_r;

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
        9'b01100????: begin // STR
            o_alu_sel_r <= ALU_ADD;
          end
        9'b1101?????: begin // B
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

//Stall-control-logic
always_ff @(posedge clk) begin
  if(rst)
    o_mem_data_access_r <= 0;
  else begin
    casez (i_ir[15:11])
      9'b01101: begin // LDR
        o_mem_data_access_r <= 2;
      end
      9'b01100: begin // STR
        o_mem_data_access_r <= 2;
      end
      
      default: begin
        o_mem_data_access_r <= 0;
      end
    endcase
  end
end

endmodule
