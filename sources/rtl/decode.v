// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Group 6
// Email:
//
// decoder module.
// decodes every supported command for the cpu

module decode(
  clk,
  rst,

  // inputs  
  i_ir,
  i_stall,
  
  // outputs
  o_addrrn_r,
  o_addrrt_r,
  o_imm_r
);

input  logic   clk, rst, i_stall;
input  logic [15:0]  i_ir;

output logic [ 3:0]  o_addrrn_r, o_addrrt_r;
output logic [31:0] o_imm_r;

always_comb begin
  casez (i_ir[15:7])
    9'b0001110??: begin // ADD
        o_addrrn_r = i_ir[5:3];
        o_addrrt_r = 0;
      end
    9'b101100001: begin // SUB SP
        o_addrrn_r = 13; // 13=SP
        o_addrrt_r = 0;
      end
    9'b00100????: begin // MOV IMM
        o_addrrn_r = 0;
        o_addrrt_r = 0;
      end
    9'b01000110?: begin // MOV REG
        o_addrrn_r = i_ir[6:3];
        o_addrrt_r = 0;
      end
    9'b01101????: begin // LDR
        o_addrrn_r = i_ir[5:3];
        o_addrrt_r = 0;
      end
    9'b01001????: begin // LDR (literal - PC + imm8)
        o_addrrn_r = 15; // 15=PC
        o_addrrt_r = 0;
      end
    9'b01100????: begin // STR
        o_addrrn_r = i_ir[5:3];
        o_addrrt_r = i_ir[2:0];
      end
    9'b11100????: begin // B
        o_addrrn_r = 15; // PC register
        o_addrrt_r = 0;
      end
    9'b1101?????: begin // B<c>
        o_addrrn_r = 15; // PC register
        o_addrrt_r = 0;
      end
    9'b00101????: begin // CMP
        o_addrrn_r = i_ir[10:8];
        o_addrrt_r = 0;
      end
    default:     begin // error
        o_addrrn_r = 0;
        o_addrrt_r = 0;
      end
  endcase
end

always_ff @(posedge clk) begin

  if (rst) begin
      o_imm_r <= 0;
    end
  else if (i_stall == 0)
    begin
      casez (i_ir[15:7])
        9'b0001110??: begin // ADD
            o_imm_r <= i_ir[8:6];
          end
        9'b101100001: begin // SUB SP
            o_imm_r <= i_ir[6:0];
          end
        9'b00100????: begin // MOV IMM
            o_imm_r <= i_ir[7:0];
          end
        9'b01000110?: begin // MOV REG
            o_imm_r <= 0;
          end
        9'b01101????: begin // LDR
            o_imm_r <= i_ir[10:6];
          end
        9'b01001????: begin // LDR (literal - PC + imm8)
            o_imm_r <= { i_ir[7:0], 2'b00 };
          end
        9'b01100????: begin // STR
            o_imm_r <= i_ir[10:6];
          end
        9'b11100????: begin // B
            o_imm_r <= { { 21 { i_ir[10] } }, i_ir[9:0], 1'b0 }; // SignExtend(i_ir[10:0]:'0')
          end
        9'b1101?????: begin // B<c>
            o_imm_r <= { { 24 { i_ir[7] } }, i_ir[6:0], 1'b0 }; // SignExtend(i_ir[7:0]:'0')
          end
        9'b00101????: begin // CMP
            o_imm_r <= i_ir[7:0];
          end
        default:     begin // error
            o_imm_r <= 0;
          end
      endcase;
    end
end

endmodule
